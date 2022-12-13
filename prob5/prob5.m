clearvars
close all

%Data
E=1.0e8;                   %Young Modulus (N/mm)
nu=0.24;                   %Poisson's ratio (adimensional)
th=0.05;                   %thickness (mm)
forceLoad=[139201; 0.0e0]; %(Fx,Fy) traction force (in N/mm^2)
rho=1;                     %Density (kg/mm^3) (?) 
g=9.8;                     %mm/s^2
rg=-rho*g;  

nodLoads=[2, 3, 5, 6];           %Nodes the traction is applied at
nodF=[1, 7, 8];

%Define the plane elasticity problem: 
%modelProblem=1; %plane stress
%modelProblem=2; %plane strain (2)

modelProblem=1; %Plane stress

nodes=[0.0,-1.0;
    1.0, 0.0;
    1.0, 0.5;
    1.0, 1.0;
    1.5, 1.0;
    1.5, 2.0;
    0.0, 2.0;
    0.0, 0.5];

elem = [3, 8, 1, 2;
    7, 8, 3, 4;
    4, 5, 6, 7];

[numNod,ndim]=size(nodes);
numElem=size(elem,1);
numbering=1;
plotElementsOld(nodes, elem, numbering);
hold on

switch modelProblem
    case 1
        c11=E/(1-nu^2);
        c22=c11;
        c12=nu*c11;
        c21=c12;
        c33=E/(2*(1+nu));
        fprintf('Plane stress problem\n')
    case 2
        th=1.0;
        c11=E*(1-nu)/((1+nu)*(1-2*nu));
        c22=c11;
        c12=c11*nu/(1-nu);
        c21=c12;
        c33=E/(2*(1+nu));
        fprintf('Plane strain problem\n')
    otherwise
        error('modelProblem should be 1 (stress) or 2 (strain)');
end
C=[c11, c12, 0; c21, c22, 0; 0, 0, c33];

%Computation of the stiffness matrix
K=zeros(ndim*numNod);
F=zeros(ndim*numNod,1);
Q=zeros(ndim*numNod,1);
Fe=0.25*th*[0; rg; 0; rg; 0; rg; 0; rg];
for e=1:numElem
    Ke=planeElastQuadStiffMatrix(nodes,elem,e,C,th);
    %
    % Compute the Area of the element;
    %
    alpha=[nodes(elem(e,2),:)-nodes(elem(e,1),:),0];
    beta=[nodes(elem(e,4),:)-nodes(elem(e,1),:),0];  
    gamma=cross(alpha,beta);
    Ae=0.5*gamma(3);
    alpha=[nodes(elem(e,4),:)-nodes(elem(e,3),:),0];
    beta=[nodes(elem(e,2),:)-nodes(elem(e,3),:),0];  
    gamma=cross(alpha,beta)
    Ae=Ae+0.5*gamma(3);
    %
    % Assemble the stiffness matrices
    %       
    row=[2*elem(e,1)-1; 2*elem(e,1); 2*elem(e,2)-1; 2*elem(e,2); 
         2*elem(e,3)-1; 2*elem(e,3); 2*elem(e,4)-1; 2*elem(e,4)];
    col=row;
    K(row,col)=K(row,col)+Ke;
    F(row)=F(row)+Ae*Fe;
end

%%Boundary Conditions
% Natural B.C.: constant traction  on the right edge
%nodLoads=indRight'; %nodes the traction is applied at
Q=applyLoadsQuad(nodes,elem,nodLoads,Q,forceLoad);

%Essential B.C.: 
% set displacements along the hole to zero
fixedNodes=[ndim*nodF-1, ndim*nodF];
freeNodes=setdiff(1:ndim*numNod,fixedNodes);
u=zeros(ndim*numNod,1); %initialize the solution to u=0
u(fixedNodes)=0.0;

%Reduced system
%Remark: the linear system is not modified. This is only valid if the BC=0
Km=K(freeNodes,freeNodes);

Qm=Q(freeNodes);
um=Km\Qm;
u(freeNodes)=um;

%PART A
clc
fprintf('====================================================\n')
fprintf('                       PROB.5                       \n')
fprintf('====================================================\n')
fprintf('********************** PART A **********************\n')
fprintf('Value K(5,8) of the global stiffness matrix\n')
fprintf('*** K(5,8) = %.4e\n',K(5,8))
fprintf('*** Hint 1. K(3,4) = %.4e\n',K(3,4))

%PART B
nodSol=5;
fprintf('********************** PART B **********************\n')
fprintf('Value of the x-displacement of node %d\n',nodSol)
fprintf('*** U5X = %.4e\n',u(ndim*nodSol-1))
fprintf('*** Hint 2. U5Y = %.4e\n',u(ndim*nodSol))  

%Graphical output: displacements (weight is not taken into account)
esc=10; %scale for the displacements
plotPlaneNodElemDespl(nodes, elem, u, esc);

%PART C
%Add the weight of the plate
Qm=Q(freeNodes)+F(freeNodes);
%solve the system
um=Km\Qm;
u(freeNodes)=um;

%Now compute Strain and StressElement
[stress,vonMisses]=computeQuadStrainStressVM(nodes, elem, u, C);

fprintf('********************** PART C **********************\n')
fprintf('Now. we take into account the weight of the piece   \n')
fprintf('*** VM(3) = %.4e\n',vonMisses(3))
fprintf('*** Hint 3. VM(1) = %.4e\n',vonMisses(1))
fprintf('****************************************************\n')

%Graphical output: VM stress (weight is not taken into account)
titol='VonMisses Stress (taking weight into account)';
plotContourSolution(nodes,elem,vonMisses,titol,'Jet');    
