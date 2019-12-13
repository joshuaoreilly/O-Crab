% Parameters
% r1            [mm] Length thigh
% R             [mm] Length simplified tibia
% theta         [deg] Angle of tibia
% phi           [deg] Angle of splified tibia
% dd           	[mm/s] Vertical velocity 
% ed           	[mm/s] Horizontal velocity 

% Ouputs
% thetad		[rad/s] Angular velocity of Theta
% phid			[rad/s] Angular velocity of Phi

% Calculation Function (Section 2.1 of Design Dossier)
function[thetad, phid] = leg_angles_dot(r1,R,theta,phi,dd,ed)
	m1=-r1.*sind(theta);
	m2=-R.*sind(phi);
	m3=r1.*cosd(theta);
	m4=R.*cosd(phi);

	det = 1./(m4.*m1 - m2.*m3);

	m1i = det.*m4;
	m2i = -det.*m2;
	m3i= -det.*m3;
	m4i = det.*m1;

	thetad = (m1i.*ed + m2i.*dd);
	phid = (m3i.*ed + m4i.*dd);
end