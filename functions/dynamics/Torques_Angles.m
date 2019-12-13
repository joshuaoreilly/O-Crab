% Inputs
% leg_Object 			= object containing r1, R, m1, m2
% force_Object 			= object containing forces
% k_hip, k_knee 		= [Nmm] spring constants of hip and knee
% correction_hip,knee 	= [rad] geometric property of springs

% Outputs
% max_torque_theta		= [Nm] max torque experienced at hip 
% max_torque_phi		= [Nm] max torque experienced at knee 
% max_thetad			= [rad/s] max angular velocity at hip 
% max_phid				= [rad/s] max angular velocity at knee
% theta 				= [theta] range of thetas over walking cycle
% phi 					= [theta] range of thetas over walking cycle
% thetad, phid 			= [rad/s] range of angular velocities over walking cycle
% thetadd, phidd 		= [rad/s^2] range of angular accelerations over walking cycle
% torque_theta 			= [Nm] range of torques at hip over walking cycle
% torque_phi 			= [Nm] range of torques at knee over walking cycle

% Calculate all torques, angles, and derivatives over the regular walking cycle
function [max_torque_theta,max_torque_phi,max_thetad,max_phid,theta, phi,thetad, phid,thetadd, phidd,torque_theta,torque_phi] = Torques_Angles(leg_Object, force_Object, k_hip,	k_knee,	correction_hip,	correction_knee)
	% Makes use of the dynamic equation from Section 3.2 Dynamic Equation of Analysis Report
	% Calculates the torques and velocities necessary for Power_Consumption to run (first part of Section 3.5.3 Robot Power Consumption of Analysis Report)

	r1 = leg_Object.r1;
	R = leg_Object.R;
	d = leg_Object.d;
	m1 = force_Object.m_foot;
	m2 = force_Object.m_knee;
	N = force_Object.FN;
	f = force_Object.FF;
	x_walking_min = leg_Object.x_walking_min;
	x_walking_max = leg_Object.x_walking_max;
	
	% velocity in x is constant multiple of leg length
	ed = r1*0.5;
    dd =0;
    ddd=0;
    edd=0;
	
	% Simulation properties
    steps = 1000;
    e = linspace(x_walking_min,x_walking_max,steps);
    gear_ratio=100;

    % 3 phases
    torque_theta = zeros(1,steps*3);
    torque_phi = zeros(1,steps*3);
	
	%---------------------------------------%
    %% TORQUES
	%---------------------------------------%
    % Phase 1: leg pulls body forward
    [theta, phi] = leg_angles(r1,R,d,e);
    [thetad, phid] = leg_angles_dot(r1,R,theta,phi,dd,ed);
    [thetadd, phidd] = leg_angles_ddot(r1,R,theta,thetad,phi,phid,ddd,edd);
	% Dynamic equation works in [N] and [m]
    [torque_theta(1:1000),torque_phi(1:1000)] = dynamic_equation(m1,m2,R/1000,r1/1000, theta, phi,thetadd, phidd, N,f,k_hip,k_knee,correction_hip,correction_knee);
    % Phase 2: phi increases
    [torque_theta(1001:2000),torque_phi(1001:2000)] = dynamic_equation(m1,m2,R/1000,r1/1000, theta(1), phi,0, 0, 0,0,k_hip,k_knee,correction_hip,correction_knee);
    % Phase 3: theta decreases
    [torque_theta(2001:3000),torque_phi(2001:3000)] = dynamic_equation(m1,m2,R/1000,r1/1000, theta, phi(steps),0, 0, 0,0,k_hip,k_knee,correction_hip,correction_knee);

    max_torque_theta = max(abs(torque_theta(:)));
    max_torque_phi = max(abs(torque_phi(:)));
    max_thetad = max(abs(thetad));
    max_phid = max(abs(phid));
end