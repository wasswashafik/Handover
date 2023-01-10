payload Parameters;
k_eq = 0.2337;
T_1 = 0.5794;
T_prop = 0.0177;
tau = 0.0526;
kP_z = 80;
kD_z = 13;


[Q(1),a] = error(ref);
R(1) = Q(1);
kP_z_iter = kP_z;
kD_z_iter = kD_z;
while Q(1)>1
    kP_z = kP_z_iter*0.95;
    kD_z = kD_z_iter;
    [Q(2),a] = error(ref);
    kP_z = kP_z_iter;
    kD_z = kD_z_iter*0.95;
    [Q(3),a] = error(ref);
    kP_z = kP_z_iter*1.05;
    kD_z = kD_z_iter;
    [Q(4),a] = error(ref);
    kP_z = kP_z_iter;
    kD_z = kD_z_iter*1.05;
    [Q(5),a] = error(ref);
    [Q_min,index] = min(Q);
    if index == 1
        %print("minimum=1")
        break
    else 
        switch(index)
            case 2
                kP_z_iter = 0.95*kP_z_iter;
            case 3
                kD_z_iter = 0.95*kD_z_iter;
            case 4
                kP_z_iter = 1.05*kP_z_iter;
            case 5
                kD_z_iter = 1.05*kD_z_iter;
        end
        Q(1) = Q_min
        R(end+1) = Q_min;
    end
end
    

function [Q_new,a] = error(ref)
    out = sim("QCwithActDyn_NewPID.slx");
    a = out.simout.Data;
    Q_new = sum((a(1:200)-ref(1:200)).^2);
end
    