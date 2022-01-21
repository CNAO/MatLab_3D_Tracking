clc;
tic
%% Extract data from solution

x = settings.X(:,1:settings.N);
y = settings.X(:,settings.N+1:2*settings.N);
z = settings.X(:,2*settings.N+1:3*settings.N);
vx = settings.X(:,3*settings.N+1:4*settings.N);
vy = settings.X(:,4*settings.N+1:5*settings.N);
vz = settings.X(:,5*settings.N+1:6*settings.N);

%% remove nan from array

x=rmmissing(x); 
y=rmmissing(y);
z=rmmissing(z);
vx=rmmissing(vx);
vy=rmmissing(vy);
vz=rmmissing(vz);

%sometime the velocity have a smaller size then the coordinates
if size(x,1)~=size(vx,1)
    warning('Different size');
    x=x(1:size(x,1)-1,:);
    y=y(1:size(y,1)-1,:);
    z=z(1:size(z,1)-1,:);
end

%% Definition of global variable

%Finding the ideal particle have X=(0,0,0,0) in global system
for i=1:size(x,2)
    if y(1,i)==0 && x(1,i)==0 && vx(1,i)==0 && vy(1,i)==0
        Ideal=i ; %Ideal particle
        break;
    else
        Ideal=fix(size(x,2)/2)+1;
    end
end 

phi=zeros(1,size(x,1)); %phi is define like the angle between y and xz plane axis in global system (azimutal angle)
theta=zeros(1,size(x,1));  %theta is define the angle between z and x plane axis in global system (- polar angle)
Xs=cell(1,settings.N); %coordinates in global system
Xtr=cell(1,settings.N); %coordinates in translate system (centered in ref part)
Xrt=cell(1,settings.N); %coordinates in rototranslate system (longtidunal axis is in the direction of the motion of ref part)
X_local=cell(1,settings.N); %coordinates in local system
p_local=cell(1,settings.N); %canonical momentum in local system
% transvers coordinates in local system
x1=zeros(size(x,1),settings.N);
y1=zeros(size(x,1),settings.N);
% canonical momentum in local system
px=zeros(size(x,1),settings.N);
py=zeros(size(x,1),settings.N);
% Building the 3D vector of global coordinates for each particle 
%Note when i use cell the definition is that:
%X{i}(j,k) -> 3 index: i)n° part j)time k) (1=>x,2=>y,3=>z)   
for i=1:settings.N
    Xs{i}=[x(:,i) y(:,i) z(:,i)];
end

%% length of steps

ds = sqrt(diff(x(:,Ideal)).^2+diff(y(:,Ideal)).^2+diff(z(:,Ideal)).^2); %single step for each point
step=[ds(1)]; %total path traveled for every point
for i=2:length(ds)
    step(i)=step(i-1)+ds(i);
end
%settings.step=step;

%% finding key steps in magnet
l0=1; %initial time
lm=find(x(:,Ideal)<10^-7 & x(:,Ideal)>-10^-7,1); %time in which ideal particle pass from the middle of the magnet
l1=find(step(:)>step(lm)-0.4,1); %0.4 cm before half magnet
l2=find(step(:)>step(lm)-0.2,1); %0.2 cm before half magnet
l3=find(step(:)>step(lm)+0.2,1); %0.2 cm after half magnet
l4=find(step(:)>step(lm)+0.4,1); %0.4 cm after half magnet
lf=size(x,1); % end of the field map

