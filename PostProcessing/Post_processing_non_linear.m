%% Plot results of optimization

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    plot(temp{1},temp{i},'-+',LineWidth=2);
end
title('Sextupole gradients')
legend('k_{s1} [1/m^2]','k_{s2} [1/m^2]','k_{s3} [1/m^2]')
xlabel('radius [mm]'); 
ylabel('k_{s} [1/m^2]');
%% Plot results of optimization in percentage

figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    if i~=3
        plot(temp{1},abs(abs(temp{i}-temp{i}(1))/temp{i}(1))*100,'-x',LineWidth=2);
    end
end
legend('k_{s1} [1/m^2]','k_{s2} [1/m^2]','k_{s3} [1/m^2]')
title('Sextupole gradient percentage variations')
xlabel('radius [mm]'); 
ylabel('$\frac{|x-E[x]|}{|E[x]|}\cdot 100 \%$ ','Interpreter','latex','FontSize',15);
%% Plot Linear Matrix elements of optimization

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',15);
fclose(fid);
figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    plot(temp{1},temp{i},'-x');
end
title('Phase space coordinates after optimization')
legend('\Delta_{x_f}','\Delta_{px_f}','\Delta_{y_f}','\Delta_{py_f}','\Delta_{x_m}','\Delta_{px_m}','\Delta_{y_m}','\Delta_{py_m}')
xlabel('radius [mm]'); 
ylabel('Results');
%% Plot Linear Matrix elements of optimization in percentage

figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    plot(temp{1},abs(abs(temp{i}-temp{i}(1))/temp{i}(1))*100,'-x',LineWidth=2);
end
legend('\Delta_{x_f}','\Delta_{px_f}','\Delta_{y_f}','\Delta_{py_f}','\Delta_{x_m}','\Delta_{px_m}','\Delta_{y_m}','\Delta_{py_m}')
title('Phase space coordinate percentage variations after optimization')
xlabel('radius [mm]'); 
ylabel('$\frac{|x-E[x]|}{|E[x]|}\cdot 100 \%$ ','Interpreter','latex','FontSize',15);

ylabel('$\frac{|x-E[x]|}{|E[x]|}\cdot 100 \%$ ','Interpreter','latex','FontSize',15);
%% Plot Linear Matrix elements NON OPTIMIZED

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',28);
fclose(fid);
figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    plot(temp{1},temp{i},'-x');
end
title('Phase space coordinates')
legend('\Delta_{x_f}','\Delta_{px_f}','\Delta_{y_f}','\Delta_{py_f}','\Delta_{x_m}','\Delta_{px_m}','\Delta_{y_m}','\Delta_{py_m}')
xlabel('radius [mm]'); 
ylabel('Results');
%% Plot Linear Matrix elements NON OPTIMIZED in percentage

figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    plot(temp{1},abs(abs(temp{i}-temp{i}(1))/temp{i}(1))*100,'-x',LineWidth=2);
end
legend('\Delta_{x_f}','\Delta_{px_f}','\Delta_{y_f}','\Delta_{py_f}','\Delta_{x_m}','\Delta_{px_m}','\Delta_{y_m}','\Delta_{py_m}')
title('Phase space coordinate percentage variations')
xlabel('radius [mm]'); 
ylabel('$\frac{|x-E[x]|}{|E[x]|}\cdot 100 \%$ ','Interpreter','latex','FontSize',15);



%% Plot Linear Matrix elements NON OPTIMIZED vs OPTIMIZED

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',15);
fclose(fid);

fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp2 = textscan(fid,readFormat,'HeaderLines',28);
fclose(fid);
diff=zeros(11,size(temp,2)-1);
for i=2:size(temp,2)
    diff(:,i)=100*abs(temp2{i}-temp{i})./temp2{i};
end

figure; hold on;grid on; box on; 
for i=2:size(temp,2)
    plot(temp{1},diff(:,i),'-x');
end
title('percentage variations from non opt to opt syst ')
legend('\Delta_{x_f}','\Delta_{px_f}','\Delta_{y_f}','\Delta_{py_f}','\Delta_{x_m}','\Delta_{px_m}','\Delta_{y_m}','\Delta_{py_m}')
xlabel('radius [mm]'); 
ylabel('$|\frac{x-x_{opt}}{x}|\cdot 100 \%$ ','Interpreter','latex','FontSize',15);
