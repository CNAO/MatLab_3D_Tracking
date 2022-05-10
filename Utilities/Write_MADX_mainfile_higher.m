function []= Write_MADX_mainfile_higher(k1,k2,k3,k4,ksex)
filename='main_decapole.madx';
S = readlines(filename);
fileID=fopen(filename,'w');
i=1;
while i<size(S,1)
    if i==12
        fprintf(fileID,"kl1:=%f;\n",k1);
        fprintf(fileID,"kl2:=%f;\n",k2);
        fprintf(fileID,"kl3:=%f;\n",k3);
        fprintf(fileID,"kl4:=%f;\n",k4);
        fprintf(fileID,"ksex:=%f;\n",ksex);
        i=18;
    else
        fprintf(fileID,S(i));
        i=i+1;
    end
    fprintf(fileID,'\n');
end
fclose(fileID);
end