
part_file_txt = "Input_Particles/Particle_SIG_0_gauss_bx10_ax0_1000.csv";

fileID=fopen(part_file_txt,'r');
readFormat = '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f';
temp = textscan(fileID,readFormat,'HeaderLines',1);
fclose(fileID);

fileID = fopen('IN_part_SIG_0_bx10_ax0_1000.csv','w');

x = -temp{1};
px = temp{2};
y = temp{3};
py = -temp{4}; 

for i=1:length(x)
    fprintf(fileID,'ptc_start, x=\t%12.12f, px=\t%12.12f, y=\t%12.12f, py=\t%12.12f;\n',x(i),px(i),y(i),py(i));
end

fprintf(fileID,'return;');
fclose(fileID);