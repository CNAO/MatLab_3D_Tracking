Ideal=100;
for t=1:size(x,1)
    V=sqrt(vx(t,Ideal)^2+vy(t,Ideal)^2+vz(t,Ideal)^2); %total velocity
    phi(t)=acos(vy(t,Ideal)/V); 
    theta(t)=acos(vz(t,Ideal)/(V*sin(phi(t)))); 
    psi(t)=acos(vx(t,Ideal)/(V*sin(phi(t)))); 
%     theta(t)=acos(vz(t,Ideal)/V); 
if vx(t,Ideal)<0
    v1=round(MatrixRotationBuilder(theta(t),2)*[vx(t,Ideal);vy(t,Ideal);vz(t,Ideal)],6);
else
    v1=round(MatrixRotationBuilder(2*pi-theta(t),2)*[vx(t,Ideal);vy(t,Ideal);vz(t,Ideal)],6);
end

    vx1(t)=v1(1);
    vy1(t)=v1(2);
    vz1(t)=v1(3);
    v1=MatrixRotationBuilder(pi/2-phi(t),1)*v1;
    vx2(t)=v1(1);
    vy2(t)=v1(2);
    vz2(t)=v1(3);
end
return;
%%

deltax=(x(1,Ideal)-x(1,Ideal-1))^2;
deltay=(y(1,Ideal)-y(1,Ideal-1))^2;
deltaz=(z(1,Ideal)-z(1,Ideal-1))^2;
sqrt(deltaz+deltay+deltax )
%%
t=size(x,1);
for Ideal=1:size(x,2)
    V=sqrt(vx(t,Ideal)^2+vy(t,Ideal)^2+vz(t,Ideal)^2); %total velocity
    phi(Ideal)=acos(vy(t,Ideal)/V); 
    theta2(Ideal)=acos(vz(t,Ideal)/(V*sin(phi(Ideal)))); 
end