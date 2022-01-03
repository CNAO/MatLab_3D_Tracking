clc, clear, close all;

global set;

%%from MADx with k1=5

% set.MX_mad_mid = [0.6398360185, 0.4948397103; -1.893343755, 0.09861639999];
% set.MX_mad_end = [-0.8738033505, 0.09759862161; -2.42285906, -0.8738033505];
% 
% set.MY_mad_mid = [1.320713666,0.7753251683; 1.93972016, 1.89587942];
% set.MY_mad_end = [4.007827719, 2.939846061; 5.123629847, 4.007827719];
% 
% set.theta = pi/4;
% set.R = 1.0;

%%from MADx with k1=-5

% set.MX_mad_mid = [1.41265325,      0.7874987932  ;      2.005853478 ,       1.826072459 ];
% set.MX_mad_end = [4.159214387,        2.876059715;      5.667150871,        4.159214387 ];
% 
% set.MY_mad_mid = [0.5688516556 ,      0.4863563321;    -1.850170351 ,      0.1760703924];
% set.MY_mad_end = [-0.7996841316,      0.1712659005;      -2.104944935,      -0.7996841316];
% 
% set.theta = pi/4;
% set.R = 1.0;

%% From G. Frisella tracking and S. Mariotti field map

set.MX_mad_mid = [0.929306686940479, 0.623626892195398; -0.227550328756104, 0.923398268285016];
set.MX_mad_end = [0.698322357449967, 1.188420729295038; -0.402958420273647, 0.745537006185379];

set.MY_mad_mid = [1.003241377139279, 0.640721515817404; 0.010015506209931, 1.003191771662136];
set.MY_mad_end = [1.013745379855353, 1.332949915437622; 0.018684687786788, 1.008743555116220];

% set.theta = pi/4;
set.R = 1.65;

set.F= true; %set.F==true if the dipole is focussing in X, set.F==false if defocusing on X

l1 = 0.0;
% l2 = 0.0;
phi= -0.02;
kd = 0.1;
theta = pi/4;

f=@Optimization_Matrix;  

Parameters = [l1,phi,kd, theta];
        
% Boundaries
lb = [0   ,       -0.5, -5, pi/4*0.99];
ub = [0.25,        0.5,  5, pi/4*1.01];

A = [];
b = [];
Aeq = [];
beq = [];

options =   optimoptions('fmincon', ...
            'DiffMinChange', 1.0E-12, ... 
            'TolFun', 1.0E-12, ...
            'TolX', 1.0E-12, ...
            'Algorithm', 'active-set', ...
            'PlotFcn',@optimplotfval);
        
[results,fval]=fmincon(f,Parameters,A,b,Aeq,beq,lb,ub,[], options)


%% Call routine to define transfer matrices
Matrix_function

l1 = results(1);
% l2 = results(2);
phi = results(2);
kd = results(3);
theta = results(4);
theta*180/pi

l2 = 1.329-l1-set.R*theta;
if set.F==true

    MX_end = M_Drift(l2)*M_edge(phi,set.R)*M_Dip_Quad_F(set.R*theta/2,kd,set.R)*...
             M_Dip_Quad_F(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_F(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);

    MY_end = M_Drift(l2)*M_edge(-phi,set.R)*M_Drift(set.R*theta/2)*...
             M_Drift(set.R*theta/2)*M_edge(-phi,set.R)*M_Drift(l1);
    MY_mid = M_Drift(set.R*theta/2)*M_edge(-phi,set.R)*M_Drift(l1);
    
else
    
    MX_end = M_Drift(l2)*M_edge(phi,set.R)*M_Dip_Quad_D(set.R*theta/2,kd,set.R)*...
             M_Dip_Quad_D(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_D(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);

    MY_end = M_Drift(l2)*M_edge(-phi,set.R)*M_Drift(set.R*theta/2)*...
             M_Drift(set.R*theta/2)*M_edge(-phi,set.R)*M_Drift(l1);
    MY_mid = M_Drift(set.R*theta/2)*M_edge(-phi,set.R)*M_Drift(l1);
    
end

%% Residual error
Rx = set.MX_mad_end-MX_end
Ry = set.MY_mad_end-MY_end
