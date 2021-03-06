%% Read the magneic field from a .CVS file
clc, clear all, close all;

nHeader =7;
readFormat = '%f %f %f %f %f %f';
fileName = 'Field/Field_grid_dipole_45deg_sym_v1_OPERA.table';
fileID = fopen(fileName,'r');

temp = fgetl(fileID); 
t=strsplit(temp);
nz = str2double(t(2));
ny = str2double(t(3));
nx = str2double(t(4));

temp_csv = textscan(fileID,readFormat,'HeaderLines',nHeader);
fclose(fileID);

x_p = temp_csv{1};    
y_p = temp_csv{2};
z_p = temp_csv{3};
Bx_p = temp_csv{4};
By_p = temp_csv{5};
Bz_p = temp_csv{6};

%% Apply symmetry

k_0 = find(y_p~=0); %to elminate the duplication on the symmetry plane x = 0


x_m = x_p(k_0);
y_m = -y_p(k_0);
z_m = z_p(k_0);
Bx_m = -Bx_p(k_0);
By_m = By_p(k_0);
Bz_m = -Bz_p(k_0);

%Merge the vectors
x = [x_m;x_p];
y = [flip(y_m);y_p];
z = [z_m;z_p];
Bx = [Bx_m;Bx_p];
By = [By_m;By_p];
Bz = [Bz_m;Bz_p];

ny = 2*ny -1;

% Sort element in increasing order
[x, idx] = sort(x);
y = y(idx); z_op = z(idx); 
Bx = Bx(idx);By = By(idx);Bz = Bz(idx);

% Save in matlab format the points as they are
% save('Field/Field.mat','x','y','z','Bx','By','Bz');

% Re-arragne the coordinate in 3D dimensions (check the number of points in X,Y,Z)

x = reshape(x,nz,ny,nx); x = permute(x,[3 2 1]);
y = reshape(y,nz,ny,nx); y = permute(y,[3 2 1]);
z = reshape(z,nz,ny,nx); z = permute(z,[3 2 1]);
Bx = reshape(Bx,nz,ny,nx); Bx = permute(Bx,[3 2 1]);
By = reshape(By,nz,ny,nx); By = permute(By,[3 2 1]);
Bz = reshape(Bz,nz,ny,nx); Bz = permute(Bz,[3 2 1]);



save('Field/Field_cubic_Opera_SYM.mat','x','y','z','Bx','By','Bz');



%% Some plots for verirication

figure; hold on; axis equal;

for i=1:nx/10
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
step= 1;

figure; axis equal;
[h] = fscatter3(xx(1:step:end),yy(1:step:end),zz(1:step:end),Byy(1:step:end), jet_mod);
xlabel('x');ylabel('y');zlabel('z');
colorbar
axis equal;

