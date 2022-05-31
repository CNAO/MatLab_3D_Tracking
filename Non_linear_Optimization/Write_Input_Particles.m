 clear;clc;
%% In case you want to do all the tracking in the magnet 

n=7;
l=15*1e-3; %1 mm
p=1e-3; %1 mrad
x=linspace(-l,l,n)';
y=linspace(l,-l, n)';
px=linspace(-p,+p,n)';
py=linspace(p,-p,n)';
n=n^4;
fileID = fopen(['IN_part_SIG_0_48mm_45Gradi_n7_15mm.csv'],'w');
for b=1:size(py,1)
    for k=1:size(y,1)
        for j=1:size(px,1)
            for i=1:size(x,1)
                fprintf(fileID,'ptc_start, x=\t%12.12f, px=\t%12.12f, y=\t%12.12f, py=\t%12.12f;\n',x(i),px(j),y(k),py(b));
            end
        end
    end
end
fprintf(fileID,'return;');
fclose(fileID);




