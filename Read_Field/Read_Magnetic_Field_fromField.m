%% Read the magneic field from a .mat file produce with Field
clc, clear all, close all;

fprintf('Loading of Magnetic Field . . . \n');
load('Field/Field_cubic_Dipole45_Field.mat');

% Sorting of the 3D field maps
x = permute(x,[2 1 3]);
y = permute(y,[2 1 3]);
z = permute(z,[2 1 3]);
Bx = permute(Bx,[2 1 3]);
By = permute(By,[2 1 3]);
Bz = permute(Bz,[2 1 3]);
nx = size(x,1);ny = size(x,2);nz = size(x,3);

fprintf('Loading of Magnetic Field COMPLETED \n \n');


save('Field/Field_cubic_Dipole45_Field_sort.mat','x','y','z','Bx','By','Bz');

%%

xx = reshape(x,1,[]);
yy = reshape(y,1,[]);
zz = reshape(z,1,[]);
Bxx = reshape(Bx,1,[]);
Byy = reshape(By,1,[]);
Bzz = reshape(Bz,1,[]);
step= 50;

figure; axis equal;
[h] = fscatter3(xx(1:step:end),yy(1:step:end),zz(1:step:end),Byy(1:step:end), jet_mod);
xlabel('x');ylabel('y');zlabel('z');
colorbar
axis equal;

