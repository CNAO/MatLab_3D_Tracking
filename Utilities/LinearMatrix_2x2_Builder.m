%Built linear transport matrix 
function [Mtx,Mty] = LinearMatrix_2x2_Builder(Coordinates,Momentum,t0,tf,N)
xf=zeros(2,N); %local coordinates vector at the end
x0=zeros(2,N); %local coordinates vector at beginning
yf=zeros(2,N); %local coordinates vector at the end
y0=zeros(2,N); %local coordinates vector at beginning
for i=1:N
        xf(:,i)=[Coordinates{i}(tf,1),Momentum{i}(tf,1)];
        x0(:,i)=[Coordinates{i}(t0,1),Momentum{i}(t0,1)];
        yf(:,i)=[Coordinates{i}(tf,2),Momentum{i}(tf,2)];
        y0(:,i)=[Coordinates{i}(t0,2),Momentum{i}(t0,2)];
end
Mtx=xf/x0; %mrdived of matlab If A is a rectangular m-by-n matrix with m ~= n, and B is a matrix with n columns, then x = B/A returns a least-squares solution of the system of equations x*A = B. 
Mty=yf/y0;
