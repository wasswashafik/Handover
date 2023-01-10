function detection_output  = LSTM(error_z, acc_x, acc_y, acc_z, roll, pitch, yaw)

persistent drone_handover_model
persistent p_01_h_t
persistent p_01_c_t
persistent p_03_h_t
persistent p_03_c_t
persistent scaling_params
persistent buffer
persistent counter
persistent clean_detection

downsample_by = 3;

if isempty(drone_handover_model)
    drone_handover_model = coder.load('Model_2f_norm/drone_handover_model.mat');
    scaling_params = coder.load('Model_2f_norm/Scaling.mat');
    p_01_h_t = single(zeros(1,200));
    p_01_c_t = single(randn(1,200)/10);
    p_03_h_t = single(zeros(1,100));
    p_03_c_t = single(randn(1,100)/10);
    buffer = single(zeros(7,downsample_by));
    counter = 1;
    clean_detection = 0;
end

% buffer(1,counter) = error_z;
% buffer(2,counter) = acc_x;
% buffer(3,counter) = acc_y;
% buffer(4,counter) = acc_z;
% buffer(5,counter) = roll;
% buffer(6,counter) = pitch;
% buffer(7,counter) = yaw;

% if counter == downsample_by
% counter = 1;
% error_z = mean(buffer(1,:));
% acc_x = mean(buffer(2,:));
% acc_y = mean(buffer(3,:));
% acc_z = mean(buffer(4,:));
% roll = mean(buffer(5,:));
% pitch = mean(buffer(6,:));
% yaw = mean(buffer(7,:));
% 
[acc_x_inertial, acc_y_inertial, acc_z_inertial] = R_B2I(roll, pitch, yaw, acc_x, acc_y, acc_z);
% 
l2_norm_acc_inertial = sqrt(acc_x_inertial.^2 + acc_y_inertial.^2);
% 
% [ori_body_x, ori_body_y, ori_body_z] = R_I2B(roll, pitch, yaw, 0, 0, 1);
% 
%     l2_norm_ori = sqrt(ori_body_x.^2 + ori_body_y.^2);
%     % 
%     acc_dir = atan2(acc_y_inertial, acc_x_inertial);
%     ori_dir = atan2(ori_body_y, ori_body_x);
%     
%     if abs(acc_dir - ori_dir) <= pi
%         dist_acc_ori = abs(acc_dir - ori_dir);
%     else
%         dist_acc_ori = 2*pi - abs(acc_dir - ori_dir);
%     end

% %%Scaling
% % X_std = (X - X.min(axis=0)) / (X.max(axis=0) - X.min(axis=0))
error_z = (error_z - scaling_params.data_Z_params(1)) / (scaling_params.data_Z_params(2)-scaling_params.data_Z_params(1));
error_z = error_z * 2 - 1;
l2_norm_acc_inertial = (l2_norm_acc_inertial  - scaling_params.data_L2_norm_inertial_params(1)) / (scaling_params.data_L2_norm_inertial_params(2)-scaling_params.data_L2_norm_inertial_params(1));
l2_norm_acc_inertial = l2_norm_acc_inertial * 2 - 1;
%     l2_norm_ori = (l2_norm_ori - scaling_params.data_L2_norm_ori_params(1)) / (scaling_params.data_L2_norm_ori_params(2)-scaling_params.data_L2_norm_ori_params(1));
%     dist_acc_ori = (dist_acc_ori - scaling_params.data_dist_acc_ori_params(1)) / (scaling_params.data_dist_acc_ori_params(2)-scaling_params.data_dist_acc_ori_params(1));
% 

input_data = [error_z l2_norm_acc_inertial];

[detection, p_01_c_t, p_01_h_t, p_03_c_t, p_03_h_t] = model_classify(input_data, ...
                                                                     drone_handover_model, ...
                                                                     p_01_c_t, ...
                                                                     p_01_h_t, ...
                                                                     p_03_c_t, ...
                                                                     p_03_h_t);
                                                                 
clean_detection = clean(detection, 0.5);

detection_output = double(clean_detection);
% end

