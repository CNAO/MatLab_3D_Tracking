%% Read the magneic field from a .CVS file
clc, clear, close all;

nHeader =8;
readFormat = '%f %f %f %f %f %f';
fileName = 'Field/PatchTotal.table';
fileID = fopen(fileName,'r');

temp_csv = textscan(fileID,readFormat,'HeaderLines',nHeader);
fclose(fileID);

x = temp_csv{1}*1.0E-3; % [mm] --> [m]
y = temp_csv{2}*1.0E-3; % [mm] --> [m]
z = temp_csv{3}*1.0E-3; % [mm] --> [m]
Bx = temp_csv{4}; % [T]
By = temp_csv{5}; % [T]
Bz = temp_csv{6}; % [T]

%% Plot for verification
figure;
plot3(x,y,z);
axis equal


%% Define the interpolation functions of the field

fBx = scatteredInterpolant(x,y,z,Bx,'linear','none');
fBy = scatteredInterpolant(x,y,z,By,'linear','none');
fBz = scatteredInterpolant(x,y,z,Bz,'linear','none');



%%
% Save in matlab format the interpolation functions
save('Field/Field_Function_INFN.mat','fBx','fBy','fBz');
return

%% Some plots for verirication

figure; hold on; axis equal;

for i=1:nx/20
    Y = reshape(y(10*i,:,:),ny,nz);
    Z = reshape(z(10*i,:,:),ny,nz);
    BZ = reshape(Bz(10*i,:,:),ny,nz);
    BY = reshape(By(10*i,:,:),ny,nz);

    surface(Y+0.5*i,Z,BY,'FaceColor','interp','EdgeColor','none','FaceAlpha',0.95);
    surface(Y+0.5*i,Z+2.5,BZ,'FaceColor','interp','EdgeColor','none','FaceAlpha',0.95);
    
end


xlabel('y');ylabel('z');zlabel('x');
colormap(flipud(hot)); c = colorbar('EastOutside'); 
c.Label.String = 'B [T]'; c.Label.FontSize = 14;

%%

xx = reshape(x,1,[]);
yy = reshape(y,1,[]);
zz = reshape(z,1,[]);
Bxx = reshape(Bx,1,[]);
Byy = reshape(By,1,[]);
Bzz = reshape(Bz,1,[]);
step= 10;

figure; axis equal;
[h] = fscatter3(xx(1:step:end),yy(1:step:end),zz(1:step:end),Byy(1:step:end), jet_mod);
xlabel('x');ylabel('y');zlabel('z');
colorbar
axis equal;

