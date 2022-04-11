figure; hold on;grid on; 
plot(x2,z,'b--','DisplayName','backtracking',LineWidth=2)
plot(X,Z,'ro','DisplayName','backtracking data',LineWidth=1)
plot(x2,z,'r+','DisplayName','Interp data',LineWidth=2)
plot(x,z,'k-','DisplayName','tracking',LineWidth=2)
plot(x,z,'go','DisplayName','Tracking data',LineWidth=1)
title('Comparison backtracking vs tracking',LineWidth=2)
xlabel('x[m]')
ylabel('z[m]')
legend()
%%
% zr=flip(z);
x2=interp1(Z(:,1),X(:,1),z(:,1),'spline');
x3=interp1(Z(:,1),X(:,1),z(:,1),'linear');
y2=interp1(Z(:,1),Y(:,1),z(:,1),'spline');
%%
difx=abs(x2-x);
difx2=abs(x3-x);
dify=abs(y2-y);
figure;hold on;grid on;
title('Difference tracking and back-tracking')
xlabel('s[m]')
ylabel('y_{b,int}-y [m]')
plot(step,dify,LineWidth=2);
plot(step,dify,'x');
% plot(step,difx2,LineWidth=2);
% plot(step,difx2,'x');
%% 
 plot(y2,dify);
% g1=histogram(difx);%,'Normalization','probability')
% title('Histogram of Space Difference R=|x_{trk} - x_{bktrak}|')
% ylabel('counts')
% xlabel('Difference value bins [m]')
%%
figure
g2=hist(dify);
% for i=1:g1.NumBins
% s2(i)=sqrt(g2.Values(i)*(1-g2.Values(i)/size(difx,2)));
% end
% hist(dify)