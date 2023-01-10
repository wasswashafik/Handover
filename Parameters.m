%%
T = 8;
T_motor = 0.0640;

K_roll = 69.356;
T_roll = 0.2493;
tau_roll = 0.0090;

K_pitch = 83.0794;
T_pitch = 0.2494;
tau_pitch = 0.0034;

K_z = 0.1070; %2.966
%K_z = 2.966;
% T_aero = ;
T_aero = 0.2776;
tau_z = 0.0656;
tau_x = 0.00005;
tau_y = 0.00005;

%% Gain Margin = 1.3
kP_y = 34.775;
kD_y = 9.07;
kI_y = 0;
D2 = 0;

kP_x = 34.7159;
kD_x = 9.0766;
kI_x = 0;
D2 = 0;

kP_z = 75;
kD_z = 13;

kP_P = 0.9449;
kD_P = 0.1129;
kP_R = 0.7611;
kD_R = 0.0994;

X_Ch = 1;
Y_Ch = 1;
PVA = 1;


%% drone parameterization
M_b = 0.267;
M_d = 0.854;
M = M_b +M_d;
J_xx = 1.0*10^-2;
J_yy = 8.2*10^-3;
j_zz = 1.48*10^-2;


%% interaction parameters
T_int = 1;
T_start = 5;
F_z = 4;
F_x = 0;
F_y = 0;
tau_theta = 0;
% 
%simout= sim("QCwithActDyn_NewPID");
%ref = simout.z_out.Data;
% %for i = 1.3:0.1:3
% %    K_z = i;
%     simout = sim('QCwithActDyn_NewPID.slx');
%     kD_z, min(simout.z_out.Data(5000:end))
%     plot(simout.z_out.Data)
%     hold on;
% end

