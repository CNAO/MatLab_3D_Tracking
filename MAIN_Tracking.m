%% Main file for 3D partilce tracking
clc, clear all, close all;

%% Read Magnetic Field From Matlab-File

fprintf('Loading of Magnetic Field . . . \n');
load('Field/Field_cubic.mat');

% Create 1D array with the x,y,z field coordinate
settings.map.x = reshape(x(:,1,1),1,[]);
settings.map.y = reshape(y(1,:,1),1,[]);
settings.map.z = reshape(z(1,1,:),1,[]);

% Sorting of the 3D field maps
settings.map.Bx = permute(Bx,[2 1 3]);
settings.map.By = permute(By,[2 1 3]);
settings.map.Bz = permute(Bz,[2 1 3]);

fprintf('Loading of Magnetic Field COMPLETED \n \n');

%% 3D Tracking

%CVS file with input particles
part_file_txt = "Input_Particles/Particle4.csv";

settings.A_n = 1;   % Mass Number A (number of nucleons)
settings.Z_n = 1;  % Atomic number Z (number of protons)

tic %taking the time
settings = Tracking_3D_From_File(settings, part_file_txt);
toc

return
%% Post Processing and Plots

PostProcessing_Tracking_3D;


