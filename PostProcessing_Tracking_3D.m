
%% Extract data from solution
x = settings.X(:,1:settings.N);
y = settings.X(:,settings.N+1:2*settings.N);
z = settings.X(:,2*settings.N+1:3*settings.N);
vx = settings.X(:,3*settings.N+1:4*settings.N);
vy = settings.X(:,4*settings.N+1:5*settings.N);
vz = settings.X(:,5*settings.N+1:6*settings.N);


          
%% Plot particles
figure; hold on; grid on; box on; axis equal;

for i=1:settings.N
    plot3(x(:,i),y(:,i),z(:,i),'LineWidth',1);
end

% plot the starting position
plot3(x(1,:),y(1,:),z(1,:),'rx');

xlabel('x [m]'); 
ylabel('y [m]'); 
zlabel('z [m]');
view(3)

%particles' exit angle
settings.th_end=atan((z(end-1,:)-z(end,:))./(x(end-1,:)-x(end,:)))*180/pi;


%% Plot Field in 3D

% Arrange the coordinate and field for plot
[xx,yy,zz] = meshgrid(settings.map.x, settings.map.y, settings.map.z);
xx = permute(xx,[2 1 3]);
yy = permute(yy,[2 1 3]);
zz = permute(zz,[2 1 3]);
Bxx = permute(settings.map.Bx,[2 1 3]);
Byy = permute(settings.map.By,[2 1 3]);
Bzz = permute(settings.map.Bz,[2 1 3]);

% Select the slice to plot kin X,Y,Z
stepx= 1:1:size(xx,1);
stepy= 75;%1:1:size(xx,2);
stepz= 1:1:size(xx,3);

% Plot
% figure;
[h] = fscatter3(xx(stepx,stepy,stepz),...
                yy(stepx,stepy,stepz),...
                zz(stepx,stepy,stepz),...
                Byy(stepx,stepy,stepz), jet_mod);
            
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
axis equal;
c = colorbar('EastOutside'); 
c.Label.String = 'By [T]'; c.Label.FontSize = 14;


%% Plot magnetic field section on the X-Y plane
figure; hold on; axis equal;

[X,Y] = meshgrid(settings.map.x,settings.map.y);
BZ = reshape(settings.map.Bz(:,:,425),150,350);
BY = reshape(settings.map.By(:,:,425),150,350);    
BX = reshape(settings.map.Bx(:,:,425),150,350);

% Plot the field in the section
surface(X,Y,BY-BY(75,235),'FaceColor','interp','EdgeColor','none','FaceAlpha',0.5);

xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
c = colorbar('EastOutside'); 
c.Label.String = 'B [T]'; c.Label.FontSize = 14;
CM = flipud(hot); colormap(CM(1:end-1,:));
caxis([-0.1 0.1])

% Plot field vectors
nq = 5;
quiver(X(1:nq:end,1:nq:end),Y(1:nq:end,1:nq:end),...
       BX(1:nq:end,1:nq:end), BY(1:nq:end,1:nq:end),...
    'AutoScaleFactor', 2.5, 'MaxHeadSize', 2, 'LineWidth', 1.5, 'Color', 'k');

%% Plot the field along y, for a set values of x at a given z

 figure; hold on
 z_idx = 425;
 x_idx = 200;
 N_x = 15;
 leg1 = cell(1,N_x);
 
fprintf('z = %4.3f [m] \n',settings.map.z(z_idx));
 for i=1:N_x
     fprintf('x = %4.3f [m] \n',settings.map.x(x_idx+5*i));
     plot(settings.map.y,settings.map.By(:, x_idx+5*i, z_idx),'-');
     leg1{i} = ['x =',num2str(settings.map.x(x_idx+5*i),'%4.3f'),'[m]'];
 end
 legend(leg1);
 title(['B_y at z =',num2str(settings.map.z(z_idx),'%4.3f'),'[m]']);
 xlabel('y [m]');ylabel('B [T]');
 
 %% Plot the field along x, for a set values of y at a given z

 figure; hold on
 z_idx = 425;
 y_idx = 75;
 
 i=0;
 
fprintf('z = %4.3f [m] \n',settings.map.z(z_idx-50));
fprintf('z = %4.3f [m] \n',settings.map.z(z_idx+51));
fprintf('y = %4.3f [m] \n',settings.map.y(y_idx));

plot(settings.map.x,settings.map.Bx(y_idx+1,:, z_idx-50),'-');
plot(settings.map.x,settings.map.Bx(y_idx+1,:, z_idx+51),'-');

title(['B_x at y =',num2str(settings.map.y(y_idx),'%4.3f'),'[m]']);
xlabel('x [m]');ylabel('B [T]');



%% Plot magnetic field section at different x
figure; hold on; axis equal;

leg2 = cell(1,35);
for i=1:35
    [Y,Z] = meshgrid(settings.map.y,settings.map.z);
    BZ = reshape(settings.map.Bz(:,10*i,:),150,850);
    BY = reshape(settings.map.By(:,10*i,:),150,850);

    surface(Y+0.5*i,Z,BY.','FaceColor','interp','EdgeColor','none');
%   surface(Y+0.5*i,Z+2.5,BZ,'FaceColor','interp','EdgeColor','none')

    leg2{i} = ['x =',num2str(settings.map.x(10*i),'%4.2f'),'[m]'];

end
% legend(leg2);

xlabel('y');ylabel('z');zlabel('x');
colormap(flipud(hot)); c = colorbar('EastOutside'); 
c.Label.String = 'B [T]'; c.Label.FontSize = 14;

%% Calculating Field along the trajectory of the N-th particle

figure; hold on;
for n_part =[50]%: settings.N

% Curvilinear coordinate
ds = sqrt(diff(x(:,n_part)).^2+diff(y(:,n_part)).^2+diff(z(:,n_part)).^2);
s =zeros(size(ds));
for i=1:length(ds)
    s(i+1) = s(i)+ds(i);
end         

%Field interpolation
settings.Bx_tr = interp3(settings.map.x,settings.map.y,settings.map.z,...
                settings.map.Bx,x(:,n_part),y(:,n_part),z(:,n_part),'linear',0);

settings.By_tr = interp3(settings.map.x,settings.map.y,settings.map.z,...
                settings.map.By,x(:,n_part),y(:,n_part),z(:,n_part),'linear',0);
            
settings.Bz_tr = interp3(settings.map.x,settings.map.y,settings.map.z,...
                settings.map.Bz,x(:,n_part),y(:,n_part),z(:,n_part),'linear',0);            
        
 

plot(s, settings.Bx_tr, '.-', 'linewidth',1);
plot(s, settings.By_tr, '-', 'linewidth',2);
plot(s, settings.Bz_tr, '--', 'linewidth',1);
legend('Bx', 'By', 'Bz');
xlabel('s [m]');ylabel('B [T]');

end 
            