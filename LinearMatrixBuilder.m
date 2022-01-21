%Built linear transport matrix 
function [Mt,X0,XF] = LinearMatrixBuilder(Coordinates,Momentum,t0,tf,N)
XF=zeros(4,N); %local coordinates vector at the end
X0=zeros(4,N); %local coordinates vector at beginning
for i=1:N
        XF(:,i)=[Coordinates{i}(tf,1),Momentum{i}(tf,1),Coordinates{i}(tf,2),Momentum{i}(tf,2)];
        X0(:,i)=[Coordinates{i}(t0,1),Momentum{i}(t0,1),Coordinates{i}(t0,2),Momentum{i}(t0,2)];
end
Mt=XF/X0; %mrdived of matlab If A is a rectangular m-by-n matrix with m ~= n, and B is a matrix with n columns, then x = B/A returns a least-squares solution of the system of equations x*A = B. 

