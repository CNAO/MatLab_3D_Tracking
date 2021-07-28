%% Read the magneic field from a .CVS file

nHeader =1;
readFormat = '%f %f %f %f %f %f %f %f %f';
fileName = 'Field/HIE-ISOLDE_Dipole_grid_data.csv';
fileID = fopen(fileName,'r');
temp_csv = textscan(fileID,readFormat,'Delimiter',',','HeaderLines',nHeader);
fclose(fileID);

x = temp_csv{1};    
y = temp_csv{2};
z = temp_csv{3};
Ax = temp_csv{4};
Ay = temp_csv{5};
Az = temp_csv{6};
Bx = temp_csv{7};
By = temp_csv{8};
Bz = temp_csv{9};

% Save in matlab format the points as they are
% save('Field/Field.mat','x','y','z','Bx','By','Bz');

% Re-arragne the coordinate in 3D dimensions (check the number of points in X,Y,Z)
nx = 350;
ny = 150;
nz = 850;
x = reshape(x,nx,ny,nz);
y = reshape(y,nx,ny,nz);
z = reshape(z,nx,ny,nz);
Bx = reshape(Bx,nx,ny,nz);
By = reshape(By,nx,ny,nz);
Bz = reshape(Bz,nx,ny,nz);

save('Field/Field_cubic.mat','x','y','z','Bx','By','Bz');

return

%% Some plots for verirication

figure; hold on; axis equal;

for i=1:nx/10
    Y = reshape(y(10*i,:,:),150,850);
    Z = reshape(z(10*i,:,:),150,850);
    BZ = reshape(Bz(10*i,:,:),150,850);
    BY = reshape(By(10*i,:,:),150,850);

    surface(Y+0.5*i,Z,BY,'FaceColor','interp','EdgeColor','none','FaceAlpha',0.95);
    surface(Y+0.5*i,Z+2.5,BZ,'FaceColor','interp','EdgeColor','none','FaceAlpha',0.95);
    
end


xlabel('y');ylabel('z');zlabel('x');
colormap(flipud(hot)); c = colorbar('EastOutside'); 
c.Label.String = 'B [T]'; c.Label.FontSize = 14;

%

xx = reshape(x,1,[]);
yy = reshape(y,1,[]);
zz = reshape(z,1,[]);
Bxx = reshape(Bx,1,[]);
Byy = reshape(By,1,[]);
Bzz = reshape(Bz,1,[]);
step= 50;

% figure; axis equal;
[h] = fscatter3(xx(1:step:end),yy(1:step:end),zz(1:step:end),Byy(1:step:end), jet_mod);
xlabel('x');ylabel('y');zlabel('z');
colorbar
axis equal;

