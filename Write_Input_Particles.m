%% Write beam input file to be tracked

clear;clc;
%% In case you want to do all the tracking in the magnet 
var=1;
if var==1
    % Reading from a previous tracking and output file 
    fid= fopen(['Output_Particles\Global_Output.csv'],'r');
    readFormat = '%f, %f, %f, %f, %f, %f, %f, %f';
    temp = textscan(fid,readFormat,'HeaderLines',1);
    fclose(fid);
    x0=temp{1};
    y0=temp{2};
    z0=temp{3};
    phi=temp{4};
    theta=-temp{5};
else
    %% In case you want to track only half of the magnet from the center
    x0=0;y0=0;z0=0;
    phi=pi/2;
    theta=-pi;
end
%% Beam input file

n=5;
l=5*1e-3; %7.5 mm
p=1e-3; %1 mrad
x=linspace(l,-l,n)';
y=linspace(l,-l, n)';
px=linspace(-p,+p,n)';
py=linspace(-p,+p,n)';
n=n^4;
fileID = fopen(['Input_Particles\Particletot.csv'],'w');
%En=linspace(430,430,n);
En=linspace(377.132,377.132,n);
id=linspace(1,n,n);
s=1;
fprintf(fileID, 'X[m],pX,Y[m],pY,Theta[rad],Phi[rad],Id,En[MeV],Xideal[m],Yideal[m],Zideal[m]\n');
for b=1:size(py,1)
    for k=1:size(y,1)
        for j=1:size(px,1)
            for i=1:size(x,1)
                fprintf(fileID,'%12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f, %12.12f\n',x(i),px(j),y(k),py(b),theta,phi,id(s),En(s),x0,y0,z0);
            s=s+1;
            end
        end
    end
end
fclose(fileID);




