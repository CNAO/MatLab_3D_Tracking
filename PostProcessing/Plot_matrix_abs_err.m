function [] = Plot_matrix_abs_err(id,X0,XF,Mt)

XF1=(Mt*X0); %Local coordinates vector from Trasport Matrix
R=XF1-XF; %Absolute error due to the linearization of the system


figure; hold on;
plot(XF(1,:),XF(3,:),'ko');
plot(XF1(1,:),XF1(3,:),'rx');
% Evalutation of the model
% 
% X_f=Mt_th*X0;
% R_model=XF1-X_f; %Error from using combined function model to describe the magnet 
% R_lin=XF-X_f; %Error from using linear model to describe the transport

%Define some string for label
string1=["x","px","y","py"];
string2=["[m]","[mrad]","[m]","[mrad]"];

figure;hold on;
title("Error Absolute Plot"); xlabel(strcat(string1(id),string2(id))); ylabel(strcat("R",string2(id)));
plot(X0(id,:),abs(R(id,:)),"x");

xfit=X0(id,:);
yfit=X0(id+2,:);
Rfitx=R(id,:);
Rfity=R(id+2,:);
figure;stem3(xfit,yfit,(Rfitx)); title('Residual in X');
figure;stem3(xfit,yfit,(Rfity)); title('Residual in Y');

return
%% R1 plot
%Relative percentage difference between the local vector of the tracking coordinates and the one reconstructed from the transport matrix 
R1=(R./XF)*100;
% Find where the relative percent dfference R1 is major than 10%
kap=find(abs(R1(id,:))>10); %vector with R1>10%
figure;hold on;grid on;title('percentage Error'); xlabel('ID particle'); ylabel(strcat(string1(id),string2(id)));
plot(XF(id,:),'ko','DisplayName','X_f trck');plot(XF1(id,:),'bx','DisplayName','M_t*X_0');plot(kap,XF1(id,kap),'rx','DisplayName','R1>10%');
legend;


