%Matrix function definition

%Drift
M_Drift = @(s)[1, s;  0, 1];    

%Quadrupoles
M_Quad_F = @(s,k)[cos(sqrt(abs(k))*s), 1/sqrt(abs(k))*sin(sqrt(abs(k))*s); -sqrt(abs(k))*sin(sqrt(abs(k))*s), cos(sqrt(abs(k))*s)];          %focusing 
M_Quad_D = @(s,k)[cosh(sqrt(abs(k))*s), 1/sqrt(abs(k))*sinh(sqrt(abs(k))*s); sqrt(abs(k))*sinh(sqrt(abs(k))*s), cosh(sqrt(abs(k))*s)]; %defocusig 

%Dipole
M_Dip = @(phi,R)[cos(phi), R*sin(phi); -1/R*sin(phi), cos(phi)]; 

%Edge 
M_edge =@(phi,R)[1,0; tan(phi)/R, 1];

%Comboined function Dipole and Quadrupole
%[Transfer matrices of superimposed magnets and RF cavity - Chun-xi Wang and Alex Chao ]
M_Dip_Quad_F = @(s,k,R)[cos(sqrt(abs(k+1/R^2))*s),   1/sqrt(abs(k+1/R^2))*sin(sqrt(abs(k+1/R^2))*s);...
                       -sqrt(abs(k+1/R^2))*sin(sqrt(abs(k+1/R^2))*s),     cos(sqrt(abs(k+1/R^2))*s)];          %focusing 
M_Dip_Quad_D = @(s,k,R)[cosh(sqrt(abs(k+1/R^2))*s), 1/sqrt(abs(k+1/R^2))*sinh(sqrt(abs(k+1/R^2))*s);...
                        sqrt(abs(k+1/R^2))*sinh(sqrt(abs(k+1/R^2))*s), cosh(sqrt(abs(k+1/R^2))*s)]; %defocusig 

% Total trasnfer matrix 
%Physics of particle accelerator (3.164)

% M11 = sqrt(b1/b0)*(cos(P)+a0*sin(P));
% M12 = sqrt(b1*b0)*sin(P);
% M21 = ((a0-a1)*cos(P)-(1+a0*a1)*sin(P))/sqrt(b1*b0);
% M22 = sqrt(b0/b1)*(cos(P)-a1*sin(P));
% M_tot = @(a0,b0,a1,b1,P)[sqrt(b1/b0)*(cos(P)+a0*sin(P)), sqrt(b1*b0)*sin(P); ((a0-a1)*cos(P)-(1+a0*a1)*sin(P))/sqrt(b1*b0), sqrt(b0/b1)*(cos(P)-a1*sin(P))];

% Beta matrix
BB = @(a,b)[b, -a; -a, (1+a^2)/b];



