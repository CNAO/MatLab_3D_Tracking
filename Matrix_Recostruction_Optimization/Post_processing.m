%% Plot results of optimization
fid=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
figure; hold on;grid on; box on; 
plot(temp{1},temp{2},'-x');
plot(temp{1},temp{3},'-x');
plot(temp{1},temp{4},'-x');
plot(temp{1},temp{5},'-x');
legend('l_{drift} [m]','\psi_x [rad]','\psi_y [rad]','k [1/m^2]')
xlabel('radius [m]'); 
ylabel('Results');

%% Plot Linear Matrix elements of optimization

id=fopen('Results.txt','r');
readFormat = '%f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',8);
fclose(fid);
figure; hold on;grid on; box on; 
plot(temp{1},temp{2},'-x');
plot(temp{1},temp{3},'-x');
plot(temp{1},temp{4},'-x');
plot(temp{1},temp{5},'-x');
plot(temp{1},temp{6},'-x');
plot(temp{1},temp{7},'-x');
plot(temp{1},temp{8},'-x');
plot(temp{1},temp{9},'-x');
legend('M11','M12','M21','M22','M33','M34','M43','M44')
xlabel('radius [m]'); 
ylabel('Results');


