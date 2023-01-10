function [l2_acc_in, l2_ori, dist] = get_features(roll, pitch, yaw, acc_x, acc_y, acc_z)

%Get L2 norm of accelerations on the inertial frame
[acc_x_inertial, acc_y_inertial, acc_z_inertial] = R_B2I(roll, pitch, yaw, acc_x, acc_y, acc_z); 
l2_norm_acc_inertial = sqrt(acc_x_inertial.^2 + acc_y_inertial.^2);

%Get L2 norm of the orientation on body frame
[ori_body_x, ori_body_y, ori_body_z] = R_I2B(roll, pitch, yaw, 0, 0, 1);
l2_norm_ori = sqrt(ori_body_x.^2 + ori_body_y.^2);

%Get the angle difference between acceleration and orientation
acc_dir = atan2(acc_y_inertial, acc_x_inertial);
ori_dir = atan2(ori_body_y, ori_body_x);
if abs(acc_dir - ori_dir) <= pi
    dist_acc_ori = abs(acc_dir - ori_dir);
else
    dist_acc_ori = 2*pi - abs(acc_dir - ori_dir);
end

l2_acc_in = l2_norm_acc_inertial;
l2_ori = l2_norm_ori;
dist = dist_acc_ori;
end

