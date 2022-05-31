%% Post processing of NON-LINEAR optimization


clc; clear; close all;

load('Results_SIG_0_48mm_45Gradi_n7_15mm_v1.mat')



% Read the output file of tracking
fid=fopen('..\Output_Particles\Local_Output_LF_SIG_0_48mm_45Gradi_n7_15mm.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Output_Particles\Local_Output_LM_SIG_0_48mm_45Gradi_n7_15mm.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of middle local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];

% Write main program in mad-x in wich change everytime the gradient
Parameters = 0*Parameters;
kl1=Parameters(1); kl2=Parameters(2) ;kl3=Parameters(3);kl4=Parameters(4);ksex=Parameters(5);
Write_MADX_mainfile_higher(kl1,kl2,kl3,kl4,ksex)
% Run mad-x
[status]=system('madx.exe main_decapole.madx > nul');
if ( status ~= 0 )
    error("error in running MADX!");
end
% Read output tracking file of mad-x
[Xf_t,Xm_t]=Load_Final_Vector();
% Compare the two vector (absolute error)
R_f=Xf-Xf_t;
diff_f=max(abs(R_f));

%% Plot at the end of the tracking
% plot togheter
figure; 
subplot(3,1,1); hold on; title('At the end of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,3)*1.0E+3,'ko');
plot(Xm_t(:,1)*1.0E+3,Xm_t(:,3)*1.0E+3,'rx');plot(Xm(:,1)*1.0E+3,Xm(:,3)*1.0E+3,'ko');
plot(Xm_t(:,1)*1.0E+3,Xm_t(:,3)*1.0E+3,'rx');
legend('Tracking MATLAB', 'PTC Reconstruction'); xlabel('x [mm]'); ylabel('y [mm]');

subplot(3,1,2); hold on;
plot(Xf(:,1)*1.0E+3,Xf(:,2)*1.0E+3,'ko'); plot(Xf_t(:,1)*1.0E+3,Xf_t(:,2)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction'); 
xlabel('x [mm]'); ylabel('xp [mrad]');

subplot(3,1,3); hold on;
plot(Xf(:,3)*1.0E+3,Xf(:,4)*1.0E+3,'ko'); plot(Xf_t(:,3)*1.0E+3,Xf_t(:,4)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction'); 
xlabel('y [mm]'); ylabel('py [mm]');

% plot differences
figure; 
subplot(3,1,1); hold on; title('At the end of the tracking')
plot(Xf(:,1)-Xf_t(:,1),Xf(:,3)-Xf_t(:,3),'b.');
xlabel('\Deltax [m]'); ylabel('\Deltay [m]');

subplot(3,1,2); hold on;
plot(Xf(:,1)-Xf_t(:,1),Xf(:,2)-Xf_t(:,2),'b.'); 
xlabel('\Deltax [m]'); ylabel('\Deltaxp [rad]');

subplot(3,1,3); hold on;
plot(Xf(:,3)-Xf_t(:,3),Xf(:,4)-Xf_t(:,4),'b.');
xlabel('\Deltay [m]'); ylabel('\Deltapy [m]');

%% Plot in the middle of the tracking
figure; 
subplot(3,1,1); hold on;title('In the middle of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,3)*1.0E+3,'ko');
plot(Xm_t(:,1)*1.0E+3,Xm_t(:,3)*1.0E+3,'rx');
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
subplot(3,1,1); hold on; title('At the end of the tracking')
plot(Xm(:,1)-Xm_t(:,1),Xm(:,3)-Xm_t(:,3),'b.');
xlabel('\Deltax [m]'); ylabel('\Deltay [m]');

subplot(3,1,2); hold on;
plot(Xm(:,1)-Xm_t(:,1),Xm(:,2)-Xm_t(:,2),'b.'); 
xlabel('\Deltax [m]'); ylabel('\Deltaxp [rad]');

subplot(3,1,3); hold on;
plot(Xm(:,3)-Xm_t(:,3),Xm(:,4)-Xm_t(:,4),'b.');
xlabel('\Deltay [m]'); ylabel('\Deltapy [m]');

autoArrangeFigures(2,2,1)
 
R_m=Xm-Xm_t;
diff_m=max(abs(R_m));

diff=(diff_m)+(diff_f);

fprintf('The parameters are %4.8f \n', Parameters*6.6);
fprintf('Final differences are %4.5e \n', diff_f);
fprintf('Middle differences are %4.5e \n', diff_m);
fprintf('\n');
