%% Beam generation

alpha_x = 1;
beta_x = 10;
alpha_y = 1;
beta_y = 10;
emi_x = 1E-6;
emi_y = 1E-6;
N = 7.5*1E+3;

gamma_x=(1+alpha_x^2)/beta_x;
gamma_y=(1+alpha_y^2)/beta_y;

R_x = emi_x*[beta_x -alpha_x;-alpha_x gamma_x];
R_y = emi_y*[beta_y -alpha_y;-alpha_y gamma_y];

x =  randn(N,1); xp = randn(N,1);
y =  randn(N,1); yp = randn(N,1);
X = [x,xp];
Y = [y,yp];

%Introduction of correlation matrix 
Lu_x = chol(R_x,'upper');
Lu_y = chol(R_y,'upper');

X_corr=X*Lu_x;
Y_corr=Y*Lu_y;


%% Checking TWISS parameter values
[twiss,Xe,pXe,Ye,pYe] = Ellipse_MP(X_corr(:,1),X_corr(:,2),Y_corr(:,1),Y_corr(:,2));

Zx = twiss.gammax*Xe.^2 + 2*twiss.alfax.*Xe.*pXe + twiss.betax*pXe.^2;
Zy = twiss.gammay*Ye.^2 + 2*twiss.alfay.*Ye.*pYe + twiss.betay*pYe.^2;



%% Plot x-xp phase space 
figure; hold on; 
xlabel('X [mm]'); ylabel('Xp [mrad]'); title('x-xp Phase space')
plot(X_corr(:,1)*1.0E+3,X_corr(:,2)*1.0E+3,'.')
axis equal, axis tight;
% ylim([-10 10])
% xlim([-10 10])

[Mx,cx] = contour(Xe*1E+3,pXe*1E+3,Zx*1E+3,'LevelList',5*twiss.epsx*1.0E+3);

cx.LineWidth = 2;
cx.LineColor = 'k';
cx.LevelList = [5*twiss.epsx]*1.0E+3;
caxis([min(xp) max(xp)]);


%% Plot x-xp phase space WITHOUT correlation
figure; hold on;
xlabel('X [mm]'); ylabel('Xp [mrad]'); title('x-xp Phase space')
plot(X,Y,'r.')
xlim([-5 5])
axis equal, axis tight;
% ylim([-10 10])
% xlim([-10 10])


%% Write beam input file to be tracked
%% In case you want to do all the tracking in the magnet 
var=1;
if var==1
    % Reading from a previous tracking and output file 
    fid= fopen(['Output_Particles\Global_Output.csv'],'r');
    readFormat = '%f, %f, %f, %f, %f, %f, %f, %f';
    temp = textscan(fid,readFormat,'HeaderLines',1);
    fclose(fid);
    x0=temp{1};
    y0=temp{2};
    z0=temp{3};
    phi=temp{4};
    theta=temp{5};
else
    %% In case you want to track only half of the magnet from the center
    x0=0;y0=0;z0=0;
    phi=pi/2;
    theta=-pi;
end
%% Beam input file
x=X_corr(:,1);
px=X_corr(:,2);
y=Y_corr(:,1);
py=Y_corr(:,2);
fileID = fopen(['Input_Particles\Beta_10.csv'],'w');
En=377.132;
id=1:N;
fprintf(fileID, 'X[m],pX,Y[m],pY,Theta[rad],Phi[rad],Id,En[MeV],Xideal[m],Yideal[m],Zideal[m]\n');
fprintf(fileID,'%12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f\n',0,0,0,0,theta,phi,0,En,x0,y0,z0);
for i=1:N
    fprintf(fileID,'%12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f\n',x(i),px(i),y(i),py(i),theta,phi,id(i),En,x0,y0,z0);
end
fclose(fileID);
