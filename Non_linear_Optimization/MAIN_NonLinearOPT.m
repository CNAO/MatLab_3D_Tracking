%% Optimization of non-linear optic system
clear; clc;

% Global variables definition
global diff_old;
diff_old = 100;

%Initial value of Sextupole, Octupole and Decapole gradient
%kl0=0.0; kl1=2e-3; kl2=-3 ;kl3=-10;kl4=-0.12;ksex=1;
%kl0=0e-6; kl1=0; kl2=-0.7 ;kl3=-6;kl4=-0.08;ksex=0e-6;
kl0=0; kl1=0; kl2=-0.5 ;kl3=-7;kl4=-0.6;ksex=0e-6;
%kl0=0; kl1=0; kl2=-0.74 ;kl3=-6;kl4=-8.14;ksex=0;
%Function recall optimization file
f=@NonLinearOPT;
%Definition of optimization parameters
Parameters = [kl0,kl1,kl2,kl3,kl4,ksex];
% Boundaries
%lb =[-0.1,-0.01, -6, -15, -0.8, -0]; %Low boundaries
%ub =[0.1, 0.01,  0, -6 ,   -0.1, 1.5]; %Up boundaries
lb =[-0e-6,-0.01, -1, -8, -10, -0e-6]; %Low boundaries
ub =[0e-6, 0.01,  1, 6 ,   10, 0e-6]; %Up boundaries
%Some set definition for options
A = [];
b = [];
Aeq = [];
beq = [];
%Define precision of optimization
options =   optimoptions('fmincon', ...
            'DiffMinChange', 1.0E-3, ... 
            'TolFun', 1.0E-12, ...
            'TolX', 1.0E-12, ...
            'Algorithm','interior-point' ,...
            'PlotFcn',@optimplotfval);
%Optimization       
[results,fval]=fmincon(f,Parameters,A,b,Aeq,beq,lb,ub,[], options);