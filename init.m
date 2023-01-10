

%% payload parameters
k_eq = 0.2337;
T_1 = 0.5794;
T_prop = 0.0177;
tau = 0.0526;
kP_z = 80;
kD_z = 17;
s = tf("s");
G = k_eq/(s*(T_prop*s+1)*(T_1*s+1));
K  = kP_z+kD_z*s;
T = K*G/(1+K*G);



%% ousama drone parameters
k_eq = 1;
T_1 = 0.2;
T_prop = 0.3;
tau = 0.0128;
kD_z = 0.3143;
kP_z = 1.1766;
s = tf("s");
G_ous = k_eq/(s*(T_prop*s+1)*(T_1*s+1));
K  = kP_z+kD_z*s;
T_ous = K*G/(1+K*G);


%% 
[k,Cl, gamma, info] = loopsyn(G_ous,T,1,3balred)