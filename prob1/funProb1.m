function [u,du0,Q,F,K,M] = funProb1(f)
a1=1.0;
h1=pi/2;
coef=a1/3/h1;
K1 = coef*[7,-8,1;...
    -8,16,-8;...
    1,-8,7];

syms x;
Psi1(x)=2-2*x/pi;
Psi2(x)=2*x/pi-1;
K11=int(diff(Psi1(x),x)*diff(Psi1(x),x)*sin(x),x,pi/2,pi);
K12=int(diff(Psi1(x),x)*diff(Psi2(x),x)*sin(x),x,pi/2,pi);
K21=K12;
K22=int(diff(Psi2(x),x)*diff(Psi2(x),x)*sin(x),x,pi/2,pi);
clear x;
K2=double([K11,K12;K21,K22]);

K=zeros(4);
M=zeros(4);
F=zeros(4,1);
Q=zeros(4,1);
u=zeros(4,1);

%Couple sitffness matrix anf load vector
rows=[1,2,3]; cols=rows;
Fe=[1;4;1];
K(rows,cols)=K1;
F(rows)=Fe;
rows=[3,4]; cols=rows;
Fe=[3;3];
K(rows,cols)=K(rows,cols)+K2;
F(rows)=F(rows)+Fe;
F=pi*f*F/12;

%Extended system
M(1:3,1:3)=K(1:3,1:3);
M(1:end,4)=[1;0;0;0];
M(4,1:end)=[0,1,-2,0];

b=[F(1:3);0];

u=M\b;
du0=u(4);
u(4)=0.0;
Q=K*u-F;
end
