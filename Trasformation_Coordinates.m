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

%% finding key steps in magnet
l0=1; %initial time
lm=find(z(:,Ideal)>0,1); %time in which ideal particle pass from the middle of the magnet
l1=find(step(:)>step(lm)-0.4,1); %0.4 cm before half magnet
l2=find(step(:)>step(lm)-0.2,1); %0.2 cm before half magnet
l3=find(step(:)>step(lm)+0.2,1); %0.2 cm after half magnet
l4=find(step(:)>step(lm)+0.4,1); %0.4 cm after half magnet
lnew=find(step(:)>1.65*5*pi/180,1);
lf=size(x,1); % end of the field map

%% Cycle for
% Dt=[l0,l0+1,l1-1:l1,l2-1:l2,lm-1:lm,l3-1:l3,l4-1:l4,lf-1:lf];
Dt=[l0:l0+1,lnew-1:lnew,lf-1:lf];
% Dt=linspace(1,size(x,1),size(x,1));
j=1;
while j<size(Dt,2)+1
    t=Dt(j);
    %% Velocity ​​must coincide with the axis of motion in the moving ref system

    V=sqrt(vx(t,Ideal)^2+vy(t,Ideal)^2+vz(t,Ideal)^2); %total velocity
    phi(t)=acos(vy(t,Ideal)/V); 
    theta(t)=acos(vz(t,Ideal)/(V*sin(phi(t))));
    
    %Pay attention that the rotation must be anticlockwise 
    Mrx=MatrixRotationBuilder(pi/2-phi(t),1);
    Mry=MatrixRotationBuilder(-theta(t)*sign(vx(t,Ideal)),2);

    

    %% Applies coordinate rotation

    for i=1:settings.N
        Xtr{i}=Xs{i}-Xs{Ideal}(t,:);
        Xrt{i}=(Mry*Mrx*Xtr{i}')';
    end

    %% Linear interpolation 
    %The function interp1 (x, y, x0) interpolates the data (x, y) corresponding to x0
    %These data are the coordinates in local system at z=0 for all the steps
    for i=1:settings.N
        x1(t,i)=interp1(Xrt{i}(:,3),Xrt{i}(:,1),0*Xrt{Ideal}(t,3),'spline');
        y1(t,i)=interp1(Xrt{i}(:,3),Xrt{i}(:,2),0*Xrt{Ideal}(t,3),'spline'); 
        
        %Building canonical momentums p(s)=dx/ds
        if t==1
            v1=(Mrx*Mry*[vx(t,i);vy(t,i);vz(t,i)]);
            vx1(i)=v1(1);
            vy1(i)=v1(2);
            vz1(i)=v1(3);
            py(t,i)=round(tan(asin(vy1(i)/V)),8);
            px(t,i)=round(tan(asin(vx1(i)/V)),8);
        else
            px(t,i)=(x1(t,i)-x1(t-1,i))/ds(t-1);
            py(t,i)=(y1(t,i)-y1(t-1,i))/ds(t-1);
        end
    end
    %Progress of the cycle for
    fprintf('Loading of transofrmation %2.2f percent\n',(t/size(x,1))*100);
    j=j+1;
end
toc
%% Building 3D vector of local system coordinates for each particle

for i=1:settings.N
 %coordinates in local system with interp data
    X_local{i}=[x1(:,i) y1(:,i),zeros(size(x1,1),1)]; %3 index: i)n° part j)time k) (1=>x,2=>y,3=>z) X{i}(j,k)
    p_local{i}=[px(:,i) py(:,i)];
end
return;
%% Built linear & model transport matrix

%Total transport matrix 4x4
[Mt,X0,Xf]=LinearMatrixBuilder(X_local,p_local,l0,lf,settings.N);
[Mlin,M3,K,S,O,X00]=ThirdOrderMatrix(X_local,p_local,l0,lf,settings.N);
% Extrapolation parameters by Mt to built model matrix
[Mt_model,k]=ModelMatrixBuilder(Mt,l0,lf-1,step);
% Plot section
%Plot_matrix_abs_err(1,X0,Xf,Mt);
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

save('Output_Matrix/matrix_6.mat', 'M');

%% Output file with Matrix third order
% Write an output file in the directory called "Matrix_output" in wich
% there are all the transport matrix extrapolated
time=[l1,l2,lm,l3,l4,lf];
M=cell(1,size(time,2));

for i=1:size(time,2) %i goes from 1 to the number of the topic points
    Mt=ThirdOrderMatrix(X_local,p_local,l0,time(i),settings.N);
    M{i}=Mt;
end

save('Output_Matrix/matrix_2_5_1.mat', 'M');

%% Twiss parameters extrapolation
emittance=1e-6;
%XxX=(Mlin*X0')';
%x1=XxX(:,1);
%px=XxX(:,2);
%y1=XxX(:,3);
%py=XxX(:,4);
% [x1,px,y1,py]=[XxX(:,1),XxX(:,2),XxX(:,3),XxX(:,4)];

% Fitgauss_x=fitdist(x1,'normal');
% Fitgauss_px=fitdist(px,'normal');
% Fitgauss_y=fitdist(y1,'normal');
% Fitgauss_py=fitdist(py,'normal');

Fitgauss_x=fitdist(x1(lf,:)','normal');
Fitgauss_px=fitdist(px(lf,:)','normal');
Fitgauss_y=fitdist(y1(lf,:)','normal');
Fitgauss_py=fitdist(py(lf,:)','normal');

beta_x=(Fitgauss_x.sigma^2)/emittance;
beta_y=(Fitgauss_y.sigma^2)/emittance;
gamma_x=(Fitgauss_px.sigma^2)/emittance;
gamma_y=(Fitgauss_py.sigma^2)/emittance;
alpha_x=sqrt(gamma_x*beta_x -1);
alpha_y=sqrt(gamma_y*beta_y -1);
Twiss=[beta_x,beta_y,alpha_x,alpha_y,gamma_x,gamma_y]
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
type=1; %Type=1 write output in local coordinates else in global coordinates
Write_Output_Particles(X_local,p_local,phi,theta,l0,Ideal,320.2,settings.N,x,y,z,type);
%%
Write_Output_Particles(X_local,p_local,phi,theta,lm,Ideal,320.2,settings.N,x,y,z,type);
%%
Write_Output_Particles(X_local,p_local,phi,theta,lf,Ideal,320.2,settings.N,x,y,z,type);



