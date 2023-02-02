function diff_M = Optimization_Matrix(Parameters)

global set;

%% Call routine to define transfer matrices
Matrix_function

%% Parameters assignation

l1 = Parameters(1);
phi_x = Parameters(4);
phi_y = Parameters(5);
kd = Parameters(2);
R = Parameters(3);

% s_tot = 1.447380824376337; %total path along s calculated with tracking (G. Frisella)
% l2 = s_tot-l1-R*set.theta;
l2 = l1;

% if set.F==true
% 
%     MX_end = M_Drift(l2)*M_edge(phi_x,R)*M_Dip_Quad_F(R*set.theta/2,kd,R)*...
%              M_Dip_Quad_F(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid = M_Dip_Quad_F(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_minus20cm = M_Dip_Quad_F(R*set.theta/2-0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_plus20cm  = M_Dip_Quad_F(R*set.theta/2+0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_minus40cm = M_Dip_Quad_F(R*set.theta/2-0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_plus40cm  = M_Dip_Quad_F(R*set.theta/2+0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     
%     MY_end = M_Drift(l2)*M_edge(-phi_y,R)*M_Quad_D(R*set.theta/2,kd)*...
%              M_Quad_D(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid = M_Quad_D(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_minus20cm = M_Quad_D(R*set.theta/2-0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_plus20cm  = M_Quad_D(R*set.theta/2+0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_minus40cm = M_Quad_D(R*set.theta/2-0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_plus40cm  = M_Quad_D(R*set.theta/2+0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     
% else
%     
%     MX_end = M_Drift(l2)*M_edge(phi_x,R)*M_Dip_Quad_D(R*set.theta/2,kd,R)*...
%              M_Dip_Quad_D(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid = M_Dip_Quad_D(R*set.theta/2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_minus20cm = M_Dip_Quad_D(R*set.theta/2-0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_plus20cm = M_Dip_Quad_D(R*set.theta/2+0.2,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_minus40cm = M_Dip_Quad_D(R*set.theta/2-0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%     MX_mid_plus40cm = M_Dip_Quad_D(R*set.theta/2+0.4,kd,R)*M_edge(phi_x,R)*M_Drift(l1);
%       
%     MY_end = M_Drift(l2)*M_edge(-phi_y,R)*M_Quad_F(R*set.theta/2,kd)*...
%              M_Quad_F(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid = M_Quad_F(R*set.theta/2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_minus20cm = M_Quad_F(R*set.theta/2-0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_plus20cm = M_Quad_F(R*set.theta/2+0.2,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_minus40cm = M_Quad_F(R*set.theta/2-0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     MY_mid_plus40cm = M_Quad_F(R*set.theta/2+0.4,kd)*M_edge(-phi_y,R)*M_Drift(l1);
%     
% end

if set.F==true

    MX_end = M_Drift(l2)*M_edge_x(phi_x,R)*M_Dip_Quad_F(R*set.theta/2,kd,R)*...
             M_Dip_Quad_F(R*set.theta/2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_F(R*set.theta/2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_minus20cm = M_Dip_Quad_F(R*set.theta/2-0.2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_plus20cm  = M_Dip_Quad_F(R*set.theta/2+0.2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_minus40cm = M_Dip_Quad_F(R*set.theta/2-0.4,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_plus40cm  = M_Dip_Quad_F(R*set.theta/2+0.4,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    
    MY_end = M_Drift(l2)*M_edge_y(phi_y,R)*M_Quad_D(R*set.theta/2,kd)*...
             M_Quad_D(R*set.theta/2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid = M_Quad_D(R*set.theta/2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_minus20cm = M_Quad_D(R*set.theta/2-0.2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_plus20cm  = M_Quad_D(R*set.theta/2+0.2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_minus40cm = M_Quad_D(R*set.theta/2-0.4,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_plus40cm  = M_Quad_D(R*set.theta/2+0.4,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    
else
    
    MX_end = M_Drift(l2)*M_edge_x(phi_x,R)*M_Dip_Quad_D(R*set.theta/2,kd,R)*...
             M_Dip_Quad_D(R*set.theta/2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_D(R*set.theta/2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_minus20cm = M_Dip_Quad_D(R*set.theta/2-0.2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_plus20cm = M_Dip_Quad_D(R*set.theta/2+0.2,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_minus40cm = M_Dip_Quad_D(R*set.theta/2-0.4,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
    MX_mid_plus40cm = M_Dip_Quad_D(R*set.theta/2+0.4,kd,R)*M_edge_x(phi_x,R)*M_Drift(l1);
      
    MY_end = M_Drift(l2)*M_edge_y(phi_y,R)*M_Quad_F(R*set.theta/2,kd)*...
             M_Quad_F(R*set.theta/2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid = M_Quad_F(R*set.theta/2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_minus20cm = M_Quad_F(R*set.theta/2-0.2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_plus20cm = M_Quad_F(R*set.theta/2+0.2,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_minus40cm = M_Quad_F(R*set.theta/2-0.4,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    MY_mid_plus40cm = M_Quad_F(R*set.theta/2+0.4,kd)*M_edge_y(phi_y,R)*M_Drift(l1);
    
end


diff_MX = sum(sum(abs(MX_end-set.MX_mad_end).^2))...
+ sum(sum(abs(MX_mid-set.MX_mad_mid).^2));% ...
% + sum(sum(abs(MX_mid_minus20cm-set.MX_mad_mid_minus20cm).^2))...
% + sum(sum(abs(MX_mid_minus40cm-set.MX_mad_mid_minus40cm).^2));%...
% + sum(sum(abs(MX_mid_plus20cm-set.MX_mad_mid_plus20cm).^2))...
% + sum(sum(abs(MX_mid_plus40cm-set.MX_mad_mid_plus40cm).^2));
      
diff_MY = sum(sum(abs(MY_end-set.MY_mad_end).^2)) ...
+ sum(sum(abs(MY_mid-set.MY_mad_mid).^2));% ...
% + sum(sum(abs(MY_mid_minus20cm-set.MY_mad_mid_minus20cm).^2))+ ...
% + sum(sum(abs(MY_mid_minus40cm-set.MY_mad_mid_minus40cm).^2));
% + sum(sum(abs(MY_mid_plus20cm-set.MY_mad_mid_plus20cm).^2))...
% + sum(sum(abs(MY_mid_plus40cm-set.MY_mad_mid_plus40cm).^2));

diff_M = diff_MX + diff_MY;
return