%exploring the relation between keq and the lowest point of the pull
Parameters;

gains = [kD_z];
simout = sim("QCwithActDyn_NewPID");
a = simout.z_out.Data;
mini = min(a(6000:end));
lowest = [mini];
for i = [0.1:0.1:1]
    kD_z = kD_z+i;
    simout = sim("QCwithActDyn_NewPID");
    a = simout.z_out.Data;
    mini = min(a(6000:end));
    gains(end+1) = kD_z;
    lowest(end+1) = mini;
end