clc, clear, close all;

global set;

load('../Output_Matrix/matrix.mat');
set.MX_mad_mid_minus40cm = M{1}(1:2,1:2);
set.MY_mad_mid_minus40cm = M{1}(3:4,3:4);

set.MX_mad_mid_minus20cm = M{2}(1:2,1:2);
set.MY_mad_mid_minus20cm = M{2}(3:4,3:4);

set.MX_mad_mid = M{3}(1:2,1:2);
set.MY_mad_mid = M{3}(3:4,3:4);

set.MX_mad_mid_plus20cm = M{4}(1:2,1:2);
set.MY_mad_mid_plus20cm = M{4}(3:4,3:4);

set.MX_mad_mid_plus40cm = M{5}(1:2,1:2);
set.MY_mad_mid_plus40cm = M{5}(3:4,3:4);

set.MX_mad_end = M{6}(1:2,1:2);
set.MY_mad_end = M{6}(3:4,3:4);

% Matrix normalization to set det(M) = 1
set.MX_mad_end = set.MX_mad_end/(det(set.MX_mad_end)^(1/2));
set.MY_mad_end = set.MY_mad_end/(det(set.MY_mad_end)^(1/2));
set.MX_mad_mid = set.MX_mad_mid/(det(set.MX_mad_mid)^(1/2));
set.MY_mad_mid = set.MY_mad_mid/(det(set.MY_mad_mid)^(1/2));
set.MX_mad_mid_minus20cm = set.MX_mad_mid_minus20cm/(det(set.MX_mad_mid_minus20cm)^(1/2));
set.MY_mad_mid_minus20cm = set.MY_mad_mid_minus20cm/(det(set.MY_mad_mid_minus20cm)^(1/2));
set.MX_mad_mid_plus20cm = set.MX_mad_mid_plus20cm/(det(set.MX_mad_mid_plus20cm)^(1/2));
set.MY_mad_mid_plus20cm = set.MY_mad_mid_plus20cm/(det(set.MY_mad_mid_plus20cm)^(1/2));
set.MX_mad_mid_minus40cm = set.MX_mad_mid_minus40cm/(det(set.MX_mad_mid_minus40cm)^(1/2));
set.MY_mad_mid_minus40cm = set.MY_mad_mid_minus40cm/(det(set.MY_mad_mid_minus40cm)^(1/2));
set.MX_mad_mid_plus40cm = set.MX_mad_mid_plus40cm/(det(set.MX_mad_mid_plus40cm)^(1/2));
set.MY_mad_mid_plus40cm = set.MY_mad_mid_plus40cm/(det(set.MY_mad_mid_plus40cm)^(1/2));

% set.theta = pi/4;
set.theta = 45.000373341639474*pi/180;
Br = 6.150376945046179;     % Equivalent to En=377.132 MeV/n
% set.R = Br/4; 


set.F= true; %set.F==true if the dipole is focussing in X, set.F==false if defocusing on X

l1 = 0.1;
% l2 = 0.0;
phi_x= 0.2;
phi_y= 0.1;
kd = 0.126;
R = 1.65;

f=@Optimization_Matrix;  

Parameters = [l1,phi_x, phi_y, kd, R];
        
% Boundaries
lb =        [0  , -0.4, -0.4, 0.0, 1.3];
ub =        [0.3,  0.4,  0.4, 0.5, 2.0];

A = [];
b = [];
Aeq = [];
beq = [];

options =   optimoptions('fmincon', ...
            'DiffMinChange', 1.0E-16, ... 
            'TolFun', 1.0E-16, ...
            'TolX', 1.0E-16, ...
            'ConstraintTolerance', 1.0E-16, ...
            'OptimalityTolerance', 1.0E-16, ...
            'StepTolerance',  1.0E-16, ...
            'Algorithm', 'interior-point', ...
            'PlotFcn',@optimplotfval);
        
[results,fval]=fmincon(f,Parameters,A,b,Aeq,beq,lb,ub,[], options)


%% Call routine to define transfer matrices
Matrix_function

l1 = results(1);
phi_x = results(2);
phi_y = results(3);
kd = results(4);
R = results(5);

