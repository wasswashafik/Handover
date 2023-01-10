
%load gripper_pull.mat
load working.mat
error_z = 1.6 - z;
fs = 90;
fc = 0.001;
wn = fc*2/fs;
[b,a] = butter(2,wn,"high");
y = filter(b,a,error_z);
plot(error_z);
hold on
plot(y);

%% try only the flight part
load gripper_pull.mat
error_z = 1.6 - z;
fs = 90;
fc = 0.01;
wn = fc*2/fs;
[b,a] = butter(4,wn,"high");
error_z(1) = 0;
y = filter(b,a,error_z(621:3696));
plot(error_z(621:3696));
hold on
plot(y);