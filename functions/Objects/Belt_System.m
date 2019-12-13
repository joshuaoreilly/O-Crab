classdef Belt_System
    properties
        Pulley_Belt_Total_Dia	% [mm] Pulley Belt Total Diameter
        Pulley_Inner_Dia		% [mm] Pulley Inner Diameter
        b_width					% [mm] Belt Width
        T_tight					% [N] Tight Tension
        T_slack					% [N] Slack Tension
        pulley_pitch_dia		% [mm] Pulley Pitch Diameter
        Belt_Length				% [mm] Belt Length
        M_k						% [Nmm] Torque at knee
        b_pitch					% [mm] Belt Pitch
        C						% [mm] Distance center to center of pulleys
        
    end
    methods
        
		% Belt System Constructor
        function obj = Belt_System(M_k)
            obj = obj.setParameters(M_k);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,M_k)
            obj = obj.calculate(M_k);
        end
		
		% Parametric Calculation function (Section 4.3 of Analysis Report)
        function obj = calculate(obj,M_k)
            eta_belt = 0.95;        %Belt drive efficiency
            M_h = M_k/eta_belt;
            
            %% Belt Specifications
            b_width = 25; % mm
            b_pitch = 8;  % 5mm or 8mm
            b_material = 1; % 1:Steel ; 2:Kevlar
            b_pitch_diff = 0.7;
            
			% Belt Specification based on pitch and material of belt
            if b_pitch == 5
                Te_allow = 1020/25*b_width;
                min_n_teeth = 14;
                b_thick = 3.6;
                b_tooth_height = 2.1;
                if b_material == 1
                    T_max = 2340/25*b_width;
                elseif b_material == 2
                    T_max = 1170/25*b_width;
                end
            elseif b_pitch == 8
                Te_allow = 1870/25*b_width;
                min_n_teeth = 20;
                b_thick = 5.6;
                b_tooth_height = 3.4;
                if b_material == 1
                    T_max = 3741/25*b_width;
                elseif b_material == 2
                    T_max = 1870/25*b_width;
                end
            end
			
            %% Starting values
            pulley_pitch_dia = b_pitch*min_n_teeth/pi;
            T_effective = 2*M_h/pulley_pitch_dia;
            T_slack = 0.3*T_effective;
            T_tight = T_effective+T_slack;
            T_total = T_tight + T_slack;
            
            %% Loop until maximum belt tension and allowable effective tension conditions are met
            n_teeth = min_n_teeth;
            
            while (T_effective >= Te_allow || T_tight >= T_max)
                n_teeth = n_teeth + 1;
                pulley_pitch_dia = b_pitch*n_teeth/pi;
                T_effective = 2*M_h/pulley_pitch_dia;
                T_slack = 0.3*T_effective;
                T_tight = T_effective+T_slack;
                T_total = T_tight + T_slack;
            end
            
            %% Overall pulley and belt dimensions            
            Pulley_Belt_Total_Dia = pulley_pitch_dia + 2*(-b_pitch_diff + b_thick - b_tooth_height);          
            Pulley_Inner_Dia = pulley_pitch_dia - 2*b_pitch_diff - 2*b_tooth_height;
            Max_linear_displ = pulley_pitch_dia/2*deg2rad(45);
            obj.Pulley_Belt_Total_Dia = Pulley_Belt_Total_Dia;
            obj.Pulley_Inner_Dia = Pulley_Inner_Dia;
            obj.b_width = b_width;
            obj.T_tight = T_tight;
            obj.T_slack = T_slack;
            obj.pulley_pitch_dia = pulley_pitch_dia;
            obj.M_k = M_k;
            obj.b_pitch = b_pitch;
        end
        
		% Set Belt Dimensions Function
		% Parameters:
		% L_thigh 	[mm] Length of thigh
		% L_motor	[mm] Distance between both motors shaft
        function obj = setBeltDimensions(obj, L_thigh,L_motor)
            obj.C = L_thigh + L_motor;  %Center-to-center dimension
            obj.Belt_Length = pi*obj.pulley_pitch_dia + 2*obj.C;
            b_n_teeth = obj.Belt_Length/obj.b_pitch;
        end
        
    end
end