close all;
time_stabilizer = stabilizer_data(1,:);

Plot_command = [1;... % P.1 - Reference Commands
                1;... % P.2 - Attitude Angle and Rate Control 
                1;... % P.3 - Stream Issues
                1;... % P.4 - Sample and Computation Time
                1;... % P.5 - Stabilizer Model Termination
                1;... % P.6 - Battery Level
                1];   % P.7 - Motor Commands

%% Safety log (2:6) [5]

sample_time         = stabilizer_data(2,:);
computation_time    = stabilizer_data(3,:);
stop_model          = stabilizer_data(4,:);
comm_issue          = stabilizer_data(5,:);
watchdog_issue      = stabilizer_data(6,:);

%% Controller log (7:20) [14]

% Attitude Commands
cmd_angle_roll           = stabilizer_data(8,:);
cmd_angle_pitch          = stabilizer_data(9,:);


%% Plant log (21:41) [21]

est_roll            = stabilizer_data(24,:);
est_pitch           = stabilizer_data(25,:);
est_yaw             = stabilizer_data(26,:);

gyro_x              = stabilizer_data(30,:);
gyro_y              = stabilizer_data(31,:);

%% Signal conditioning for plots

% Attitude Estimates
est_roll_deg    = (180/pi).*est_roll;
est_pitch_deg   = (180/pi).*est_pitch;

% Attitude Rate Estimates (HARDWARE FILTERED GYROSCOPE)
est_roll_rate_degps     = (180/pi).*gyro_x;
est_pitch_rate_degps    = (180/pi).*gyro_y;

%%

close all;
time_commander = commander_data(1,:);

%% Controller log (22:37)[16]
cmd_z               = commander_data(24,:);
est_x               = commander_data(26,:);
est_y               = commander_data(27,:);
est_z               = commander_data(28,:);
error_z = cmd_z - est_z;



%% Pose Plots

if Plot_command(1)
    figure; 
    hold on;
%     plot(time_commander, est_z, 'r');
    plot(time_commander, cmd_z, 'b');
    plot(time_commander, error_z, 'b');
    hold off;
    ylabel('Z (m)');
    xlabel('time (s)');
    grid on; grid minor;
    legend('Estimated');
end

%% P.2 (2 plots) - Attitude Angle and Rate

if Plot_command(2)
% P.2.1 Attitude Angle
    figure;
    title('Attitude Angle Control (roll and pitch)');
    subplot(2,1,1);
    hold on;
        plot(time_stabilizer, est_roll_deg, 'r');
    hold on;
        plot(time_stabilizer, cmd_angle_roll, 'b');
    hold off; grid on; grid minor; 
    legend('Roll Estimate', 'Commanded');
    xlabel('Time (s)');
    ylabel('deg');
    subplot(2,1,2);
    hold on;
        plot(time_stabilizer, est_pitch_deg, 'r');
    hold on;
        plot(time_stabilizer, cmd_angle_pitch, 'b');
    hold off; grid on; grid minor; 
    legend('Pitch Estimate', 'Commanded');
    xlabel('Time (s)');
    ylabel('deg');

% P.2.2 Attitude Rate Control
    figure;
    title('Attitude Rate (Roll, Pitch and Yaw)');
    subplot(2,1,1);
    hold on;
        plot(time_stabilizer, est_roll_rate_degps, 'r');
    hold off; grid on; grid minor; 
    legend('Roll Rate Estimate');
    xlabel('Time (s)');
    ylabel('deg/s');
    subplot(2,1,2);
    hold on;
        plot(time_stabilizer, est_pitch_rate_degps, 'r');
    hold off; grid on; grid minor; 
    legend('Pitch Rate Estimate');
    xlabel('Time (s)');
    ylabel('deg/s');
end

%%
time_acc = optitack_imu_data(1,:);
acc_x = optitack_imu_data(9,:);
acc_y = optitack_imu_data(10,:);
acc_z = optitack_imu_data(11,:);
gyro_x = optitack_imu_data(12,:);
gyro_y = optitack_imu_data(13,:);
gyro_z = optitack_imu_data(14,:);
l2_norm_acc = sqrt(acc_x.^2 + acc_y.^2);

%%

