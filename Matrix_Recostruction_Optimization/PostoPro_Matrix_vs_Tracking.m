%% Comparison beteween matrix reconstruction and trackign

global set;

% Read the output file of tracking
fid=fopen('..\Output_Particles\Local_Output_lf.csv','r');

readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Output_Particles\Local_Output_lm.csv','r');

readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of middle local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];


%% Prepare 4x4 matrix
M_track_end = zeros(4,4);   % extrapoled from tracking
M_opt_end = zeros(4,4);     % obtained from matrix optimization
M_track_mid = zeros(4,4);
M_opt_mid = zeros(4,4);

M_track_end(1:2,1:2) = set.MX_mad_end;
M_track_end(3:4,3:4) = set.MY_mad_end;
M_track_mid(1:2,1:2) = set.MX_mad_mid;
M_track_mid(3:4,3:4) = set.MY_mad_mid;

M_opt_end(1:2,1:2) = MX_end;
M_opt_end(3:4,3:4) = MY_end;
M_opt_mid(1:2,1:2) = MX_mid;
M_opt_mid(3:4,3:4) = MY_mid;

%% Calculate particle distrubion thorugh matrix
fid=fopen('..\Input_Particles\Particle_IN_15MM.csv','r');

readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
X0=[-temp{1}, temp{2}, temp{3}, -temp{4}]';

X_track_end = (M_track_end*X0)';
X_track_mid = (M_track_mid*X0)';

X_opt_end = (M_opt_end*X0)';
X_opt_mid = (M_opt_mid*X0)';


%% Assign to evaluted results and figrues
X_end = X_opt_end;
X_mid = X_opt_mid;

% X_end = X_track_end;
% X_mid = X_track_mid;
%% Calculate differences
R_f=Xf-X_end;

R_m=Xm-X_mid;

np = 100;
R_fp = prctile(abs(R_f),np,1);
R_mp = prctile(abs(R_m),np,1);
fprintf('Final X difference within %d%% are %4.5e \n', np, R_fp(1));
fprintf('Final PX difference within %d%% are %4.5e \n', np, R_fp(2));
fprintf('Final Y difference within %d%% are %4.5e \n', np, R_fp(3));
fprintf('Final PY difference within %d%% are %4.5e \n', np, R_fp(4));

fprintf('Middle X difference within %d%% are %4.5e \n', np, R_mp(1));
fprintf('Middle PX difference within %d%% are %4.5e \n', np, R_mp(2));
fprintf('Middle Y difference within %d%% are %4.5e \n', np, R_mp(3));
fprintf('Middle PY difference within %d%% are %4.5e \n', np, R_mp(4));


%% Plot at the end of the tracking

figure;  
subplot(3,1,1);
hold on; title('At the end of the tracking')
plot(Xf(:,1)*1.0E+3,Xf(:,3)*1.0E+3,'ko'); plot(X_end(:,1)*1.0E+3,X_end(:,3)*1.0E+3,'rx');
legend('Tracking MATLAB', 'Matrix Reconstruction'); xlabel('x [mm]'); ylabel('y [mm]');

