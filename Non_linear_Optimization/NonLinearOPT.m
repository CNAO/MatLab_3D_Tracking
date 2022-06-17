function diff = NonLinearOPT(Parameters)

global diff_old;

% Read the output file of tracking
fid=fopen(['..\Output_Particles\Local_Output_LF_SIG_0_48mm_45Gradi_n7_15mm.csv'],'r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of final local coordinates of tracking particles
Xf=[temp{1}, temp{2}, temp{3}, temp{4}];

fid=fopen('..\Output_Particles\Local_Output_LM_SIG_0_48mm_45Gradi_n7_15mm.csv','r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fid,readFormat,'HeaderLines',1);
fclose(fid);
% Phase space vector of middle local coordinates of tracking particles
Xm=[temp{1}, temp{2}, temp{3}, temp{4}];

%% Parameters assignation

kl1 = Parameters(1);
kl2= Parameters(2);
kl3 = Parameters(3);
kl4 = Parameters(4);
ksex = Parameters(5);
filename='main_decapole.madx';
Write_MADX_mainfile(kl1,kl2,kl3,kl4,ksex,filename)

% Run mad-x
[status]=system(['madx.exe ',filename,' > nul']);
if ( status ~= 0 )
    error("error in running MADX!");
end
% Read output tracking file of mad-x
[Xf_t,Xm_t]=Load_Final_Vector();
% Compare the two vector (absolute error)
R_f=Xf-Xf_t;
diff_f=max(abs(R_f));
sum_diff_f=sum(diff_f);
R_m=Xm-Xm_t;
diff_m=max(abs(R_m));
sum_diff_m=sum(diff_m);
diff= (sum_diff_m)+(sum_diff_f);

%% Save results
if diff<diff_old 
    diff_old=diff;
    fprintf('The parameters are %4.8f \n', Parameters);
    fprintf('Final difference are %4.5e \n', diff_f);
    fprintf('Final sum difference is %4.5e \n', sum_diff_f);
    fprintf('Middle sum difference is %4.5e \n \n', sum_diff_m);

%     fprintf('Middle sum differences are %4.5f \n', diff_m);

    save('Results_SIG_0_48mm_45Gradi_n7_15mm_v00.mat', 'Parameters', 'diff_f', 'diff_m');
end