% s_tot = 1.329; %total path along s calculated with tracking (G. Frisella)
% l2 = s_tot-l1-R*set.theta;
l2 = l1;
if set.F==true

    MX_end = M_Drift(l2)*M_edge(phi_x,R)*M_Dip_Quad_F(R*set.theta/2,kd,R)*...
             M_Dip_Quad_F(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_F(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_minus20cm = M_Dip_Quad_F(R*set.theta/2-0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_plus20cm  = M_Dip_Quad_F(R*set.theta/2+0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_minus40cm = M_Dip_Quad_F(R*set.theta/2-0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_plus40cm  = M_Dip_Quad_F(R*set.theta/2+0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    
    MY_end = M_Drift(l2)*M_edge(-phi_y,R)*M_Quad_D(R*set.theta/2,kd)*...
             M_Quad_D(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid = M_Quad_D(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_minus20cm = M_Quad_D(R*set.theta/2-0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_plus20cm  = M_Quad_D(R*set.theta/2+0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_minus40cm = M_Quad_D(R*set.theta/2-0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_plus40cm  = M_Quad_D(R*set.theta/2+0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    
else
    
    MX_end = M_Drift(l2)*M_edge(phi_x,R)*M_Dip_Quad_D(R*set.theta/2,kd,R)*...
             M_Dip_Quad_D(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_D(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_minus20cm = M_Dip_Quad_D(R*set.theta/2-0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_plus20cm = M_Dip_Quad_D(R*set.theta/2+0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_minus40cm = M_Dip_Quad_D(R*set.theta/2-0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
    MX_mid_plus40cm = M_Dip_Quad_D(R*set.theta/2+0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
      
    MY_end = M_Drift(l2)*M_edge(-phi_y,R)*M_Quad_F(R*set.theta/2,kd)*...
             M_Quad_F(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid = M_Quad_F(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_minus20cm = M_Quad_F(R*set.theta/2-0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_plus20cm = M_Quad_F(R*set.theta/2+0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_minus40cm = M_Quad_F(R*set.theta/2-0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    MY_mid_plus40cm = M_Quad_F(R*set.theta/2+0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
    
end


%% Residual errors on matrix elements

Rx = set.MX_mad_end-MX_end;
Ry = set.MY_mad_end-MY_end;

%% Residual errors on particles
x = linspace(-7.5E-3, 7.5E-3, 7);
y = linspace(-7.5E-3, 7.5E-3, 7);
px = linspace(-1E-3, 1E-3, 7);
py = linspace(-1E-3, 1E-3, 7);

[X,PX] = meshgrid(x,px);
[Y,PY] = meshgrid(y,py);

X = reshape(X,1,[]);
PX = reshape(PX,1,[]);
Y = reshape(Y,1,[]);
PY = reshape(PY,1,[]);

% At the end of the magnet
err = max(abs(set.MX_mad_end*[X;PX]-MX_end*[X;PX]),[],2);
fprintf('Max Error X end = %e [m] \n',err(1));
fprintf('Max Error PX end = %e [rad] \n\n',err(2));
err = max(abs(set.MY_mad_end*[X;PX]-MY_end*[X;PX]),[],2);
fprintf('Max Error Y end = %e [m] \n',err(1));
fprintf('Max Error PY end = %e [rad] \n\n',err(2));


% In the middle of the magnet
err = max(abs(set.MX_mad_mid*[X;PX]-MX_mid*[X;PX]),[],2);
fprintf('Max Error X mid = %e [m] \n',err(1));
fprintf('Max Error PX mid = %e [rad] \n\n',err(2));
err = max(abs(set.MY_mad_mid*[Y;PY]-MY_mid*[Y;PY]),[],2);
fprintf('Max Error Y mid = %e [m] \n',err(1));
fprintf('Max Error PY mid = %e [rad] \n\n',err(2));

% In the middle of the magnet MINUS 20 cm
err = max(abs(set.MX_mad_mid_minus20cm*[X;PX]-MX_mid_minus20cm*[X;PX]),[],2);
fprintf('Max Error X mid - 20 cm = %e [m] \n',err(1));
fprintf('Max Error PX mid - 20 cm = %e [rad] \n\n',err(2));
err = max(abs(set.MY_mad_mid_minus20cm*[Y;PY]-MY_mid_minus20cm*[Y;PY]),[],2);
fprintf('Max Error Y mid - 20 cm = %e [m] \n',err(1));
fprintf('Max Error PY mid - 20 cm = %e [rad] \n\n',err(2));

% In the middle of the magnet PLUS 20 cm
err = max(abs(set.MX_mad_mid_plus20cm*[X;PX]-MX_mid_plus20cm*[X;PX]),[],2);
fprintf('Max Error X mid + 20 cm = %e [m] \n',err(1));
fprintf('Max Error PX mid + 20 cm = %e [rad] \n\n',err(2));
err = max(abs(set.MY_mad_mid_plus20cm*[Y;PY]-MY_mid_plus20cm*[Y;PY]),[],2);
fprintf('Max Error Y mid + 20 cm = %e [m] \n',err(1));
fprintf('Max Error PY mid + 20 cm = %e [rad] \n\n',err(2));

% In the middle of the magnet MINUS 40 cm
err = max(abs(set.MX_mad_mid_minus40cm*[X;PX]-MX_mid_minus40cm*[X;PX]),[],2);
fprintf('Max Error X mid - 40 cm = %e [m] \n',err(1));
fprintf('Max Error PX mid - 40 cm = %e [rad] \n\n',err(2));
err = max(abs(set.MY_mad_mid_minus40cm*[Y;PY]-MY_mid_minus40cm*[Y;PY]),[],2);
fprintf('Max Error Y mid - 40 cm = %e [m] \n',err(1));
fprintf('Max Error PY mid - 40 cm = %e [rad] \n\n',err(2));


% In the middle of the magnet PLUS 40 cm
err = max(abs(set.MX_mad_mid_plus40cm*[X;PX]-MX_mid_plus40cm*[X;PX]),[],2);
fprintf('Max Error X mid + 40 cm = %e [m] \n',err(1));
fprintf('Max Error PX mid + 40 cm = %e [rad] \n\n',err(2));
err = max(abs(set.MY_mad_mid_plus40cm*[Y;PY]-MY_mid_plus40cm*[Y;PY]),[],2);
fprintf('Max Error Y mid + 40 cm = %e [m] \n',err(1));
fprintf('Max Error PY mid + 40 cm = %e [rad] \n\n',err(2));