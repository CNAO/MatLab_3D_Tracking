%% Optimization of non-linear optic system
clear; clc;
% Global variables definition
%Initial value of Sextupole, Octupole and Decapole gradient
ks1=0.;ks2=0.;ks3=0.;
%Function recall optimization file
f=@Optimization;
%Definition of optimization parameters
Parameters = [ks1,ks2,ks3];
% Boundaries
lb =[-11,-11,-11]; %Low boundaries
ub =[11,11,11]; %Up boundaries
%Some set definition for options
A = [];
b = [];
Aeq = [];
beq = [];
%Define precision of optimization
options =   optimoptions('fmincon', ...
            'DiffMinChange', 1.0E-6, ... 
            'TolFun', 1.0E-12, ...
            'TolX', 1.0E-12, ...
            'Algorithm','interior-point' ,...
            'PlotFcn',@optimplotfval);
%Optimization       
[results,fval]=fmincon(f,Parameters,A,b,Aeq,beq,lb,ub,[], options)

return
%% Results of LINEAR optimization

% Read the output file of tracking
fid=fopen('..\Results_Track\Output_Particles\R_2_5_f.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Results_Track\Output_Particles\R_2_5_m.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];

% Write main program in mad-x in wich change everytime the gradient
Write_MADX_mainfile(0,0,0);
% Run mad-x
[status]=system('madx.exe main_1.madx > nul');
if ( status ~= 0 )
    error("error in running MADX!");
end
% Read output tracking file of mad-x
[Xf_t,Xm_t]=Load_Final_Vector();
% Compare the two vector (absolute error)
R_f=Xf-Xf_t;
diff_f=max(abs(R_f))

R_m=Xm-Xm_t;
diff_m=max(abs(R_m))

diff=(diff_m)+(diff_f);
fprintf('%12.12f\t',diff_f)
fprintf('%12.12f\t',diff_m)
fprintf('\n')
