classdef Forces
    properties
        FN					% [N] Normal Force
        ff					% [N] Friction force in x direction
        FF					% [N] Friction force in y direction
        Torque_hip			% [Nm] Torque at hip maximum
        Torque_hipKnee		% [Nm] Torque at Hip Knee maximum
        Torque_hip_min		% [Nm] Torque at Hip minimum
        Torque_hipKnee_min	% [Nm] Torque at Hip Knee minimum
        F_tibia				% [N] Forces at the Tibia
        F_thigh				% [N] Forces at the thigh
        m_foot = 0.25;		% [Kg] Weight of the foot piece
        m_knee = 0.5;		% [Kg] Weight of the knee piece
    end
    methods
        
		% Forces Constructor
        function obj = Forces(W, leg)
           obj = obj.setParameters(W,leg);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,W,leg)
            %% Normal Force (Section 3.1.1 of Analysis Report)
            CG = [-559+1062 , -400.02+800, 209.98];
            P1 = [-1062+1062,200,0];
            P2 = [0+1062,800,0];
            P3 = [0+1062,400,0];
            [N1,N2,N3] = forces(P2,P3,P1,CG,W,20);
            obj.FN = max(abs([N1,N2,N3]));
            
            %% Friction Force (Section 3.1.2 of Analysis Report)
            CG = [596 , 400.04, 209.13];
            P1 = [1136,200,0];
            P2 = [0,800,0];
            P3 = [0,400,0];
            [N1,N2] = friction_Forces(P1,P2,P3,CG,W,20);
            obj.ff = max(abs([N1,N2]));
            obj.FF = 10.6;
			
            %% Torques (Section 3.2 of Analysis Report)
            [obj.Torque_hip,obj.Torque_hipKnee] = dynamic_equation(obj.m_foot,obj.m_knee,leg.R/1000,leg.r1/1000,leg.Theta,leg.Phi,leg.Thetadd,leg.Phidd,obj.FN,obj.FF,0,0,0,0);
            [obj.Torque_hip_min,obj.Torque_hipKnee_min] = dynamic_equation(obj.m_foot,obj.m_knee,leg.R/1000,leg.r1/1000,leg.Theta_min,leg.Phi_min,leg.Thetadd,leg.Phidd,obj.FN,obj.FF,0,0,0,0);
            
			%% Shaft Forces 
			% Section 4.5.5 of Analysis Report
            obj.F_tibia = obj.FN-9.81*obj.m_foot; % Eq. 86
            obj.F_thigh = obj.F_tibia-9.81*obj.m_knee; % Eq. 97
        end
        
        function printTXT(obj)

        end
        
    end
end