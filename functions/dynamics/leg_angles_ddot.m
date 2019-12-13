% Parameters
% r1            [mm] Length thigh
% R             [mm] Length simplified tibia
% theta         [deg] Angle of tibia
% phi           [deg] Angle of splified tibia
% ddd           [mm/s^2] Vertical acceleration 
% edd           [mm/s^2] Horizontal acceleration 
% thetad		[rad/s] Angular velocity of Theta
% phid			[rad/s] Angular velocity of Phi

% Outputs
% thetadd		[rad/s^2] Angular acceleration of theta
% phidd			[rad/s^2] Angular acceleration of phi

% Calculation Function (Section 2.1 of Design Dossier)
function[thetadd, phidd] = leg_angles_ddot(r1,R,theta,thetad,phi,phid,ddd,edd)

	m1=-r1.*sind(theta);
	m2=-R.*sind(phi);
	m3=r1.*cosd(theta);
	m4=R.*cosd(phi);

	det = 1./(m4.*m1 - m2.*m3);

	m1i = det.*m4;
	m2i = -det.*m2;
	m3i= -det.*m3;
	m4i = det.*m1;

	M1 = edd+r1.*cosd(theta).*(thetad.^2)+R.*cosd(phi).*(phid.^2);
	M2 = ddd+r1.*sind(theta).*(thetad.^2)+R.*sind(phi).*(phid.^2);

	thetadd = (m1i.*(M1) + m2i.*M2);
	phidd = (m3i.*(M1) + m4i.*M2);
end