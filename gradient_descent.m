%% Reference responce
K_z_ref = 0.1070; %2.966
%K_z = 2.966;
% T_aero = ;
T_aero_ref = 0.2776;
T_motor_ref = 0.0640;


kP_z_ref = 75;
kD_z_ref = 13;


G_ref = tf([K_z_ref],[T_aero_ref*T_motor_ref T_aero_ref+T_motor_ref 1 0]);
cont_ref = tf([kD_z_ref kP_z_ref],[1]);
T_ref = feedback(G_ref*cont_ref,1);
t = 0:0.002:1.3;
y_ref = step(T_ref,t);


%% descent formulation
k_z = 1;
T_prop = 0.3;
T_1 = 0.2;

G = tf([k_z],[T_prop*T_1 T_prop+T_1 1 0]);
kP_z = 1.1766;
kD_z = 0.3143;
costs(1) = compute_cost(G,t,y_ref,kP_z,kD_z);
step = 0.01;
while(1)
    costs(2) = compute_cost(G,t,y_ref,kP_z*1.05,kD_z);
    costs(3) = compute_cost(G,t,y_ref,kP_z,kD_z*1.05);
    costs(4) = compute_cost(G,t,y_ref,kP_z*0.95,kD_z);
    costs(5) = compute_cost(G,t,y_ref,kP_z,kD_z*0.95);
    [cost,i] = min(costs);
    switch(i)
        case 1
            break
        case 2
            kP_z = kP_z*(1+step);
            costs(1) = cost;
        case 3
            kD_z = kD_z*(1+step);
            costs(1) = cost;
        case 4
            kP_z = kP_z*(1-step);
            costs(1) = cost;
        case 5
            kD_z = kD_z*(1-step);
            costs(1) = cost;
    end
end




function cost = compute_cost(G,t,y_ref,kP_z,kD_z)
    cont = tf([kD_z,kP_z],[1]);
    T = feedback(G*cont,1);
    y = step(T,t);
    cost = sum(abs((y_ref-y)));
end