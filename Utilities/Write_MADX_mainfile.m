function []= Write_MADX_mainfile(init_pars,k0,k1,k2,k3,k4,ksex,filename)
S = readlines(filename);
fileID=fopen(filename,'w');
i=1;
while i<size(S,1)
    if i==9
        fprintf(fileID,"rho:=%f;\n",init_pars(3));
        fprintf(fileID,"k:=%f;\n",init_pars(2));
        fprintf(fileID,"l_drift:=%f;\n",init_pars(1));
        fprintf(fileID,"phi_x :=%f;\n",init_pars(4));
        fprintf(fileID,"phi_y :=%f;\n",init_pars(5));
        fprintf(fileID,"kl0:=%f;\n",k0);
        fprintf(fileID,"kl1:=%f;\n",k1);
        fprintf(fileID,"kl2:=%f;\n",k2);
        fprintf(fileID,"kl3:=%f;\n",k3);
        fprintf(fileID,"kl4:=%f;\n",k4);
        fprintf(fileID,"ksex:=%f;\n",ksex);
        i=21;
    else
        fprintf(fileID,S(i));
        i=i+1;
    end
    fprintf(fileID,'\n');
end
fclose(fileID);
end