if Plot_command(3)
% P.2.1 Attitude Angle
    figure;
    title('Accelerometers (x and y)');
    subplot(3,1,1);
    hold on;
        plot(time_acc, acc_x, 'r');
    hold off; grid on; grid minor; 
    legend('Accel X');
    xlabel('Time (s)');
    ylabel('m/s^2');
    subplot(3,1,2);
    hold on;
        plot(time_acc, acc_y, 'r');
    hold off; grid on; grid minor; 
    legend('Accel Y');
    xlabel('Time (s)');
    ylabel('m/s^2');
    subplot(3,1,3);
    hold on;
        plot(time_acc, l2_norm_acc, 'r');
    hold off; grid on; grid minor; 
    legend('L2 Norm');
    xlabel('Time (s)');
    ylabel('m/s^2');
end

%% Body to Inertial
max_size = length(acc_x);

for i = 1:max_size
    [acc_x_inertial(i), acc_y_inertial(i), acc_z_inertial(i)] = R_B2I(est_roll(i), est_pitch(i), est_yaw(i), acc_x(i), acc_y(i), acc_z(i));
end
l2_norm_acc_inertial = sqrt(acc_x_inertial.^2 + acc_y_inertial.^2);

%%
if Plot_command(3)
% P.2.1 Attitude Angle
    figure;
    title('Accelerometers Inertial (x and y)');
    subplot(3,1,1);
    hold on;
        plot(time_acc, acc_x_inertial, 'r');
    hold off; grid on; grid minor; 
    legend('Accel X');
    xlabel('Time (s)');
    ylabel('m/s^2');
    subplot(3,1,2);
    hold on;
        plot(time_acc, acc_y_inertial, 'r');
    hold off; grid on; grid minor; 
    legend('Accel Y');
    xlabel('Time (s)');
    ylabel('m/s^2');
    subplot(3,1,3);
    hold on;
        plot(time_acc, l2_norm_acc_inertial, 'r');
    hold off; grid on; grid minor; 
    legend('L2 Norm');
    xlabel('Time (s)');
    ylabel('m/s^2');
end

%% Angle between Accelerations and Attitude



dist_acc_ori = zeros(1, max_size);

for i = 1:max_size

    [ori_body_x(i), ori_body_y(i), ori_body_z(i)] = R_I2B(est_roll(i), est_pitch(i), est_yaw(i), 0, 0, 1);
    l2_norm_ori(i) = sqrt(ori_body_x(i).^2 + ori_body_y(i).^2);
    
        acc_dir = atan2(acc_y_inertial(i), acc_x_inertial(i));
        ori_dir = atan2(ori_body_y(i), ori_body_x(i));

        if abs(acc_dir - ori_dir) <= pi
            dist_acc_ori(i) = abs(acc_dir - ori_dir);
        else
            dist_acc_ori(i) = 2*pi - abs(acc_dir - ori_dir);
        end
    
end


%%

figure;
plot(time_acc, error_z);
hold on
plot(time_acc, l2_norm_acc_inertial);
hold on
plot(time_acc, l2_norm_ori);
hold on
plot(time_acc, dist_acc_ori);
legend('error_z', 'l2_norm_acc', 'l2_norm_ori', 'dist_acc_ori')
%%
if Plot_command(3)
% P.2.1 Attitude Angle
    figure;
    title('Distance from Acc to Ori');
    hold on;
    plot(time_acc, dist_acc_ori, 'r');
    hold off; grid on; grid minor; 
    legend('Dist (rad)');
    xlabel('Time (s)');
    ylabel('m/s^2');

end

%%
downsample_error_z = downsample(error_z, 5);
downsample_l2_norm_acc = downsample(l2_norm_acc, 5);
downsample_acc_x = downsample(acc_x, 5);
downsample_acc_y = downsample(acc_y, 5);
downsample_acc_x_inertial = downsample(acc_x_inertial, 5);
downsample_acc_y_inertial = downsample(acc_y_inertial, 5);
downsample_l2_norm_acc_inertial = downsample(l2_norm_acc_inertial, 5);
downsample_l2_norm_ori = downsample(l2_norm_ori, 5);
downsample_dist_acc_ori = downsample(dist_acc_ori, 5);

downsample_est_roll = downsample(est_roll, 5);
downsample_est_pitch = downsample(est_pitch, 5);
downsample_est_yaw = downsample(est_yaw, 5);
downsample_time_acc = downsample(time_acc, 5);
downsample_time_commander = downsample(time_commander, 5);
downsample_time_stabilizer = downsample(time_stabilizer, 5);