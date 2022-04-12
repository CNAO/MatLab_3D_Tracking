function []= Write_MADX_mainfile(k1,k2,k3)
filename='main_1.madx';
S = readlines(filename);
fileID=fopen(filename,'w');
i=1;
while i<size(S,1)
    if i==12
        fprintf(fileID,"ks1:=%f;\n",k1);
        fprintf(fileID,"ks2:=%f;\n",k2);
        fprintf(fileID,"ks3:=%f;\n",k3);
        i=16;
    else
        fprintf(fileID,S(i));
        i=i+1;
    end
    fprintf(fileID,'\n');
end
fclose(fileID);
end