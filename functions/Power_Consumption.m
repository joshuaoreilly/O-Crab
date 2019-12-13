% Inputs
% Leg_Object 			= object containing r1, R, etc.
% HD_hip, HD_knee 		= objects of Harmonic Drives
% motor_hip,motor_knee 	= objects of motors
% theta 				= [rad] range of theta over walking cycle
% phi 					= [rad] range of phi over walking cycle
% thetad,phid 			= [rad/s] range of angular velocities over walking cycle
% torque_theta 			= [Nm] range of torques at hip over walking cycle
% torque_phi 			= [Nm] range of torques at knee over walking cycle

% Outputs
% current_consumed 		= [A] current consumed on average over walking cycle
% walking_speed			= [mm] walking speed of robot

function [current_consumed,walking_speed] = Power_Consumption(Leg_Object,HD_hip,HD_knee,motor_hip,motor_knee,theta,phi,thetad,phid,torque_theta,torque_phi)
	% Calculated the power the robot consumed over a cycle
	% Similar to Section 3.5.3 of Analysis Report, with theta_max = 28degrees
	
	r1 = Leg_Object.r1;
	x_walking_min = Leg_Object.x_walking_min;
	x_walking_max = Leg_Object.x_walking_max;
	thetad_mean = mean(abs(thetad));
	phid_mean = mean(abs(phid));
	ed = r1*0.5;			% velocity in x is multiple of leg length
	dd =0;
	ddd=0;
	edd=0;
	steps = 1000;
	e = linspace(x_walking_min,x_walking_max,steps);
	gear_ratio=100;
	% Time required per phase
	phase_time = [(x_walking_max-x_walking_min)/ed,(max(phi)-min(phi))/(mean(abs(phid))*180/pi),(max(theta)-min(theta))/(mean(abs(thetad))*180/pi)];
	step_time = phase_time./steps;
	walking_speed = (x_walking_max-x_walking_min)/sum(phase_time);
	% Total power consumption
	coulombs_consumed = 0;
	
	%--------------------------%
    %% POWER CONSUMPTION
	%--------------------------%
	% Phase 1: leg pulls body forward
	[torque_motor_theta,rpm_motor_theta] = HD_hip.getInputs(abs(torque_theta(1:1000)),abs(thetad(1:1000)));
	[torque_motor_phi,rpm_motor_phi] = HD_knee.getInputs(abs(torque_phi(1:1000)),abs(phid(1:1000)));
	coulombstheta = motor_hip.getPower(torque_motor_theta,rpm_motor_theta);
	coulombsphi = motor_knee.getPower(torque_motor_phi,rpm_motor_phi);
	coulombs_consumed = coulombs_consumed + sum(coulombstheta+coulombsphi)*step_time(1);

	% Phase 2: phi increases
	[torque_motor_theta,rpm_motor_theta] =  HD_hip.getInputs(abs(torque_theta(1001:2000)),0);
	[torque_motor_phi,rpm_motor_phi] =  HD_knee.getInputs(abs(torque_phi(1001:2000)),abs(phid_mean));
	coulombstheta = motor_hip.getPower(torque_motor_theta,rpm_motor_theta);
	coulombsphi = motor_knee.getPower(torque_motor_phi,rpm_motor_phi);
	coulombs_consumed = coulombs_consumed + sum(coulombstheta+coulombsphi)*step_time(2);

	% Phase 3: theta decreases
	[torque_motor_theta,rpm_motor_theta] =  HD_hip.getInputs(abs(torque_theta(2001:3000)),abs(thetad_mean));
	[torque_motor_phi,rpm_motor_phi] =  HD_knee.getInputs(abs(torque_phi(2001:3000)),0);
	coulombstheta = motor_hip.getPower(torque_motor_theta,rpm_motor_theta);
	coulombsphi = motor_knee.getPower(torque_motor_phi,rpm_motor_phi);
	coulombs_consumed = coulombs_consumed + sum(coulombstheta+coulombsphi)*step_time(3);
	
	current_consumed = (sum(coulombs_consumed)*5)/(phase_time(1) + phase_time(2)*5 + phase_time(3)*5);
	
	% Approximately for NVIDIA Jetson TX2, Raspberry Pi, sensors, etc.
	% Wattage is given in Table 1 of Literature Review
	% Pi runs at 5V (1A for 5W) and Jetson runs at 7.5V (1A for 7.5W). Other electronics approximately 0.5A together
	amps_other_electronics = 2.5;
	current_consumed = current_consumed + amps_other_electronics;
end