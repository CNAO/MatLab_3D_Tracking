%% Optimization of non-linear optic system
clear; clc;
% Global variables definition
%Initial value of Sextupole, Octupole and Decapole gradient
ks1=0.;ks2=0.;ks3=0.;ks4=0;ksex=0;
%Function recall optimization file
f=@Optimization;
%Definition of optimization parameters
Parameters = [ks1,ks2,ks3,ks4,ksex];
% Boundaries
lb =[-1, -10, 0, -2E+4, -100]; %Low boundaries
ub =[ 1,   0, 100, -1E+4,    0]; %Up boundaries
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
[results,fval]=fmincon(f,Parameters,A,b,Aeq,beq,lb,ub,[], options)

return
%% Results of LINEAR optimization

% Read the output file of tracking
fid=fopen('..\Output_Particles\Local_Output_lf_L15mm_n7.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Output_Particles\Local_Output_lf_L15mm_n7.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];

% Write main program in mad-x in wich change everytime the gradient
% Write_MADX_mainfile(0,0,0);
% Run mad-x
[status]=system('madx.exe main_decapole.madx > nul');
if ( status ~= 0 )
    error("error in running MADX!");
end
% Read output tracking file of mad-x
[Xf_t,Xm_t]=Load_Final_Vector();
% Compare the two vector (absolute error)
R_f=Xf-Xf_t;
diff_f=max(abs(R_f))

figure; hold on;
plot(Xf(:,1),Xf(:,2),'ko');
xlabel('x [m]'); ylabel('px [m]');

figure; hold on;
plot(Xf(:,3),Xf(:,4),'ko');
xlabel('y [m]'); ylabel('py [m]');

% plot(Xf_t(:,1),Xf_t(:,3),'xg');
% legend('Tracking MATLAB', 'PTC Reconstruction');
legend('Tracking MATLAB', 'PTC Linear');

xlabel('x [m]'); ylabel('y [m]');

R_m=Xm-Xm_t;
diff_m=max(abs(R_m))

diff=(diff_m)+(diff_f);
fprintf('%12.12f\t',diff_f)
fprintf('%12.12f\t',diff_m)
fprintf('\n')
