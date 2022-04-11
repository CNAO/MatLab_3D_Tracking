
%% Plot Linear Matrix elements of optimization

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',13);
fclose(fid);
r=temp{1};
x=temp{2};
px=temp{3};
y=temp{4};
py=temp{5};

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',23);
fclose(fid);
x2=temp{2};
px2=temp{3};
y2=temp{4};
py2=temp{5};

%%
xfit2=max(x2,y2)/1e-3;
yfit2=max(px2,py2)/1e-3;
xfit=max(x,y)/1e-3;
yfit=max(px,py)/1e-3;
figure; hold on;grid on; box on;
plot(r,xfit,'-x',LineWidth=2);plot(r,yfit,'-x',LineWidth=2);plot(r,xfit2,'-x',LineWidth=2);plot(r,yfit2,'-x',LineWidth=2);
% for i=2:size(temp,2)/2+1
%     plot(temp{1},temp{i},'-x');
% end
legend('max(R_{x,y})_{nolin} [mm]','max(R_{px,py})_{nolin} [mrad]','max(R_{x,y})_{lin} [mm]','max(R_{px,py})_{lin} [mrad]','FontSize',11)
%,'\Delta_{y_f}','\Delta_{py_f}','\Delta_{x_m}','\Delta_{px_m}','\Delta_{y_m}','\Delta_{py_m}')
xlabel('beam size [mm]'); 
ylabel('max(R)');
 for i=1:length(temp{1})
     fprintf('%2.2f & %2.2f & %2.2f & %2.2f & %2.2f  \\\\ \n \\hline \n',[r(i),xfit(i),yfit(i),xfit2(i),yfit2(i)])
 end