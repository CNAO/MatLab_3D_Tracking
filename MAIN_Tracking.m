%% Main file for 3D partilce tracking
clc, clear all, close all;

%% Read Magnetic and create Field Interpolation Functions 
tic

fprintf('Loading Field and create Interpolation Functions ... \n');
nHeader =8;
readFormat = '%f %f %f %f %f %f';
fileName = 'Field/PatchTotalCurved.table';
% fileName = 'Field/PatchTotalCurved.mat';

fileID = fopen(fileName,'r');
temp_csv = textscan(fileID,readFormat,'HeaderLines',nHeader);
fclose(fileID);

type=isempty(temp_csv{1}); %Boolean varibale if zero than the file is in format .mat otherwise is in .table 

if type==0
    x = temp_csv{1}*1.0E-3; % [mm] --> [m]
    y = temp_csv{2}*1.0E-3; % [mm] --> [m]
    z = temp_csv{3}*1.0E-3; % [mm] --> [m]
    Bx = temp_csv{4}; % [T]
    By = temp_csv{5}; % [T]
    Bz = temp_csv{6}; % [T]

    settings.fBx = scatteredInterpolant(x,y,z,Bx,'linear');%,'none');
    settings.fBy = scatteredInterpolant(x,y,z,By,'linear');%,'none');
    settings.fBz = scatteredInterpolant(x,y,z,Bz,'linear');%,'none');
else
    load(fileName);
    % Create 1D array with the x,y,z field coordinate
    settings.map.x = reshape(x(:,1,1),1,[]);
    settings.map.y = reshape(y(1,:,1),1,[]);
    settings.map.z = reshape(z(1,1,:),1,[]);

    % Sorting of the 3D field maps
    settings.map.Bx = permute(Bx,[2 1 3]);
    settings.map.By = permute(By,[2 1 3]);
    settings.map.Bz = permute(Bz,[2 1 3]);

    settings.fBx = griddedInterpolant(x,y,z,Bx,'spline');
    settings.fBy = griddedInterpolant(x,y,z,By,'spline');
    settings.fBz = griddedInterpolant(x,y,z,Bz,'spline');
end

fprintf('Loading Field and create Interpolation Functions COMPLETED \n');

toc
%% 3D Tracking

%CVS file with input particles
part_file_txt = "Input_Particles/particletot.csv";
settings.A_n = 12;   % Mass Number A (number of nucleons)
settings.Z_n = 6;    % Atomic number Z (number of protons) !Negative value for BACKtracking

tic %taking the time
settings = Tracking_3D_From_File_refsystem(settings, part_file_txt);
toc

% return
%% Post Processing and Plots

if type==0
    PostProcessing_Tracking_3D;
else
    PostProcessing_Tracking_3D_2;
end






