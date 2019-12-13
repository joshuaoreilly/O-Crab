% Parameters
% r1 			[mm] Length of thigh
% x				[mm] Max distance in x
% y				[mm] Height of the thigh motor
% R				[mm] Length of simplified tibia

% Outputs
% theta 		[deg] Angle between horizontal and thigh
% phi			[deg] Angle between horizontal and simplified tibia

% Geometric Calculations Function (Section 2.1 of Design Dossier)
function [theta, phi] = leg_angles(r1, R, y, x)
	C = sqrt(y.^2 + x.^2);
	c = acos((C.^2 -r1^2 - R^2)/(-2*r1*R))*180/pi;
	b = acos((R^2 - r1^2 - C.^2)./(-2*r1*C))*180/pi;
	theta = b + atan(x/y)*180/pi - 90;
	phi = theta + 180 + c;
end