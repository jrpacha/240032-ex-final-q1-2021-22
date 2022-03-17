clearvars 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Consider the 1D Boundary Value Problem (BVP),
%
%   -(a(x)u')' = f(x),  0 < x < pi
%        u'(0) = u'_0,
%        u(pi) = 0
% 
% with a(x) = 1, for 0 <= x <= pi/2 and a(x) = sin(x), for pi/2 <= x <= pi 
%
% In the BVP, set f(x) = 1.0 for all 0 <= x <= pi, and let {u_n}_{n=1,..4}
% be the nodal solution of the BVP computed by the FEM using two elements:
% a quadratic one, Omega^1 = [0,pi/2], and a linear one, Omega^2 = [pi/2,pi]
% where global nodes are numbered ins ascending order from left ro right
% (so node 1 is the leftmost and node 4 is the rightmost). Therefore:
%
% PART A (4 points) The component F(3) of the global load vector is...
% PART B (4 points) The value u'_0 such that the value of u_1 is twice the
%                    value of u_3 is...
% Hint. If f(x) was also constant but half the given value, then u'_0 
% would be u'_0 = 1.4532e+00
% PART C (2 points) For the value of u'_0 found in PART B, the correspon-
%                   ding value of Q(4) is... 

f=1;
[u,du0,Q,F,K,M] = funProb1(f);

% PART A 
fprintf("PART A (4 points)\n")
fprintf("The component of F(3) of the global load vector is\n")
fprintf("F(3) = %.5e\n\n",F(3))

% PART B
fprintf("PART B (4 points)\n")
fprintf("The value u'_0 such that the value of u_1 is twice\n")
fprintf("the value of u_3 is u'_0 = %.5e\n\n",du0)

[v,dv0] = funProb1(f/2);
fprintf("Hint. If f(x) was also constant but half the given\n")
fprintf("value, then u'_0 would be u'_0 = %.5e\n\n",dv0)

% PART C
fprintf("PART C (2 points)\n")
fprintf("For the value of u'_0 found in PART B, the corres-\n")
fprintf("ponding value of Q(4) is Q(4) = %.5e\n",Q(4)) 
