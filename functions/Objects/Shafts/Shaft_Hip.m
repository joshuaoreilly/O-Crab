classdef Shaft_Hip
    properties
        D_big							% [mm] Big diameter of shaft
        d_small							% [mm] Small diameter of shaft
        L_mid							% [mm] Length of big diameter portion
        L_bearing						% [mm] Length of bearing
        Plane_keyplates					% [mm] Mid plane of keys for hip plates
        w_keyhub						% [mm] Width key hub
        h_keyhub						% [mm] Height key hub
        w_keyplates						% [mm] Width key plates
        h_keyplates						% [mm] Height key plates
        Plane_keyhub					% [mm] Plane for collar key
		mass							% [kg] Mass
		worked_keyplates				% Boolean if key length is sufficient for plates
		worked_keyhub					% Boolean if key length is sufficient for hub
		
		%Constants
		M_sy = 240;						% [MPa] Yield Strength
		density = 8 * (10^(-6));		% [kg/mm^3] Density
		
		%Concentration Factors
        CF_B = [2,1.8,1.8,2,1.8];		% Bending
        CF_S = [1.7,1.8,1.8,1.7,1.8];	% Shear
        CF_T =[1.7,1.8,1.8,1.7,1.8];	% Torsion
        CF_A =[2.1,1.8,1.8,2.1,1.8];	% Axial
    end
	
    methods
	
		% Shaft Hip Constructor
        function obj = Shaft_Hip(forces,leg, L1, L3, t_plate,t_bearing, l_mid_knee_hip_shaft,w_spring_hip)
            obj = obj.setParameters(forces,leg, L1, L3, t_plate,t_bearing, l_mid_knee_hip_shaft,w_spring_hip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,forces,leg, L1, L3, t_plate,t_bearing,l_mid_knee_hip_shaft,w_spring_hip)
            obj.L_mid = 2*w_spring_hip + 2*10 + l_mid_knee_hip_shaft + 2*2;
            obj.L_bearing = t_bearing;
            obj.Plane_keyplates = (l_mid_knee_hip_shaft+14)/2;
            obj.Plane_keyhub = obj.L_mid/2+t_bearing+20;
            obj = obj.calculate(forces,leg, L1, l_mid_knee_hip_shaft + 2*2, L3, t_plate,t_bearing);
            obj = obj.keys(forces.Torque_hip*1000);
            obj.mass = pi*((obj.D_big/2)^2)*(obj.L_mid)*obj.density;
        end
        
		% Keys Calculation
        function obj = keys(obj,Torque)
            [obj.w_keyplates, h_keyplates, obj.worked_keyplates] = keys(obj.D_big,Torque,10);
            [obj.w_keyhub, h_keyhub, obj.worked_keyhub] = keys(obj.d_small,Torque, 15);
            obj.Plane_keyhub = obj.L_mid/2+obj.L_bearing+20; %5 clearance + 15 hub [mm]
            obj.h_keyplates = h_keyplates/2;
            obj.h_keyhub = h_keyhub/2;
        end

        % Parametric Calculation function (Section 4.5.5.2 of Analysis Report)
        function obj = calculate(obj,forces,leg, L1, L2, L3, t_plate,t_bearing)
            h_leg = leg.h_leg;
            l_leg = leg.l_leg;
            F_thigh = forces.F_thigh;
            f_friction = forces.ff;
            T = forces.Torque_hip*1000;
			
			%% Joint Forces (Equation 98, 99, 100, 101 in Analysis Report)
            B_y_2 = ((t_bearing+2*L1+2*t_plate+L2)*0.5*F_thigh-(f_friction*h_leg))/(t_bearing+2*L1+2*t_plate+L2);
            B_x_2 = -(f_friction*l_leg)/(t_bearing+2*L1+2*t_plate+L2);
            
            B_x_1 = -1*B_x_2;
            B_y_1 = F_thigh-B_y_2;
            
            %% Shear and Moment Graph
            
            %(1) 0, (2) Step1, (3) Hip Plate 1, (4) Hip Plate 2, (5) Step 2, (6)Bearing
            %2 (7) Hub
            Location = [0,  t_bearing/2,    0.5*t_bearing+L1+0.5*t_plate,   0.5*t_bearing+L1+0.5*t_plate + t_plate+L2,   0.5*t_bearing+L1+0.5*t_plate + t_plate+L2+0.5*t_plate+L1,0.5*t_bearing+L1+0.5*t_plate + t_plate+L2+0.5*t_plate+L1+0.5*t_bearing, 0.5*t_bearing+L1+0.5*t_plate + t_plate+L2+0.5*t_plate+L1+0.5*t_bearing+0.5*t_bearing+L3];
            Forces_x = [0,  B_x_1,  B_x_1,  B_x_1,          B_x_1,          B_x_1 + B_x_2];
            Forces_y = [0,  B_y_1, B_y_1 - F_thigh/2,    B_y_1 - F_thigh, B_y_1 - F_thigh,   B_y_1 - F_thigh+ B_y_2];
            Moment_x = [0,  Forces_y(2)*Location(2),  Forces_y(2)*Location(3),  Forces_y(2)*Location(3)-0.5*f_friction*h_leg,      Forces_y(2)*Location(3)-0.5*f_friction*h_leg + Forces_y(3)*(Location(4)-Location(3)),   Forces_y(2)*Location(3)-0.5*f_friction*h_leg+Forces_y(3)*(Location(4)-Location(3))-0.5*f_friction*h_leg,      Forces_y(2)*Location(3)-0.5*f_friction*h_leg+Forces_y(3)*(Location(4)-Location(3))-0.5*f_friction*h_leg + (Location(5)-Location(4))*Forces_y(4), Forces_y(2)*Location(3)-0.5*f_friction*h_leg+Forces_y(3)*(Location(4)-Location(3))-0.5*f_friction*h_leg + (Location(5)-Location(4))*Forces_y(4)+(Location(6)-Location(5))*Forces_y(5)];
            Moment_y = [0,  Forces_x(2)*Location(2),  Forces_x(2)*Location(3),  Forces_x(2)*Location(3)-0.5*f_friction*l_leg,      Forces_x(2)*Location(3)-0.5*f_friction*l_leg + Forces_x(3)*(Location(4)-Location(3)),   Forces_x(2)*Location(3)-0.5*f_friction*l_leg + Forces_x(3)*(Location(4)-Location(3))-0.5*f_friction*l_leg,    Forces_x(2)*Location(3)-0.5*f_friction*l_leg + Forces_x(3)*(Location(4)-Location(3))-0.5*f_friction*l_leg+ (Location(5)-Location(4))*Forces_x(4), Forces_x(2)*Location(3)-0.5*f_friction*l_leg + Forces_x(3)*(Location(4)-Location(3))-0.5*f_friction*l_leg+ (Location(5)-Location(4))*Forces_x(4) + (Location(6)-Location(5))*Forces_x(5)];
            Torsion  = [0,  0,  T*0.5,  T,  T,  T,  0];
            
            %% Parametrization Loop
            SafetyFactor = [0,0,0,0,0];
            D=5;
            while(SafetyFactor(1) < 2.5 || SafetyFactor(2) < 2.5 || SafetyFactor(3)< 2.5 || SafetyFactor(4)< 2.5 || SafetyFactor(5)< 2.5)
                D = D + 0.5;
                d = D - 4;
                
				
                %% Critical Location - Step 1 (Equation 91 to 96, and 102, 103 in Analysis Report)
                Total_Shear = sqrt(Forces_x(2)^2+Forces_y(2)^2);
                Total_Moment = sqrt(Moment_x(2)^2+Moment_y(2)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(1))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(1)*Total_Shear/((pi*d^2)/4);
                Torsion_Stress = (16*obj.CF_T(1)*Torsion(2)/(pi*d^3));
                Axial_Stress = (4*f_friction*obj.CF_A(1))/(pi*d^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Torsion_Stress^2);
                SafetyFactor(1) = obj.M_sy/equivalent_Stress;
				
				
                %% Critical Location - Hip Plate 1 (Equation 91 to 96, and 102, 103 in Analysis Report)
                Total_Shear = sqrt(Forces_x(2)^2+Forces_y(2)^2);
                Total_Moment = sqrt(Moment_x(3)^2+Moment_y(4)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(2))/(pi*D^3);
                Shear_Stress = (4/3)*obj.CF_S(2)*Total_Shear/((pi*D^2)/4);
                Torsion_Stress = (16*obj.CF_T(2)*Torsion(3)/(pi*D^3));
                Axial_Stress = (4*f_friction*obj.CF_A(2))/(pi*D^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Torsion_Stress^2);
                SafetyFactor(2) = obj.M_sy/equivalent_Stress;
				
				
                %% Critical Location - Hip Plate 2 (Equation 91 to 96, and 102, 103 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(3)^2+Forces_y(3)^2);
                Total_Moment = sqrt(Moment_x(5)^2+Moment_y(5)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(3))/(pi*D^3);
                Shear_Stress = (4/3)*obj.CF_S(3)*Total_Shear/((pi*D^2)/4);
                Torsion_Stress = (16*obj.CF_T(3)*Torsion(5)/(pi*D^3));
                Axial_Stress = (4*f_friction*obj.CF_A(3))/(pi*D^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Torsion_Stress^2);
                SafetyFactor(3) = obj.M_sy/equivalent_Stress;
                
				
                %% Critical Location - Step 2 (Equation 91 to 96, and 102, 103 in Analysis Report)
                Total_Shear = sqrt(Forces_x(4)^2+Forces_y(4)^2);
                Total_Moment = sqrt(Moment_x(7)^2+Moment_y(7)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(4))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(4)*Total_Shear/((pi*d^2)/4);
                Torsion_Stress = (16*obj.CF_T(4)*Torsion(6)/(pi*d^3));
                Axial_Stress = (4*f_friction*obj.CF_A(4))/(pi*d^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Torsion_Stress^2);
                SafetyFactor(4) = obj.M_sy/equivalent_Stress;
                
				
                %% Critical Location - Hub (Equation 91 to 96, and 102, 103 in Analysis Report)
                Total_Shear = sqrt(Forces_x(6)^2+Forces_y(6)^2);
                Total_Moment = sqrt(Moment_x(8)^2+Moment_y(8)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(5))/(pi*D^3);
                Shear_Stress = (4/3)*obj.CF_S(5)*Total_Shear/((pi*D^2)/4);
                Torsion_Stress = (16*obj.CF_T(5)*Torsion(6)/(pi*D^3));
                Axial_Stress = (4*f_friction*obj.CF_A(5))/(pi*D^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Torsion_Stress^2);
                SafetyFactor(5) = obj.M_sy/equivalent_Stress;
            end
            obj.D_big = D;
            obj.d_small = d;
        end
        
		
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipShaft.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_big"= ',num2str(obj.D_big),'\n'));
            fprintf(fid,strcat('"d_small"= ',num2str(obj.d_small),'\n'));
            fprintf(fid,strcat('"L_mid"= ',num2str(obj.L_mid),'\n'));
            fprintf(fid,strcat('"L_bearing"= ',num2str(obj.L_bearing),'\n'));
            fprintf(fid,strcat('"Plane_keyplates"= ',num2str(obj.Plane_keyplates),'\n'));
            fprintf(fid,strcat('"w_keyhub"= ',num2str(obj.w_keyhub),'\n'));
            fprintf(fid,strcat('"h_keyhub"= ',num2str(obj.h_keyhub),'\n'));
            fprintf(fid,strcat('"w_keyplates"= ',num2str(obj.w_keyplates),'\n'));
            fprintf(fid,strcat('"h_keyplates"= ',num2str(obj.h_keyplates),'\n'));
            fprintf(fid,strcat('"Plane_keyhub"= ',num2str(obj.Plane_keyhub),'\n'));
            fclose(fid);
        end
        
    end
end