%% Cycle for
Dt=[l0,l1-1:l1,l2-1:l2,lm-1:lm,l3-1:l3,l4-1:l4,lf-1:lf];
j=1;
while j<size(Dt,2)+1
    t=Dt(j);
    %% Velocity ​​must coincide with the axis of motion in the moving ref system

    V=sqrt(vx(t,Ideal)^2+vy(t,Ideal)^2+vz(t,Ideal)^2); %total velocity
    phi(t)=acos(vy(t,Ideal)/V); 
    theta(t)=acos(vz(t,Ideal)/(V*sin(phi(t)))); 
    %Theta is multiplied for the direction of vx because the rotation must be anticlockwise 
    if vx(t,Ideal)>0
        theta(t)=2*pi-theta(t);
    end

    Mrx=MatrixRotationBuilder(pi/2-phi(t),1);
    Mry=MatrixRotationBuilder(theta(t),2);

    %% Applies coordinate rotation

    for i=1:settings.N
        Xtr{i}=Xs{i}-Xs{Ideal}(t,:);
        Xrt{i}=Xtr{i}*Mry*Mrx;
    end

    %% Linear interpolation 
    %The function interp1 (x, y, x0) interpolates the data (x, y) corresponding to x0
    %These data are the coordinates in local system at z=0 for all the steps
    for i=1:settings.N
        x1(t,i)=interp1(Xrt{i}(:,3),Xrt{i}(:,1),0*Xrt{Ideal}(t,3),'spline');
        y1(t,i)=interp1(Xrt{i}(:,3),Xrt{i}(:,2),0*Xrt{Ideal}(t,3),'spline'); 
        % Building canonical momentums p(s)=dx/ds
        if t==1
        py(t,i)=tan(asin(vy(t,i)/V));
        px(t,i)=tan(asin((vx(t,i)*cos(theta(t))+vz(t,i)*sin(theta(t)))/sqrt(V^2-vy(t,i)^2)));
        else
            px(t,i)=(x1(t,i)-x1(t-1,i))/ds(t-1);
            py(t,i)=(y1(t,i)-y1(t-1,i))/ds(t-1);
        end
    end
    %Progress of the cycle for
    K=(t/size(x,1))*100;
    fprintf('Loading of transofrmation %2.2f percent\n',K);
    j=j+1;
end
toc
%% Building 3D vector of local system coordinates for each particle

for i=1:settings.N
 %coordinates in local system with interp data
    X_local{i}=[x1(:,i) y1(:,i)]; %3 index: i)n° part j)time k) (1=>x,2=>y,3=>z) X{i}(j,k)
    p_local{i}=[px(:,i) py(:,i)];
end
return;
%% Built linear & model transport matrix

%Total transport matrix 4x4
[Mt,X0,Xf]=LinearMatrixBuilder(X_local,p_local,l0,lm,settings.N);
%Transport Matricies for x and y 2x2
[Mtx,Mty]=LinearMatrix_2x2_Builder(X_local,p_local,l0,lm,settings.N);
% Extrapolation parameters by Mt to built model matrix
[Mt_model,k]=ModelMatrixBuilder(Mt,l0,lf-1,step);
% Plot section
Plot_matrix_abs_err(1,X0,Xf,Mt);
%Plot_matrix_abs_err(1,X0,Xf,Mt_model);

%% Output file with Matrix linear extrapolation
% Write an output file in the directory called "Matrix_output" in wich
% there are all the transport matrix extrapolated
time=[l1,l2,lm,l3,l4,lf];
M=cell(1,size(time,2));

for i=1:size(time,2) %i goes from 1 to the number of the topic points
    [Mt,X0,Xf]=LinearMatrixBuilder(X_local,p_local,l0,time(i),settings.N);
    M{i}=Mt;
end

save('Output_Matrix/matrix.mat', 'M');

%% Built the trasport matrix for each point spaced by a quantity called jump
% Use only in case you have run the cycle while for all the points
format long;
M_tot=eye(4); m_i=[]; x00=[]; xff=[]; j=1; K_xi=[];K_yi=[];ss=[];
jump=50;
while j<=lf-jump
    [m_i,x00,xff]=LinearMatrixBuilder(X_local,p_local,j,j+jump,settings.N);
    [mm_i,k_i]=ModelMatrixBuilder(m_i,j,j+jump,step);
    M_tot=m_i*M_tot; 
    K_xi=[K_xi;k_i(3)];
    K_yi=[K_yi;k_i(6)];
    ss=[ss,step(j)];
    if j+salto<=lf
        j=j+jump;
    else
        j=lf+1;
    end
end
% Square Band Radius 
rhos=1./((K_xi-K_yi));
%plot section
figure;hold on;title('Gradient along magnet');xlabel('s[m]');ylabel('k[1/m^2]');
plot(ss,K_yi);plot(ss,K_xi);plot(ss,1./rhos);legend('ky','kx','1/\rho^2');

Plot_matrix_abs_err(1,X0,xff,M_tot);
return;



%% Write output coordinates in a csv file
type=2; %Type=1 write output in local coordinates else in global coordinates
Write_Output_Particles(X_local,p_local,phi,theta,lf,Ideal,377.132,settings.N,x,y,z,type);



