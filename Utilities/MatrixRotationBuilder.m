function [Mr] = MatrixRotationBuilder(angle,index)

% Bulding Rotation Matrix
s=sin(angle);
c=cos(angle);
%For avoid numerical errors
% if abs(c)<1e-10
%     c=0;
% elseif abs(s)<1e-10
%     s=0;
% end
%index==1 is a rotation around x-axis; index==2 is a rotation around y-axis
if index==1
    Mr=[1 0 0; 0 c -s; 0 s c];
else
    Mr=[c 0 s; 0 1 0; -s 0 c]; 
end
