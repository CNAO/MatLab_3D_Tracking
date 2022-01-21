function [ dXdt ] = Motion_Eq_INFN(t,X,settings )

% disp(t)

x = X(1:settings.N);
y = X(settings.N+1:2*settings.N);
z = X(2*settings.N+1:3*settings.N);
vx = X(3*settings.N+1:4*settings.N);
vy = X(4*settings.N+1:5*settings.N);
vz = X(5*settings.N+1:6*settings.N);


%% Field Interpolation

Bx = settings.fBx([x,y,z]);
By = settings.fBy([x,y,z]);
Bz = settings.fBz([x,y,z]);

dvx = settings.qom.*(vy.*Bz - vz.*By);
dvy = settings.qom.*(vz.*Bx - vx.*Bz);
dvz = settings.qom.*(vx.*By - vy.*Bx);

dx = vx;
dy = vy;
dz = vz;

dXdt = [dx;dy;dz;dvx;dvy;dvz];
return
end

