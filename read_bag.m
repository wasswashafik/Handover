
bag = rosbag("/home/anees/bagfiles/flight test.bag");

pos = select(bag,"Topic","/opti/pos");
ori = select(bag,"Topic","/Inner_Sys/body_ori");
acc = select(bag,"Topic","/imu/data");

pos_msgs = readMessages(pos);
ori_msgs = readMessages(ori);
acc_msgs = readMessages(acc);

for i = 1:size(pos_msgs)
    z(i) = double(pos_msgs{i,1}.Z);
end
for i = 1:size(ori_msgs)
    roll(i) = double(ori_msgs{i}.X);
    pitch(i) = double(ori_msgs{i}.Y);
    yaw(i) = double(ori_msgs{i}.Z);
end

for i = 1:size(acc_msgs)
    acc_x(i) = double(acc_msgs{i}.LinearAcceleration.X);
    acc_y(i) = double(acc_msgs{i}.LinearAcceleration.Y);
    acc_z(i) = double(acc_msgs{i}.LinearAcceleration.Z);
end

%% interpolate to make them all in the same range

acc_x = interp1(1:length(acc_x),acc_x,1:length(z));
acc_y = interp1(1:length(acc_y),acc_y,1:length(z));
acc_z = interp1(1:length(acc_z),acc_z,1:length(z));
roll = interp1(1:length(roll),roll,1:length(z));
pitch = interp1(1:length(pitch),pitch,1:length(z));
yaw = interp1(1:length(yaw),yaw,1:length(z));


