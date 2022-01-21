% Obtain the quadrupole gradients of the magnet from the linear transport matrix.
% From these it builds the transport matrix by modeling the magnet as a cobined function.
function [Mt_th,k] = ModelMatrixBuilder(Mt,t0,tf,step)
% Quadrupol gradient k_sq

ds=(step(tf)-step(t0));

kx=[];
kx(1)=(acos(Mt(1,1))/ds)^2;
kx(2)=(acos(Mt(2,2))/ds)^2;
kx(3)=-Mt(2,1)/Mt(1,2);

ky=[];
ky(1)=(acosh(Mt(3,3))/ds)^2;
ky(2)=(acosh(Mt(4,4))/ds)^2;
ky(3)=Mt(4,3)/Mt(3,4);
K=[mean(kx),mean(ky)];
k_th=mean(ky)+(pi/(4*ds))^2;
k_sq=sqrt(abs(K));
rho=1./sqrt(((K(1)-K(2))));
k=[kx;ky;K rho];
% Building Transport MODEL matrix

cx=cos(k_sq(1)*ds);
cy=cosh(k_sq(2)*ds);
sx=sin(k_sq(1)*ds)/k_sq(1);
sy=sinh(k_sq(2)*ds)/k_sq(2);

%Model transport matrix

Mt_th=[cx, sx, 0, 0;-sx*K(1), cx, 0, 0; 0, 0,cy, sy;0, 0, sy*K(2), cy];


