%% Main file for 3D partilce tracking
clc, clear, close all;

%% Read Magnetic and create Field Interpolation Functions 
tic

fprintf('Loading Field and create Interpolation Functions ... \n');
% folder = 'Field/SIG_48Gradi_OPERA_error/';
folder = 'Field/SIG_0_48mm_45GradiMagnet/BOXDATA/2022_09_23_SIG_return_ends_curved_70mm_202_160_445/';
fileName = 'BOX.mat';

gridded_data = true; % = TRUE  if we work with gridded data
                     % = FALSE if e fowkr with scattered data

if fileName(end-2:end)=='mat'
    load([folder,fileName]);
    x = BOX.X*1.0E-3; % [mm] --> [m]
    y = BOX.Y*1.0E-3; % [mm] --> [m]
    z = BOX.Z*1.0E-3; % [mm] --> [m]
    Bx = BOX.Bx; % [T]
    By = BOX.By; % [T]
    Bz = BOX.Bz; % [T]
else
    nHeader =9;
    readFormat = '%f %f %f %f %f %f';
    fileID = fopen(fileName,'r');
    temp_csv = textscan(fileID,readFormat,'HeaderLines',nHeader);
    fclose(fileID);
    x = temp_csv{1}*1.0E-3; % [mm] --> [m]
    y = temp_csv{2}*1.0E-3; % [mm] --> [m]
    z = temp_csv{3}*1.0E-3; % [mm] --> [m]
    Bx = temp_csv{4}; % [T]
    By = temp_csv{5}; % [T]
    Bz = temp_csv{6}; % [T]
end


if gridded_data == true
%     nx = 102; ny = 161; nz = 446; 
    nx=202+1; ny=160+1; nz=445+1;
    x = reshape(x,nz,ny,nx); x = permute(x,[3 2 1]);
    y = reshape(y,nz,ny,nx); y = permute(y,[3 2 1]);
    z = reshape(z,nz,ny,nx); z = permute(z,[3 2 1]);
    Bx = reshape(Bx,nz,ny,nx); Bx = permute(Bx,[3 2 1]);
    By = reshape(By,nz,ny,nx); By = permute(By,[3 2 1]);
    Bz = reshape(Bz,nz,ny,nx); Bz = permute(Bz,[3 2 1]);

    settings.fBx = griddedInterpolant(x,y,z,Bx,'cubic','none');
    settings.fBy = griddedInterpolant(x,y,z,By,'cubic','none');
    settings.fBz = griddedInterpolant(x,y,z,Bz,'cubic','none');
else
    settings.fBx = scatteredInterpolant(x,y,z,Bx,'linear','none');
    settings.fBy = scatteredInterpolant(x,y,z,By,'linear','none');
    settings.fBz = scatteredInterpolant(x,y,z,Bz,'linear','none');
end

fprintf('Loading Field and create Interpolation Functions COMPLETED \n');

toc
%% 3D Tracking

%CVS file with input particles
part_file_txt = "Input_Particles/Input.csv";
%part_file_txt = "Input_Particles/Particle_IN_gaussian_2sigma.csv";

settings.A_n = 12;   % Mass Number A (number of nucleons)
settings.Z_n = -6;    % Atomic number Z (number of protons) !Negative value for BACKtracking

tic %taking the time
settings = Tracking_3D_From_File_refsystem(settings, part_file_txt);
toc

 return
%% Post Processing and Plots

PostProcessing_Tracking_3D_fInterp
%%
Trasformation_Coordinates

%% Write output coordinates in a csv file
type=1; return
%% Middle 
Write_Output_Particles(X_local,p_local,phi,theta,l0,Ideal,428.4945,settings.N,x,y,z,type,'_l0');
%% Final
Write_Output_Particles(X_local,p_local,phi,theta,lf,Ideal,428.4945,settings.N,x,y,z,type,'_lf');






