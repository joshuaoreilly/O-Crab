% Parameters
% r1 			[mm] Length of thigh
% r2			[mm] Length of upper tibia
% r3			[mm] Length of lower tibia
% e_max			[mm] Max distance in x
% d				[mm] Height of the thigh motor
% alpha			[deg] Angle of the bend in the tibia
% R				[mm] Length of simplified tibia

% Outputs
% Theta 		[deg] Angle between horizontal and thigh
% Phi			[deg] Angle between horizontal and simplified tibia
% Psy			[deg] Angle between horizontal and upper tibia
% Alpha			[deg] Angle between horizontal and lower tibia
% small_phi		[deg] Angle between Phi and Psy

% Geometric Calculations Function (Section 2.1 of Design Dossier)
function[Theta, Phi, Psy, Alpha,small_phi] = Dynamics(r1,r2,r3,e_max,d,alpha,R)
C = sqrt(e_max^2+d^2);
c = acosd((C^2-r1^2-R^2)/(-2*r1*R));
b = acosd((R^2-r1^2-C^2)/(-2*r1*C));
small_phi = acosd((r3^2-r2^2-R^2)/(-2*r2*R));
Theta = b + atand(e_max/d)-90;
Phi = Theta + c -180;
Psy = Phi + small_phi;
Alpha = Psy + alpha + 180;

