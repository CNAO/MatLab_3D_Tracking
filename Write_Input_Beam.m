%Load particle distribution genrated with BeamGean
clc; clear; close all;
%% In case you want to do all the tracking in the magnet 
var=0;
if var==0
    % Reading from a previous tracking and output file 
    fid= fopen('Output_Particles\Global_Output_SIG_0_48mm_45Gradi.csv','r');
    readFormat = '%f, %f, %f, %f, %f, %f, %f, %f';
    temp = textscan(fid,readFormat,'HeaderLines',1);
    fclose(fid);
    x0=temp{1}; y0=temp{2}; z0=temp{3};
    phi=temp{4}; theta=temp{5};
else
    %% In case you want to track only half of the magnet from the center
    x0=0;y0=0;z0=0;
    phi=pi/2;
    theta=-pi;
end
%% Beam input file

load_from_file = true;  % if true load a particle distribution from BeamGen
                        % if false generate gridded particle distribution

%Load particle distribution from an existing file created with BeamGen 
if load_from_file == true
    folder = 'C:\Users\enrico.felcini\Desktop\GIT\MatLab_3D_Tracking\Baem_Generation\';
    [x,px,y,py,dp] = load_distribution([folder,'part_MAT_gauss_bx10_ax0_1000.txt']);
    Enom = 428.4945; % [Mev/u] nominal beam energy
    En = Enom*(1+dp);
else 
    %Generate a gridded particle distribution
    n=7; %number of particles
    l=15*1e-3; % [m]   square beam size (x,y)
    p=1*1e-3;  % [rad] square beam divergence (px, py)
    [x,px,y,py] = gridded_distribution(n,l,p);
    En=linspace(428.4945,428.4945,length(x));
end

fileID = fopen('Input_Particles\Particle_SIG_0_gauss_bx10_ax0_1000.csv','w');
fprintf(fileID, 'X[m],pX,Y[m],pY,Theta[rad],Phi[rad],Id,En[MeV],Xideal[m],Yideal[m],Zideal[m]\n');
for i=1:length(x)
    fprintf(fileID,'%12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f\n',x(i),px(i),y(i),py(i),theta,phi,i,En(i),x0,y0,z0);
end
fclose(fileID);
return
%% Plots for verification
figure; plot(x,y,'.', 'MarkerSize',0.1); axis equal;
figure; plot(x,px,'.', 'MarkerSize',0.1); axis equal;
figure; plot(y,py,'.', 'MarkerSize',0.1); axis equal;

%% ---------------------- Functions Definition ------------------------- %%

function [x,px,y,py] = gridded_distribution(n,l,p)
    xl=linspace(l,-l,n)';
    yl=linspace(l,-l, n)';
    pxl=linspace(-p,+p,n)';
    pyl=linspace(-p,+p,n)';
    [x,px,y,py] = ndgrid(xl,pxl,yl,pyl);
    x = reshape(x,1,[]);
    px = reshape(px,1,[]);
    y = reshape(y,1,[]);
    py = reshape(py,1,[]);
end

function [x,px,y,py,dp] = load_distribution(fileName)

nHeader =1;
readFormat = '%f %f %f %f %f';
fileID = fopen(fileName,'r');
temp = textscan(fileID,readFormat,'HeaderLines',nHeader);
fclose(fileID);

x = temp{1}; 
px = temp{2}; 
y = temp{3}; 
py = temp{4}; 
dp = temp{5};

end