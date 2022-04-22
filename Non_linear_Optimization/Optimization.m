function diff = Optimization(Parameters)

% Read the output file of tracking
fid=fopen(['..\Results_Track\Output_Particles\R_2_5_f.csv'],'r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Results_Track\Output_Particles\R_2_5_m.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];

%% Parameters assignation

ks1 = Parameters(1);
ks2= Parameters(2);
ks3 = Parameters(3);


Write_MADX_mainfile(ks1,ks2,ks3)

% Run mad-x
[status]=system('madx.exe main_1.madx > nul');
if ( status ~= 0 )
    error("error in running MADX!");
end
% Read output tracking file of mad-x
[Xf_t,Xm_t]=Load_Final_Vector();
% Compare the two vector (absolute error)
R_f=Xf-Xf_t;
diff_f=max(abs(R_f))
diff_f=max(diff_f)
R_m=Xm-Xm_t;
diff_m=max(abs(R_m))
diff_m=max(diff_m)
diff=(diff_m)+(diff_f);

