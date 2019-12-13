classdef Leg
    properties
        r1					% [mm] length of thigh
        r2					% [mm] length of upper tibia
        r3					% [mm] length of lower tibia
        R					% [mm] length of simplified tibia
        phi_min				% [deg] Angle between thigh and simplified tibia at x_walking_max
        phi_max				% [deg] Angle between thigh and simplified tibia at x_walking_min
        d					% [mm] Height the thigh motor
        dd					% [m/s] Vertical velocity of the motor
        ed					% [m/s] Horizontal velocity of the robot
        curveAngle			% [deg] Angle of the bend in the tibia
        x_walking_min		% [mm] Minimum distance from robot in x
        x_walking_max		% [mm] Maximum distance from robot in x
        Theta				% [deg] Angle between horizontal and thigh at x_walking_max
        Phi					% [deg] Angle between horizontal and simplified tibia at x_walking_max
        Psy					% [deg] Angle between horizontal and upper tibia at x_walking_max
        Alpha				% [deg]	Angle between horizontal and lower tibia at x_walking_max
        Theta_min			% [deg]	Angle between horizontal and thigh at x_walking_min
        Phi_min				% [deg] Angle between horizontal and simplifed tibia at x_walking_min
        Psy_min				% [deg] Angle between horizontal and upper tibia at x_walking_min
        Alpha_min			% [deg] Angle between horizontal and lower tibia at x_walking_min
        Thetad				% [rad/s] Angular velocity of Theta
        Phid				% [rad/s] Angular velocity of Phi
        Thetadd				% [rad/s] Angular acceleration of Theta
        Phidd				% [rad/s] Angular acceleration of Phi
        h_tibia				% [mm] Vertical distance of tibia
        l_tibia				% [mm] Horizontal distance of tibia
        h_leg				% [mm] Vertical distance of the leg
        l_leg				% [mm] Horizontal distance of the leg
        Phi_relative		% [deg] Phi relative to thigh at x_walking_max
        Psy_relative		% [deg] Psy relative to upper tibia at x_walking_max
        Phi_relative_min	% [deg] Phi relative to thigh at x_walking_min
        Psy_relative_min	% [deg] Psy relative to upper tibia at x_walking_min
        small_psy			% [deg] Angle between Phi and Psy
    end
    methods
        
		% Leg Constructor
        function obj = Leg(x_reach,y_reach)
            obj = obj.setParameters(x_reach,y_reach);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,x_reach,y_reach)
            obj.dd = 0;
            obj.ed = 0.5*x_reach;
            obj.curveAngle = 69;
			
			% Linkage optimization (Section  3.4 of Analysis Report)
            [obj.r1,obj.r2,obj.r3,obj.R,obj.phi_min,obj.phi_max,obj.d,obj.x_walking_min,obj.x_walking_max] = linkages(x_reach,y_reach);
            
			% Geometric Calculation (Section 2.1 of Analysis Dossier)
			[obj.Theta, obj.Phi, obj.Psy, obj.Alpha, obj.small_psy] = Dynamics(obj.r1,obj.r2,obj.r3,obj.x_walking_max,obj.d,obj.curveAngle,obj.R);
            [obj.Theta_min, obj.Phi_min, obj.Psy_min, obj.Alpha_min] = Dynamics(obj.r1,obj.r2,obj.r3,obj.x_walking_min,obj.d,obj.curveAngle,obj.R);
            [obj.Thetad, obj.Phid] = leg_angles_dot(obj.r1,obj.R,obj.Theta,obj.Phi,obj.dd,obj.ed);
            [obj.Thetadd, obj.Phidd] = leg_angles_ddot(obj.r1,obj.R,obj.Theta,obj.Thetad,obj.Phi,obj.Phid,0,0);
            obj.h_tibia= obj.d + obj.r1*sind(obj.Theta);
            obj.l_tibia = obj.x_walking_max-obj.r1*cosd(obj.Theta);
            obj.h_leg = obj.d;
            obj.l_leg = obj.x_walking_max;
            obj.Phi_relative = obj.Phi-obj.Theta;
            obj.Psy_relative = obj.Phi_relative + obj.small_psy;
            obj.Phi_relative_min = obj.Phi_min-obj.Theta_min;
            obj.Psy_relative_min = obj.Phi_relative_min + obj.small_psy;
        end
        
    end
end