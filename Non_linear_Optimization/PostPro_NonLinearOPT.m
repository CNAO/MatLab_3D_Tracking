%% Post processing of NON-LINEAR optimization


%clc;
clear; close all;
%%

% Read the output file of tracking
fid=fopen('..\Output_Particles\Local_Output_lf.csv','r');
% fid=fopen('..\Output_Particles\Local_Output_LF_SIG_0_48mm_45Gradi_n7_15mm.csv','r');
% fid=fopen('..\Output_Particles\Local_Output_LF_n7_15mm_v2.csv','r');

readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Output_Particles\Local_Output_lm.csv','r');
% fid=fopen('..\Output_Particles\Local_Output_LM_SIG_0_48mm_45Gradi_n7_15mm.csv','r');
% fid=fopen('..\Output_Particles\Local_Output_LM_n7_15mm_v2.csv','r');

readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of middle local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];

% Write main program in mad-x in wich change everytime the gradient
load('Results_non_lin.mat')
Pars=Parameters;
kl0=Pars(1); kl1=Pars(2); kl2=Pars(3) ;kl3=Pars(4);kl4=Pars(5);ksex=Pars(6);
load('..\Matrix_Recostruction_Optimization\results.mat');
init_pars=results;
filename='main_decapole.madx';
%kl0=0; kl1=0; kl2=0 ;kl3=0;kl4=0;ksex=0;
Write_MADX_mainfile(init_pars,kl0,kl1,kl2,kl3,kl4,ksex,filename)

% Run mad-x
[status]=system(['madx.exe ',filename,' > nul']);
if ( status ~= 0 )
    error("error in running MADX!");
end
% Read output tracking file of mad-x
[Xf_t,Xm_t]=Load_Final_Vector();
%Compare the two vector (absolute error)
%Xf_t = flip(Xf_t);
%Xm_t = flip(Xm_t);
R_f=Xf-Xf_t;
diff_f=max(abs(R_f));

R_m=Xm-Xm_t;
diff_m=max(abs(R_m));

diff=(diff_m)+(diff_f);
np = 100;
%R_fp = prctile(abs(R_f),np,1);
%R_mp = prctile(abs(R_m),np,1);
R_fp = max(abs(R_f));
R_mp =max(abs(R_m));
Pars(5)=Pars(5)*1e+2;
fprintf('The parameters are %4.8f \n', Pars*6.6);
fprintf('Final X difference within %d%% are %4.5e \n', np, R_fp(1));
fprintf('Final PX difference within %d%% are %4.5e \n', np, R_fp(2));
fprintf('Final Y difference within %d%% are %4.5e \n', np, R_fp(3));
fprintf('Final PY difference within %d%% are %4.5e \n', np, R_fp(4));

% fprintf('Middle X difference within %d%% are %4.5e \n', np, R_mp(1));
% fprintf('Middle PX difference within %d%% are %4.5e \n', np, R_mp(2));
% fprintf('Middle Y difference within %d%% are %4.5e \n', np, R_mp(3));
% fprintf('Middle PY difference within %d%% are %4.5e \n', np, R_mp(4))
% fprintf('Final max differences are %4.5e \n', diff_f);
% fprintf('Middle max differences are %4.5e \n', diff_m);
fprintf('\n');

%% Plot at the end of the tracking

