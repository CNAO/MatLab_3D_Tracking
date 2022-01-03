function diff_M = Optimization_Matrix(Parameters)

global set;

%% Call routine to define transfer matrices
Matrix_function

%% Parameters assignation

l1 = Parameters(1);
% l2 = Parameters(2);
phi = Parameters(2);
kd = Parameters(3);
theta = Parameters(4);

l2 = 1.329-l1-set.R*theta;

if set.F==true

    MX_end = M_Drift(l2)*M_edge(phi,set.R)*M_Dip_Quad_F(set.R*theta/2,kd,set.R)*...
             M_Dip_Quad_F(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_F(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);

    MY_end = M_Drift(l2)*M_edge(-phi,set.R)*M_Quad_D(set.R*theta/2,kd)*...
             M_Quad_D(set.R*theta/2,kd)*M_edge(-phi,set.R)*M_Drift(l1);
    MY_mid = M_Quad_D(set.R*theta/2,kd)*M_edge(-phi,set.R)*M_Drift(l1);
    
else
    
    MX_end = M_Drift(l2)*M_edge(phi,set.R)*M_Dip_Quad_D(set.R*theta/2,kd,set.R)*...
             M_Dip_Quad_D(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);
    MX_mid = M_Dip_Quad_D(set.R*theta/2,kd,set.R)*M_edge(phi,set.R)*M_Drift(l1);

    MY_end = M_Drift(l2)*M_edge(-phi,set.R)*M_Quad_F(set.R*theta/2,kd)*...
             M_Quad_F(set.R*theta/2,kd)*M_edge(-phi,set.R)*M_Drift(l1);
    MY_mid = M_Quad_F(set.R*theta/2,kd)*M_edge(-phi,set.R)*M_Drift(l1);
    
end


diff_MX = sum(sum(abs(MX_end-set.MX_mad_end).^1)) + sum(sum(abs(MX_mid-set.MX_mad_mid).^1));
diff_MY = sum(sum(abs(MY_end-set.MY_mad_end).^1)) + sum(sum(abs(MY_mid-set.MY_mad_mid).^1));

diff_M = diff_MX + diff_MY;
return