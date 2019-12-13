% Parameters
% m1                mass of knee [kg]
% m2                mass of foot [kg]
% l                 simplified length of tibia [m]
% L                 length of thigh [m]
% theta             angle of thigh [deg]
% phi               angle of simplified tibia [deg]
% thetadd           angular acceleration of tibia [rad/s]
% phidd             angular acceleration of thigh [rad/s]
% N                 Normal force [N]
% f                 Friction force [N]
% k_hip             Spring constant hip [Nmm]
% k_knee            Spring constant knee [Nmm]
% Correction_hip    Angle of correction hip [deg]
% Correction_knee   Angle of correction knee [deg]

% Outputs
% torque_hip        Torque at hip [Nm]
% torque_knee       Torque at knee [Nm]

% Dynamic Equation in matrix format (Section 3.2 of Analysis Report)
function [torque_hip,torque_knee] = dynamic_equation(m1, m2, l, L, theta, phi, thetadd, phidd, N, f,k_hip,k_knee,Correction_hip,Correction_knee)
		
	M1M2_hip = ((m1+m2).*L.^2 .* thetadd) + (m2.*l.*L.*cosd(theta-phi) .* phidd);
	M1M2_knee = (m2.*l.*L.*cosd(theta-phi) .* thetadd) + (m2.*l .* phidd);
	M3_hip = (m1+m2).*L.*cosd(theta)+m2.*l.*cosd(theta);
	M3_knee = m2.*l.*cosd(phi);
	M4_hip = L.*cosd(theta)+l.*cosd(phi);
	M4_knee = l.*cosd(phi);
	M5_hip = L.*sind(theta) + l.*sind(phi);
	M5_knee = l.*sind(phi);
	
	M6_hip = M1M2_hip - 9.81*M3_hip + N.*M4_hip - f.*M5_hip;
	M6_knee = M1M2_knee - 9.81*M3_knee + N.*M4_knee - f.*M5_knee;

	% Torque corrected due to spring
	torque_hip = M6_hip - (2*k_hip*(pi/180)*(-theta + Correction_hip)/1000);
	torque_knee= M6_knee - (2*k_knee*(pi/180)*(phi-theta + Correction_knee)/1000);
end