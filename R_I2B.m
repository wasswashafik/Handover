function [Ix, Iy, Iz] = R_I2B(roll,pitch,yaw,Bx,By,Bz)

% Ix = Bz.*sin(pitch) + Bx.*cos(pitch).*cos(yaw) - By.*cos(pitch).*sin(yaw);
% 
% Iy = Bx.*(cos(roll).*sin(yaw) - cos(yaw).*sin(pitch).*sin(roll)) + By.*(cos(roll).*cos(yaw) + sin(pitch).*sin(roll).*sin(yaw)) + Bz.*cos(pitch).*sin(roll);
% 
% Iz = Bz.*cos(pitch).*cos(roll) - By.*(cos(yaw).*sin(roll) - cos(roll).*sin(pitch).*sin(yaw)) - Bx.*(sin(roll).*sin(yaw) + cos(roll).*cos(yaw).*sin(pitch));

Rx = [1, 0, 0
      0, cos(roll), -sin(roll)
      0, sin(roll), cos(roll)];
  
Ry = [cos(pitch), 0, sin(pitch)
      0, 1, 0
      -sin(pitch), 0, cos(pitch)];
  
Rz = [cos(yaw), -sin(yaw), 0
      sin(yaw), cos(yaw), 0
      0, 0, 1];
  
out = (Rz'*Ry'*Rx') * [Bx; By; Bz] ;
Ix = out(1);
Iy = out(2);
Iz = out(3);
end