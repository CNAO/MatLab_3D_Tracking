%% Write the LOCAL or GLOBAL coordinates of output particles in a csv file
function[] = Write_Output_Particles(coordinates,momentum,phi,theta,time,Ideal,En,N,x,y,z,type)
format long;
if type==1
    fileID = fopen('Output_Particles\Local_Output.csv','w');
    fprintf(fileID, 'X[m],pX,Y[m],pY,Theta[rad],Phi[rad],Id,En[MeV],Xideal[m],Yideal[m],Zideal[m]\n');
    for i=1:N
        fprintf(fileID,'%12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f\n',coordinates{i}(time,1),momentum{i}(time,1),coordinates{i}(time,2),momentum{i}(time,2),theta(time),phi(time),i,En,x(time,Ideal),y(time,Ideal),z(time,Ideal));
    end
else
    fileID = fopen('Output_Particles\Global_Output.csv','w');
    fprintf(fileID, 'X[m],Y[m],Z[m],phi[rad],theta[rad],En[MeV],Id\n');
    for i=Ideal %1:settings.N
        fprintf(fileID,'%12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f\n',x(time,i),y(time,i),z(time,i),phi(time),theta(time),En,i);
    end

end
fclose(fileID);
