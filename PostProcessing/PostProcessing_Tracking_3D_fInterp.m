
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
    hh(1)=plot3(x(:,i),y(:,i),z(:,i),'b','LineWidth',0.8,'DisplayName','Tracking');
%     hh(2)=plot3(xx2(:,i),zeros(size(xx2,1),1),zz2(:,i),'g','LineWidth',2.5,'DisplayName','Backtracking');
end

% plot the starting position
plot3(x(1,:),y(1,:),z(1,:),'g+',LineWidth=2);

xlabel('x [m]'); 
ylabel('y [m]'); 
zlabel('z [m]');
% view(3)

%particles' exit angle
settings.th_end=atan((z(end-1,:)-z(end,:))./(x(end-1,:)-x(end,:)))*180/pi;


%% Plot Field in 3D

%Define plot for point
xx = linspace(-0.4,0.2,200);
zz = linspace(-1,1,600);
yy = 0;

[XX,YY,ZZ]=meshgrid(xx,yy,zz);
P = [2 1 3];
XX = permute(XX, P);
YY = permute(YY, P);
ZZ = permute(ZZ, P);

% figure;
[h] = fscatter3(XX,YY,ZZ,abs(settings.fBy(XX,YY,ZZ)),flipud(hot));

xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
axis equal; box on;
c = colorbar('EastOutside'); 
c.Label.String = 'By [T]'; c.Label.FontSize = 14;
view(180,0);

%% Calculating Field along the trajectory of the N-th particle

figure; hold on;
for i=1201 %select the particle 
    ds = sqrt(diff(x(:,i)).^2+diff(y(:,i)).^2+diff(z(:,i)).^2);
    s=zeros(size(x(:,i)));
    for j=2:length(ds)+1
        s(j) = s(j-1)+ds(j-1);
    end
    plot(s, settings.fBx(x(:,i),y(:,i),z(:,i)),'LineWidth',2);
    plot(s, settings.fBy(x(:,i),y(:,i),z(:,i)),'LineWidth',2);
    plot(s, settings.fBz(x(:,i),y(:,i),z(:,i)),'LineWidth',2);

end

legend('Bx', 'By', 'Bz');
xlabel('s [m]');ylabel('Field [T]')


%% Compare central tracking with ideal trajectory
Rt = 1.65;
th1= -22.5*pi/180;  %rad
th2= 22.5*pi/180;   %rad
Nth=100;
theta =linspace(th1,th2,Nth);

xc = Rt*cos(theta)-Rt;
zc = -Rt*sin(theta);
yc = zeros(size(xc));

%Evaluation of the straight parts
Np=100;
p1=[xc(1),zc(1)]; %point 1
x1=linspace(p1(1),p1(1)-0.1,Np);
m1=(zc(2)-zc(1))/(xc(2)-xc(1)); %angular coefficient
z1=m1*(x1-xc(2))+zc(2);
y1=zeros(size(x1));

p2=[xc(end),zc(end)]; %point 2
x2=linspace(p2(1),p2(1)-0.1,Np);
m2=(zc(end)-zc(end-1))/(xc(end)-xc(end-1));
z2=m2*(x2-xc(end))+zc(end);
y2=zeros(size(x2));

x2 = flip(x2);y2 = flip(y2);z2 = flip(z2);
xc = flip(xc);yc = flip(yc);zc = flip(zc);
X = [x2(1:end-1),xc(1:end-1),x1];
Y = [y2(1:end-1),yc(1:end-1),y1];
Z = [z2(1:end-1),zc(1:end-1),z1];



Rt = 1.65;
th1= -31*pi/180;  %rad
th2= 31*pi/180;   %rad
Nth=100;
theta =linspace(th1,th2,Nth);

xcc = Rt*cos(theta)-Rt;
zcc = -Rt*sin(theta);
ycc = zeros(size(xc));

figure; hold on; axis equal;

plot3(X,Y,Z,'r--', 'LineWidth',1.5);
plot3(xcc,ycc,zcc,'k-.', 'LineWidth',1.5);

for i=round(settings.N/2)
    hh(1)=plot3(x(:,i),y(:,i),z(:,i),'b','LineWidth',2);
end
legend('Arc + straight','Arc of 62 deg','Tracking')
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
% view(3);
xlim([-0.25 -0.1]);
zlim([0.68 0.88]);
view(0,0);
