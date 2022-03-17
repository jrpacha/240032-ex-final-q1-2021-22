clearvars
close all

tempCirc=30.0;     %C Temp on the circle boundary on the right
betaTop=8.53e-6;   %W/mm^2/C: convection coefficient on the top boundary
betaBot=2.67e-6;   %W/mm^2/C: convection coefficient on the bottom boundary
tempInf=6.0;       %C: bulk temperature
kc= 0.92e-3;       %W/mm/C thermal conductivity
ff= 0.0;           %No internal heat sources

eval('RadiantTubing')

numNod=size(nodes,1);
[numElem,nmesh]=size(elem);

numbering=0;
plotElementsOld(nodes, elem, numbering);
hold on;
nodesTop=find(nodes(:,2)>9.99);
nodesBot=find(nodes(:,2)< -9.99);
nodesCirc=find(sqrt(nodes(:,1).^2+nodes(:,2).^2)<3.4);
plot(nodes(nodesTop,1),nodes(nodesTop,2),'o','markerFaceColor','red',...
    'markerSize',6)
plot(nodes(nodesBot,1),nodes(nodesBot,2),'o','markerFaceColor','blue',...
    'markerSize',6)
plot(nodes(nodesCirc,1),nodes(nodesCirc,2),'o','markerFaceColor','green',...
    'markerSize',6)
hold off

%Define Coefficients vector of the model equation
%In this case we use the Poisson coefficients defined in the problem above
a11=kc;
a12=0;
a21=a12;
a22=a11;
a00=0;
f=ff;
coeff=[a11,a12,a21,a22,a00,f];

K=zeros(numNod);
F=zeros(numNod,1);
Q=zeros(numNod,1);

for e=1:numElem
    [Ke,Fe]=bilinearQuadElement(coeff,nodes,elem,e);
    %
    % Assemble the elements
    %
    rows=[elem(e,1); elem(e,2); elem(e,3); elem(e,4)];
    colums= rows;
    K(rows,colums)=K(rows,colums)+Ke; %assembly
    if (coeff(6) ~= 0)
        F(rows)=F(rows)+Fe;
    end
end %end for elements
%we save a copy of the initial F array
%for the postprocess step
Kini= K;
Fini= F;

%Boundary Conditions
fixedNodes= nodesCirc';                    %fixed Nodes (global numbering)
freeNodes= setdiff(1:numNod,fixedNodes);   %free Nodes (global numbering)

%------------- Convetion BC
indCV=nodesTop';
[K,Q]=applyConvQuad(indCV,betaTop,tempInf,K,Q,nodes,elem);

indCV=nodesBot';
[K,Q]=applyConvQuad(indCV,betaBot,tempInf,K,Q,nodes,elem);


% ------------ Essential BC
u=zeros(numNod,1); %initialize uu vector
u(nodesCirc)=tempCirc;
Fm=F(freeNodes)-K(freeNodes,fixedNodes)*u(fixedNodes);%here u can be 
                                                      %different from zero 
                                                      %only for fixed nodes
%Reduced system
Km=K(freeNodes,freeNodes);
Fm=Fm+Q(freeNodes);

%Compute the solution
%solve the System
format short e; %just to a better view of the numbers
um=Km\Fm;
u(freeNodes)=um;

minTempTopOrig=min(u(nodesTop));


%PostProcess: Compute secondary variables and plot results
QF=Kini*u-Fini;
titol='Equation solution';
colorScale='jet';
plotContourSolution(nodes,elem,u,titol,colorScale);

clc
fprintf('====================================================\n')
fprintf('                       PROB.4                       \n')
fprintf('====================================================\n')
fprintf('********************** PART A **********************\n')
fprintf('Final temperature for node 311, u(311) = %.4e\n',u(311))
fprintf('Hint 1. The minimum computed temperature is\n%.4e\n',...
    min(u))

%Compute the propagation waste
heatFlowBot=sum(QF(nodesBot));
heatFlowTop=sum(QF(nodesTop));
heatFlow=heatFlowTop+heatFlowBot;
propagationWaste=heatFlowBot/heatFlow;

fprintf('********************** PART B **********************\n')
fprintf('Propagation Waste of the system: %.4e\n',...
    propagationWaste)
fprintf('Hint 2. Q(39) = %.4e\n',QF(39))

tempCirc=24; %Starting temperature at the circular stretch of boundary
tempCircMinTempTop=[];
while 1>0
    u(nodesCirc)=tempCirc;
    Fm=F(freeNodes)-K(freeNodes,fixedNodes)*u(fixedNodes);%here u can be 
                                                      %different from zero 
                                                      %only for fixed nod
    Fm=Fm+Q(freeNodes);                                                 
    um=Km\Fm;
    u(freeNodes)=um;
    minTempTop=min(u(nodesTop));
    tempCircMinTempTop=[tempCircMinTempTop;tempCirc,minTempTop];
    if minTempTop>=24
        break;
    else
        tempCirc=tempCirc+0.5;
    end
end

fprintf('********************** PART C **********************\n')
fprintf('1st.value of the temperature at the circular stretch\n')
fprintf('of boundary that makes the minimal value of u on the\n')
fprintf('top boundary bigger or equal to 24C: %.1f\n',...
    tempCirc)
fprintf('Hint 3. For this value, the coldest top node has    \n')
fprintf('temperature %.5e\n',minTempTop)
format long e;
tempCircMinTempTop
fprintf('****************************************************\n')





