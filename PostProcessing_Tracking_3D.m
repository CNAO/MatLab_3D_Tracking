
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
    plot3(x(:,i),y(:,i),z(:,i),'b','LineWidth',0.5);
end
% plot3(x(:,10),y(:,10),z(:,10),'r','LineWidth',1.0);
% plot the starting position
plot3(x(1,:),y(1,:),z(1,:),'rx');

xlabel('x [m]'); 
ylabel('y [m]'); 
zlabel('z [m]');
view(3)

%particle's exit angle
return
for i=1:settings.N
    idx=find(isnan(x(:,i)));
    settings.th_end(i)=90-atan((z(idx(1)-3,i)-z(idx(1)-2,i))./(x(idx(1)-3,i)-x(idx(1)-2,i)))*180/pi;
end
%plot field map points for verification
% plot3(settings.fBx.Points(:,1),settings.fBx.Points(:,2),settings.fBx.Points(:,3),'k.')

%% Plot Field in 3D

X=settings.fBx.Points(:,1);
Y=0*settings.fBx.Points(:,2);
Z=settings.fBx.Points(:,3);

Bxx = settings.fBx([X,Y,Z]);
Byy = settings.fBy([X,Y,Z]);
Bzz = settings.fBz([X,Y,Z]);

% Plot
% figure;
fscatter3(X,Y+0.01,Z,Byy, hot);
            
xlabel('x [m]'); ylabel('z [m]');

% axis equal; axis close;
c = colorbar('EastOutside'); 
c.Label.String = 'By [T]'; c.Label.FontSize = 14;

return

%% Calculating Field along the trajectory of the N-th particle

figure; hold on;
for n_part=1:10%:settings.N

% Curvilinear coordinate
ds = sqrt(diff(x(:,n_part)).^2+diff(y(:,n_part)).^2+diff(z(:,n_part)).^2);
s =zeros(size(ds));
for i=1:length(ds)
    s(i+1) = s(i)+ds(i);
end         

%Field interpolation
settings.Bx_tr = settings.fBx([x(:,n_part),y(:,n_part),z(:,n_part)]);

settings.By_tr = settings.fBy([x(:,n_part),y(:,n_part),z(:,n_part)]);
            
settings.Bz_tr = settings.fBz([x(:,n_part),y(:,n_part),z(:,n_part)]);           
        
 

plot(s, settings.Bx_tr, '.-', 'linewidth',1);
plot(s, settings.By_tr, 'x-', 'linewidth',2);
plot(s, settings.Bz_tr, '--', 'linewidth',1);
legend('Bx', 'By', 'Bz');
xlabel('s [m]');ylabel('B [T]');

end 

return
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




            