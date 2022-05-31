%% Optimization of non-linear optic system
clear; clc;

% Global variables definition
global diff_old;
diff_old = 100;

%Initial value of Sextupole, Octupole and Decapole gradient
kl1=0; kl2=-2.5 ;kl3=0.;kl4=-3;ksex=3;
%Function recall optimization file
f=@NonLinearOPT;
%Definition of optimization parameters
Parameters = [kl1,kl2,kl3,kl4,ksex];
% Boundaries
lb =[-0.1, -5, -10, -3.5, -5]; %Low boundaries
ub =[ 0.1,  5, 10,   3.5, 5]; %Up boundaries
%Some set definition for options
A = [];
b = [];
Aeq = [];
beq = [];
%Define precision of optimization
options =   optimoptions('fmincon', ...
            'DiffMinChange', 1.0E-6, ... 
            'TolFun', 1.0E-6, ...
            'TolX', 1.0E-6, ...
            'Algorithm','interior-point' ,...
            'PlotFcn',@optimplotfval);
%Optimization       
[results,fval]=fmincon(f,Parameters,A,b,Aeq,beq,lb,ub,[], options);