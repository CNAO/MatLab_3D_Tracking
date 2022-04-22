function [value, isterminal, direction] = myEvent(X,settings)

x = max(X(1:settings.N));
y = max(X(settings.N+1:2*settings.N));
z = max(X(2*settings.N+1:3*settings.N));
value      = (x-0.5)*(z)*(y-0.2);   % Stop the integration when this value is zero
isterminal = 1;     % Stop the integration
direction  = 0;     % The zero can be approached from either direction