%% Main file for 3D partilce tracking
clc, clear all, close all;

%% Read Magnetic and create Field Interpolation Functions 
tic

fprintf('Loading Field and create Interpolation Functions ... \n');
nHeader =8;
readFormat = '%f %f %f %f %f %f';
fileName = 'Field/PatchTotal.table';
%fileName = 'Field/Demo30def_1300_EBG097_coarse.table';

fileID = fopen(fileName,'r');

temp_csv = textscan(fileID,readFormat,'HeaderLines',nHeader);
fclose(fileID);

x = temp_csv{1}*1.0E-3; % [mm] --> [m]
y = temp_csv{2}*1.0E-3; % [mm] --> [m]
z = temp_csv{3}*1.0E-3; % [mm] --> [m]
Bx = temp_csv{4}; % [T]
By = temp_csv{5}; % [T]
Bz = temp_csv{6}; % [T]

settings.fBx = scatteredInterpolant(x,y,z,Bx,'linear','none');
settings.fBy = scatteredInterpolant(x,y,z,By,'linear','none');
settings.fBz = scatteredInterpolant(x,y,z,Bz,'linear','none');

fprintf('Loading Field and create Interpolation Functions COMPLETED \n');

toc
%% 3D Tracking

%CVS file with input particles
part_file_txt = "Input_Particles/Particletot.csv";
settings.A_n = 12;   % Mass Number A (number of nucleons)
settings.Z_n = -6;    % Atomic number Z (number of protons) !Negative value for BACKtracking

tic %taking the time
settings = Tracking_3D_From_File_refsystem(settings, part_file_txt);
toc

% return
%% Post Processing and Plots

PostProcessing_Tracking_3D;


