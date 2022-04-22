function [M]=reader_twiss_file()

fid=fopen('twiss.txt','r');
readFormat = '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
temp = textscan(fid,readFormat,'HeaderLines',60);
M=[temp{5} temp{6} 0 0; temp{7} temp{8} 0 0; 0 0 temp{11} temp{12}; 0 0 temp{13} temp{14}];
fclose(fid);
end