subplot(3,1,2); hold on;
plot(Xf(:,1)*1.0E+3,Xf(:,2)*1.0E+3,'ko'); plot(X_end(:,1)*1.0E+3,X_end(:,2)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction'); 
xlabel('x [mm]'); ylabel('xp [mrad]');

subplot(3,1,3); hold on;
plot(Xf(:,3)*1.0E+3,Xf(:,4)*1.0E+3,'ko'); plot(X_end(:,3)*1.0E+3,X_end(:,4)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction'); 
xlabel('y [mm]'); ylabel('py [mrad]');

% plot differences
figure; 
subplot(3,1,1); hold on; title('At the end of the tracking')
plot(Xf(:,1)-X_end(:,1),Xf(:,3)-X_end(:,3),'b.');
xlabel('\Deltax [m]'); ylabel('\Deltay [m]');

subplot(3,1,2); hold on;
plot(Xf(:,1)-X_end(:,1),Xf(:,2)-X_end(:,2),'b.'); 
xlabel('\Deltax [m]'); ylabel('\Deltaxp [rad]');

subplot(3,1,3); hold on;
plot(Xf(:,3)-X_end(:,3),Xf(:,4)-X_end(:,4),'b.');
xlabel('\Deltay [m]'); ylabel('\Deltapy [m]');

%% Plot in the middle of the tracking
figure; 
subplot(3,1,1); hold on;title('In the middle of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,3)*1.0E+3,'ko'); plot(X_mid(:,1)*1.0E+3,X_mid(:,3)*1.0E+3,'rx');
legend({'Tracking MATLAB', 'PTC Reconstruction'}); xlabel('x [mm]'); ylabel('y [mm]');

subplot(3,1,2); hold on;title('In the middle of the tracking')
plot(Xm(:,1)*1.0E+3,Xm(:,2)*1.0E+3,'ko');
plot(X_mid(:,1)*1.0E+3,X_mid(:,2)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction');
xlabel('x [mm]'); ylabel('px [mrad]');

subplot(3,1,3); hold on;title('In the middle of the tracking')
plot(Xm(:,3)*1.0E+3,Xm(:,4)*1.0E+3,'ko');
plot(X_mid(:,3)*1.0E+3,X_mid(:,4)*1.0E+3,'rx');
% legend('Tracking MATLAB', 'PTC Reconstruction');
xlabel('y [mm]'); ylabel('py [mrad]');

% plot differences
figure; 
subplot(3,1,1); hold on; title('At the middle of the tracking')
plot(Xm(:,1)-X_mid(:,1),Xm(:,3)-X_mid(:,3),'b.');
xlabel('\Deltax [m]'); ylabel('\Deltay [m]');

subplot(3,1,2); hold on;
plot(Xm(:,1)-X_mid(:,1),Xm(:,2)-X_mid(:,2),'b.'); 
xlabel('\Deltax [m]'); ylabel('\Deltaxp [rad]');

subplot(3,1,3); hold on;
plot(Xm(:,3)-X_mid(:,3),Xm(:,4)-X_mid(:,4),'b.');
xlabel('\Deltay [m]'); ylabel('\Deltapy [m]');

autoArrangeFigures(2,2,1)
return;
%% Extra check for convergence at the end
figure;  
CM = jet(length(Xf));
hold on; title('At the end of the tracking')
for i=1:length(Xf)
plot3([Xf(i,1), X_end(i,1)]*1.0E+3,[Xf(i,3),X_end(i,3)]*1.0E+3,[i,i],...
    '-','Color',CM(i,:));
plot3([Xf(i,1)]*1.0E+3,[Xf(i,3)]*1.0E+3,i,...
    'x','MarkerSize',10, 'Color',CM(i,:));
plot3([X_end(i,1)]*1.0E+3,[X_end(i,3)]*1.0E+3,i,...
    'o','MarkerSize',10, 'Color',CM(i,:));
end
xlabel('x [mm]'); ylabel('y [mm]');

figure;  
hold on; title('At the end of the tracking')
for i=1:length(Xf)
plot3([Xf(i,1), X_end(i,1)]*1.0E+3,[Xf(i,2),X_end(i,2)]*1.0E+3,[i,i],...
    '-','Color',CM(i,:));
plot3([Xf(i,1)]*1.0E+3,[Xf(i,2)]*1.0E+3,i,...
    'x','MarkerSize',10, 'Color',CM(i,:));
plot3([X_end(i,1)]*1.0E+3,[X_end(i,2)]*1.0E+3,i,...
    'o','MarkerSize',10, 'Color',CM(i,:));
end
xlabel('x [mm]'); ylabel('px [mrad]');

figure;  
hold on; title('At the end of the tracking')
for i=1:length(Xf)
plot3([Xf(i,3), X_end(i,3)]*1.0E+3,[Xf(i,4),X_end(i,4)]*1.0E+3,[i,i],...
    '-','Color',CM(i,:));
plot3([Xf(i,3)]*1.0E+3,[Xf(i,4)]*1.0E+3,i,...
    'x','MarkerSize',10, 'Color',CM(i,:));
plot3([X_end(i,3)]*1.0E+3,[X_end(i,4)]*1.0E+3,i,...
    'o','MarkerSize',10, 'Color',CM(i,:));
end
xlabel('y [mm]'); ylabel('py [mrad]');
% autoArrangeFigures(2,2,1)
