Parameters;
K_z =2;
%kP_z =30.875;
%kD_z = 13.152;
T_aero = 2.5;
kP_z =40;
kD_z = 17;


simout = sim("QCwithActDyn_NewPID");
a = simout.z_out.Data;
Q = sum(abs(a(6000:end)-ref(6000:end)))

%1 will be kp and -1 will be kd


% simout = sim("QCwithActDyn_NewPID");
% a = simout.z_out.Data;
% Q = 0;
% Q = abs(a(6000:end)-ref(6000:end));
% sum(Q)