figure;  
subplot(3,1,1);
hold on; title('At the end of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,3)*1.0E+3,'ko'); plot(Xm_t(:,1)*1.0E+3,Xm_t(:,3)*1.0E+3,'rx');
legend('Tracking MATLAB', 'PTC Reconstruction'); xlabel('x [mm]'); ylabel('y [mm]');

subplot(3,1,2); hold on;
plot(Xf(:,1)*1.0E+3,Xf(:,2)*1.0E+3,'ko'); plot(Xf_t(:,1)*1.0E+3,Xf_t(:,2)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction'); 
xlabel('x [mm]'); ylabel('px [mrad]');

subplot(3,1,3); hold on;
plot(Xf(:,3)*1.0E+3,Xf(:,4)*1.0E+3,'ko'); plot(Xf_t(:,3)*1.0E+3,Xf_t(:,4)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction'); 
xlabel('y [mm]'); ylabel('py [mrad]');

% plot differences
figure; 
subplot(3,1,1); hold on; title('At the end of the tracking')
plot(Xf(:,1)-Xf_t(:,1),Xf(:,3)-Xf_t(:,3),'b.');
xlabel('\Deltax [m]'); ylabel('\Deltay [m]');

subplot(3,1,2); hold on;
plot(Xf(:,1)-Xf_t(:,1),Xf(:,2)-Xf_t(:,2),'b.'); 
xlabel('\Deltax [m]'); ylabel('\Deltapx [rad]');

subplot(3,1,3); hold on;
plot(Xf(:,3)-Xf_t(:,3),Xf(:,4)-Xf_t(:,4),'b.');
xlabel('\Deltay [m]'); ylabel('\Deltapy [m]');
return;
%% Plot in the middle of the tracking
figure; 
subplot(3,1,1); hold on;title('In the middle of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,3)*1.0E+3,'ko'); plot(Xm_t(:,1)*1.0E+3,Xm_t(:,3)*1.0E+3,'rx');
legend({'Tracking MATLAB', 'PTC Reconstruction'}); xlabel('x [mm]'); ylabel('y [mm]');

subplot(3,1,2); hold on;title('In the middle of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,2)*1.0E+3,'ko');
plot(Xm_t(:,1)*1.0E+3,Xm_t(:,2)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction');
xlabel('x [mm]'); ylabel('px [mrad]');

subplot(3,1,3); hold on;title('In the middle of the tracking')
plot(Xm(:,3)*1.0E+3,Xm(:,4)*1.0E+3,'ko');
plot(Xm_t(:,3)*1.0E+3,Xm_t(:,4)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction');
xlabel('y [mm]'); ylabel('py [mrad]');

% plot differences
figure; 
subplot(3,1,1); hold on; title('At the middle of the tracking')
plot(Xm(:,1)-Xm_t(:,1),Xm(:,3)-Xm_t(:,3),'b.');
xlabel('\Deltax [m]'); ylabel('\Deltay [m]');

subplot(3,1,2); hold on;
plot(Xm(:,1)-Xm_t(:,1),Xm(:,2)-Xm_t(:,2),'b.'); 
xlabel('\Deltax [m]'); ylabel('\Deltapx [rad]');

subplot(3,1,3); hold on;
plot(Xm(:,3)-Xm_t(:,3),Xm(:,4)-Xm_t(:,4),'b.');
xlabel('\Deltay [m]'); ylabel('\Deltapy [m]');

autoArrangeFigures(2,2,1)


return
%% Extra check for convergence at the end
figure;  
CM = jet(length(Xf));
hold on; title('At the end of the tracking')
for i=1:length(Xf)
plot3([Xf(i,1), Xf_t(i,1)]*1.0E+3,[Xf(i,3),Xf_t(i,3)]*1.0E+3,[i,i],...
    '-','Color',CM(i,:));
plot3([Xf(i,1)]*1.0E+3,[Xf(i,3)]*1.0E+3,i,...
    'x','MarkerSize',10, 'Color',CM(i,:));
plot3([Xf_t(i,1)]*1.0E+3,[Xf_t(i,3)]*1.0E+3,i,...
    'o','MarkerSize',10, 'Color',CM(i,:));
end
xlabel('x [mm]'); ylabel('y [mm]');

figure;  
hold on; title('At the end of the tracking')
for i=1:length(Xf)
plot3([Xf(i,1), Xf_t(i,1)]*1.0E+3,[Xf(i,2),Xf_t(i,2)]*1.0E+3,[i,i],...
    '-','Color',CM(i,:));
plot3([Xf(i,1)]*1.0E+3,[Xf(i,2)]*1.0E+3,i,...
    'x','MarkerSize',10, 'Color',CM(i,:));
plot3([Xf_t(i,1)]*1.0E+3,[Xf_t(i,2)]*1.0E+3,i,...
    'o','MarkerSize',10, 'Color',CM(i,:));
end
xlabel('x [mm]'); ylabel('px [mrad]');

figure;  
hold on; title('At the end of the tracking')
for i=1:length(Xf)
plot3([Xf(i,3), Xf_t(i,3)]*1.0E+3,[Xf(i,4),Xf_t(i,4)]*1.0E+3,[i,i],...
    '-','Color',CM(i,:));
plot3([Xf(i,3)]*1.0E+3,[Xf(i,4)]*1.0E+3,i,...
    'x','MarkerSize',10, 'Color',CM(i,:));
plot3([Xf_t(i,3)]*1.0E+3,[Xf_t(i,4)]*1.0E+3,i,...
    'o','MarkerSize',10, 'Color',CM(i,:));
end
xlabel('y [mm]'); ylabel('py [mrad]');
autoArrangeFigures(2,2,1)

%% Plot difference distrubitions in the phase spaces
nlin = 1:1:length(R_f);
figure; plot3(R_f(:,1)*1.0E+3,R_f(:,3)*1.0E+3,nlin,'o');
xlabel('\Deltax [mm]'); ylabel('\Deltay [mm]');
view(2); title('At the end of the tracking')

figure; plot3(R_f(:,1)*1.0E+3,R_f(:,2)*1.0E+3,nlin,'o');
xlabel('\Deltax [mm]'); ylabel('\Deltapx [mrad]');
view(2); title('At the end of the tracking')

figure; plot3(R_f(:,3)*1.0E+3,R_f(:,4)*1.0E+3,nlin,'o');
xlabel('\Deltay [mm]'); ylabel('\Deltapy [mrad]');
view(2); title('At the end of the tracking')

autoArrangeFigures(2,2,1)
return
%% Load input particles
part_file_txt = "../Input_Particles/Particle_SIG_0_gauss_bx10_ax0_1000.csv";

fileID=fopen(part_file_txt,'r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fileID,readFormat,'HeaderLines',1);
fclose(fileID);

x0 = -temp{1}; px0 = temp{2}; y0 = temp{3}; py0 = -temp{4}; 

nlin = 1:1:length(x0);
figure; plot3(x0*1.0E+3,y0*1.0E+3,nlin,'o');
xlabel('x [mm]'); ylabel('y [mm]'); title('Input Beam');
view(2); axis equal

figure; plot3(x0*1.0E+3,px0*1.0E+3,nlin,'o');
xlabel('x [mm]'); ylabel('px [mrad]');title('Input Beam');
view(2); axis equal

figure; plot3(y0*1.0E+3,py0*1.0E+3,nlin,'o');
xlabel('y [mm]'); ylabel('py [mrad]');title('Input Beam');
view(2); axis equal
autoArrangeFigures(2,2,1)