%% Read the magneic field from a .CVS file
clc, clear, close all;

nHeader =7;
readFormat = '%f %f %f %f %f %f';
fileName = 'PatchTotalCurved.table';
fileID = fopen(fileName,'r');

temp = fgetl(fileID); 
t=strsplit(temp);
nz = str2double(t(1));
ny = str2double(t(2));
nx = str2double(t(3));

temp_csv = textscan(fileID,readFormat,'HeaderLines',nHeader);
fclose(fileID);

x = temp_csv{1}*1E-3;    
y = temp_csv{2}*1E-3;
z = temp_csv{3}*1E-3;
Bx = temp_csv{4};
By = temp_csv{5};
Bz = temp_csv{6};

%%
% Save in matlab format the points as they are
% save('../Field/Demo30def_1300_EBG097_mesh2_5_Z1900.mat','x','y','z','Bx','By','Bz');

% Re-arragne the coordinate in 3D dimensions (check the number of points in X,Y,Z)

x = reshape(x,nz,ny,nx); x = permute(x,[3 2 1]);
y = reshape(y,nz,ny,nx); y = permute(y,[3 2 1]);
z = reshape(z,nz,ny,nx); z = permute(z,[3 2 1]);
Bx = reshape(Bx,nz,ny,nx); Bx = permute(Bx,[3 2 1]);
By = reshape(By,nz,ny,nx); By = permute(By,[3 2 1]);
Bz = reshape(Bz,nz,ny,nx); Bz = permute(Bz,[3 2 1]);


% return
 save('PatchTotalCurved.mat','x','y','z','Bx','By','Bz');
% 
% 
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
figure;
xx = reshape(x,1,[]);
yy = reshape(y,1,[]);
zz = reshape(z,1,[]);
Bxx = reshape(Bx,1,[]);
Byy = reshape(By,1,[]);
Bzz = reshape(Bz,1,[]);
step= 20;

figure; axis equal;
[h] = fscatter3(xx(1:step:end),yy(1:step:end),zz(1:step:end),Byy(1:step:end), jet_mod);
xlabel('x');ylabel('y');zlabel('z');
colorbar
axis equal;
