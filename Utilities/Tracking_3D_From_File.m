function settings = Tracking_3D_From_File(settings, part_file_txt)


%% Physical parameters

q  = settings.Z_n*1.602176565e-19;           % Charge [Coulomb]
% m0 = settings.A_n*1.672621777e-27;         % A_n*Proton Mass [kg]
m0 = settings.A_n*1.66053906660e-27;         % A_n*Nucleon Mass [kg]
% m0 = 9.10938356E-31*21874.66;              % mass expressed in terms of electron mass (OPERA)


c  = 299792458;                     % Speed of light [m/s]
eV_J = 1.602176565e-19;             % Ratio between eV and joule    

%% Read Input File
fid=fopen(part_file_txt,'r');

readFormat = '%f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);

x0=temp{1};          %global x coordinate [m]
y0=temp{2};          %global y coordinate [m]
z0=temp{3};          %global z coordinate [m]

Phi = temp{4}*pi/180;     %azimuthal angle [rad]
Theta = temp{5}*pi/180;   %polar angle [rad]

E_k= settings.A_n*temp{6};            %beam kinetic energy [MeV]

settings.ID = temp{7};                % Identification number

settings.N = length(x0);    %number of particles 

%% Calculation of velocities

%Calculation of the total energy [MeV]
E0 = m0*c^2 /eV_J /1e6;                         %Rest Energy: E0[eV] = mc^2 * (1eV / 1.602e-19 J) * (1MeV / 1e6 eV)
Etot_k = E0 + E_k;

%Calculation of the Momentum [MeV/c]            %Etot^2 = (mc^2)^2 + (Pc)^2 = E0^2 + (Pc)^2
P_k = sqrt(Etot_k.^2-E0^2); 

%Calculation of the Lorentz factor (Gamma)      %Etot[MeV] = mc^2 = Gamma*m0*c^2
Gamma_k = Etot_k./E0;
settings.qom = (q./(Gamma_k.*m0));               % Charge over mass

%Calculation of the velocity 
v_k = c*sqrt(1-1./(Gamma_k.^2));
settings.Br = P_k * 1e6 * eV_J / (c*q);

%Input velocities - Spherical Coordinates to Cartesian
vx0 = v_k.*cos(Phi).*sin(Theta);
vy0 = v_k.*cos(Phi).*cos(Theta);
vz0 = v_k.*sin(Phi);

%% ODE solver

%Set initial values
X0 = [x0;y0;z0;vx0;vy0;vz0].';

% Set the simulation end time (distance/velocity)
tend = 1.5/min(v_k); 

% We can stop the integration when a given event occours
% event = @(t,X)myEvent(X,settings);

% Setting the precision for the solver
opts = odeset('AbsTol',1e-6,'RelTol',1e-6,'InitialStep',(1E-3)/max(v_k));       
% opts = odeset('AbsTol',1e-6,'RelTol',1e-4,'InitialStep',(1E-3)/max(v_k),'Events', event);        

fun = @(t,X)Motion_Eq_INFN(t,X,settings);

fprintf('Calculation of the Particle Trajectories . . . \n');
[t,X] = ode45(fun,[0,tend],X0,opts);
fprintf('Calculation of the Particle Trajectories COMPLETED \n');

settings.X = X;
settings.t = t;