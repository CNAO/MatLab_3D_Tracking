%% Plot section

%% Cambe back to the initial system
for t=1:size(x,1)
    Mrx=MatrixRotationBuilder(pi/2-phi(t),1);
    Mry=MatrixRotationBuilder(theta(t),2);
    
    for j=1:settings.N
        Xbrt{j}(t,:)=X_local{j}(t,:)*Mrx'*Mry';
        Xb{j}(t,:)=Xbrt{j}(t,:)+Xs{Ideal}(t,:);
    end
end
%% Equally spaced division of the space covered
L=[1];
for i=1:size(step,2)
    if step(i)<step(l)/4
        L(2)=i;
    end
    if step(i)<step(l)*(3/4)
        L(3)=i;
    end
    if step(i)<step(l)*(1/2)
        L(4)=i;
    end
end
L=[L,l];
%%  Phase space plot
figure; hold on; grid on; box on; axis equal;title('Phase space on y'); xlabel('Y[m]'); ylabel('py');
scatter(y1(1,:),py(1,:),'mx','DisplayName','at Ltot=0');
scatter(y1(L(1),:),py(L(1),:),'r+','DisplayName','at Ltot/4');
scatter(y1(L(2),:),py(L(2),:),'b+','DisplayName','at Ltot/2');
scatter(y1(L(3),:),py(L(3),:),'g+','DisplayName','at Ltot(3/4)');
scatter(y1(l,:),py(l,:),'k+','DisplayName','at Ltot');
legend;
%%
figure; hold on; grid on; box on; axis equal; 
title('Phase space on x'); xlabel('X[m]'); ylabel('px');
scatter(x1(1,:),px(1,:),'mx','DisplayName','at Ltot=0');
scatter(x1(L(1),:),px(L(1),:),'rx','DisplayName','at Ltot/4');
scatter(x1(L(2),:),px(L(2),:),'bx','DisplayName','at Ltot/2');
scatter(x1(L(3),:),px(L(3),:),'gx','DisplayName','at Ltot(3/4)');
scatter(x1(l,:),px(l,:),'kx','DisplayName','at Ltot');
legend;

%save('plot\Dipolo_3T\PhaseSpaceX_bk.fig');
return;
%% Ideal Trajectory Plot
figure; hold on; grid on; box on; axis equal; title('Trajectory plot');xlabel('x[m]'); ylabel('z[m]');
% h=2;
scatter(x(:,:),z(:,:),15,'bo','filled');
for i=1:settings.N
    if i~=Ideal
        plot(x(:,i),z(:,i),'b-');
    else
        plot(x(:,i),z(:,i),'g-');
    end
    scatter(Xb{i}(:,1),Xb{i}(:,3),15,'ro','filled');
end

for h=lf-20:lf%size(x,1)
    plot([x(h,Ideal),x(h,Ideal)+ds(h-1)*sin(2*pi-theta(h))/2],[z(h,Ideal),z(h,Ideal)+ds(h-1)*cos(2*pi-theta(h))/2],'r--');
    plot([x(h,Ideal)+10*ds(h-1)*sin(pi/2+2*pi-theta(h)),x(h,Ideal)+10*ds(h-1)*sin(2*pi-theta(h)+(3/2)*pi)],[z(h,Ideal)+10*ds(h-1)*cos(pi/2+2*pi-theta(h)),z(h,Ideal)+10*ds(h-1)*cos(2*pi-theta(h)+(3/2)*pi)],'k--');
end
% plot([x(h,Ideal),x(h,Ideal)+ds(h-1)*sin(2*pi-theta(h))/2],[z(h,Ideal),z(h,Ideal)+ds(h-1)*cos(2*pi-theta(h))/2],'r--');
% plot([x(h,Ideal)+ds(h-1)*sin(pi/2+2*pi-theta(h))/2,x(h,Ideal)+ds(h-1)*sin(2*pi-theta(h)+(3/2)*pi)/2],[z(h,Ideal)+ds(h-1)*cos(pi/2+2*pi-theta(h))/2,z(h,Ideal)+ds(h-1)*cos(2*pi-theta(h)+(3/2)*pi)/2],'k--');



% 
%     for h=1:settings.N
%             scatter(Xrt{h}(:,1),Xrt{h}(:,3),15,'ro','filled');
%             plot(x(:,h),z(:,h),'b-');
%     end
legend('ideal','other','longitudanl axes','trasversal axes','interpolate data','data');

%save('plot\Dipolo_3T\Trajectory_plot_bk.fig');
return;

%% Plot spread particle in x,y
grid on; box on;hold on;Mt
title('Trasversal plane');xlabel('x[mm]'); ylabel('y[mm]');
plot(x1(1,:)*10^3,y1(1,:)*10^3,'o','DisplayName','At begging');
plot(x1(lf,:)*10^3,y1(lf,:)*10^3,'x','DisplayName','After Magnet');  
legend;
%% Plot spread particle in x,y
grid on; box on;hold on; title('Trasversal plane');xlabel('x[m]'); ylabel('y[m]');
plot(x(l0,:)-xy,y(l0,:),'o','DisplayName','At begging');
plot(x(l4,:),y(l4,:),'x','DisplayName','After Magnet');  
legend;
%% Read the opera's file with the tracking

fid=fopen('Test_Track1_430.csv','r');

readFormat = '%f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',3);
fclose(fid);
x_op=temp{1};
y_op=temp{2};
z_op=-temp{3};
j=find(z_op<z(size(z,1)-10,Ideal));
step_op=[];
for i=1:j(1)
step_op(i)=sqrt(x_op(i)^2+y_op(i)^2+z_op(i)^2);
end

x_tr=interp1(z(:,Ideal),x(:,Ideal),z_op(1:j(1)),'spline');
y_tr=interp1(z(:,Ideal),y(:,Ideal),z_op(1:j(1)),'spline');
diff=[(x_tr-x_op(1:j(1))),(y_tr-y_op(1:j(1)))];
figure;hold on;title('Difference between opera and matlab tracking at same z'); xlabel('s[m]'); ylabel('d=x_{mat}-x_{op}');
plot(step_op,diff(:,1));
plot(step_op,diff(:,2));
legend('diff on x','diff on y');
