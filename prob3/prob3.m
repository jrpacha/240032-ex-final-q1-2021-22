clearvars
close all

p=[4.63,3.22];

distP=@(x,y) sqrt((x-p(1,1)).^2+(y-p(1,2)).^2);

eval('meshPlaca4foratsQuad')

numNodes=size(nodes,1);
numElem=size(elem,1);

numbering=0;
plotElementsOld(nodes, elem, numbering);
hold on

%Select the nodes of the 4th. internal circular border
nodesCirc1=find(sqrt((nodes(:,1)-2).^2 + (nodes(:,2)-1).^2) < 0.501);
nodesCirc2=find(sqrt((nodes(:,1)-2).^2 + (nodes(:,2)-3).^2) < 0.501);
nodesCirc3=find(sqrt((nodes(:,1)-6).^2 + (nodes(:,2)-3).^2) < 0.501);
nodesCirc4=find(sqrt((nodes(:,1)-6).^2 + (nodes(:,2)-1).^2) < 0.501);

nodesCirc=[nodesCirc1;nodesCirc2;nodesCirc3;nodesCirc4];
plot(nodes(nodesCirc,1),nodes(nodesCirc,2),'o',...
    'markerFaceColor','red','markerSize',6)
plot(p(1,1),p(1,2),'o','markerFaceColor','blue','markerSize',6)
hold off

for e=1:numElem
    vertexs=nodes(elem(e,:),:);
    [alphas, isInside]=baryCoordQuad(vertexs, p);
    if isInside > 0
       break;
    end
end

d=alphas*[distP(vertexs(1,1),vertexs(1,2));
       distP(vertexs(2,1),vertexs(2,2));
       distP(vertexs(3,1),vertexs(3,2));
       distP(vertexs(4,1),vertexs(4,2))];
   
dCirc=distP(nodes(nodesCirc,1),nodes(nodesCirc,2));
   
clc
fprintf('====================================================\n')
fprintf('                       PROB.3                       \n')
fprintf('====================================================\n')
fprintf('********************** PART A **********************\n')
fprintf('Y-component of the 4th local node of the element    \n')
fprintf('containing p: %.4e\n',vertexs(4,2))
fprintf('Hint 1. The 3rd local node on the element containing\n')
fprintf('p is: %d\n',elem(e,3));
fprintf('********************** PART B **********************\n')
fprintf('The value of Psi2(p) is, Psi2(p) = %.4e\n',alphas(2))
fprintf('Hint 2. The interpolate distance, of the point p is \n')
fprintf('d = %.4e\n',d)
fprintf('********************** PART C **********************\n')
fprintf('Minimum value of the distance function to all the nodes\n')
fprintf('belonging to one of the four internal circular borders,\n')
fprintf('is: %.4e\n',min(dCirc))
fprintf('Hint3. The maximum value is: %.4e\n',max(dCirc))
fprintf('****************************************************\n')



