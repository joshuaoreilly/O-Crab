classdef Shaft_Knee
    properties
        D_big						% [mm] Big diameter of shaft
        d_small						% [mm] Small diameter of shaft
        L_mid						% [mm] Length of big diameter portion
        L_bearing					% [mm] Length of bearing
        L_total_knee_shaft			% [mm] Length of knee shaft
        L							% [mm] Distance of torsion spring and spring plate
        mass						% [kg] Mass
		
		%Constants
		M_sy = 240;					% [MPa] Yield strength
        density = 8 * (10^(-6));	% [kg/mm^3] Density
		
        %Concentration Factors
        CF_B = [1.9,1,1.9];			% Bending
        CF_S = [1.6,1,1.6];			% Shear
        CF_A =[2,1,2];				% Axial
    end
    methods
        
		%Shaft Knee Constructor
        function obj = Shaft_Knee(forces,leg, F_t1, F_t2,torsion_spring_length,t_pulley, l_mid_HipKneeShaft,t_bearing)
           obj = obj.setParameters(forces,leg, F_t1, F_t2,torsion_spring_length,t_pulley, l_mid_HipKneeShaft,t_bearing);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,forces,leg, F_t1, F_t2,torsion_spring_length,t_pulley, l_mid_HipKneeShaft,t_bearing )
            obj.L_mid = l_mid_HipKneeShaft;
            obj.L_total_knee_shaft = obj.L_mid + 2*t_bearing; 
            obj.L = torsion_spring_length +5;
            obj.L_bearing = t_bearing;
            obj = obj.calculate(forces,leg,F_t1, F_t2, t_pulley,t_bearing);
            obj.mass = pi*((obj.D_big/2)^2)*(obj.L_mid)*obj.density;

        end
         

		% Parametric Calculation function (Section 4.5.5.1 of Analysis Report)
        function obj = calculate(obj,forces,leg, F_t1, F_t2,t_pulley, t_bearing)
           
            F_tibia = forces.F_tibia;
            f_friction = forces.ff;
            theta = leg.Theta +90;
            L=obj.L;
            D =5;
            delta_1 =0;
            delta_2 =0;
            SafetyFactor = [0,0,0];
            h_tibia=leg.h_tibia;
            l_tibia =leg.l_tibia;
			
            while(SafetyFactor(1) < 2.5 || SafetyFactor(2) < 2.5 || SafetyFactor(3)< 2.5)
                D = D + 0.5;
                d = D - 4;
                
                %% Joint Forces (Equation 87, 88, 89, 90 in Analysis Report)
                B_y_2 = ((0.5*t_bearing + L + 0.5*t_pulley)*(F_tibia*sind(theta) + F_t1 * sind(delta_1) + F_t2 * sind(delta_2))-(f_friction*h_tibia*cosd(theta-90))+(f_friction*l_tibia * cosd(theta)))/(t_bearing + 2*L+t_pulley);
                B_x_2 = ((0.5*t_bearing + L + 0.5*t_pulley)*(F_tibia*cosd(theta) + F_t1 * cosd(delta_1) + F_t2 * cosd(delta_2))-(f_friction*h_tibia*sind(theta-90))-(f_friction*l_tibia * sind(theta)))/(t_bearing + 2*L+t_pulley);
                
                B_x_1 = F_tibia*cosd(theta) + F_t1* cosd(delta_1) + F_t2*cosd(delta_2) - B_x_2;
                B_y_1 = F_tibia*sind(theta) + F_t1* sind(delta_1) + F_t2*sind(delta_2) - B_y_2;
                
                %% Shear and Moment Graph
                
                %(1) 0, (2) Step1, (3) Pulley, (4) Step 2, (5) Bearing 2
                Location =[0,   t_bearing/2,    0.5*t_bearing+L+0.5*t_pulley,   t_bearing+2*L+t_pulley-0.5*t_bearing,   t_bearing+2*L+t_pulley];
                Forces_x = [0,    B_x_1,  B_x_1,  B_x_1-(F_t1*cosd(delta_1)+F_t2*cosd(delta_2)+F_tibia*cosd(theta)),          B_x_1-(F_t1*cosd(delta_1)+F_t2*cosd(delta_2)+F_tibia*cosd(theta)),          B_x_1-(F_t1*cosd(delta_1)+F_t2*cosd(delta_2)+F_tibia*cosd(theta))+ B_x_2];
                Forces_y = [0,    B_y_1,  B_y_1,  B_y_1 - (F_t1*sind(delta_1) + F_t2*sind(delta_2) + F_tibia*sind(theta)),    B_y_1 - (F_t1*sind(delta_1) + F_t2*sind(delta_2) + F_tibia*sind(theta)),    B_y_1 - (F_t1*sind(delta_1) + F_t2*sind(delta_2) + F_tibia*sind(theta)) + B_y_2];
                Moment_x =[0,    Forces_y(2)*Location(2),  Forces_y(3)*Location(3),  Forces_y(3)*Location(3)-f_friction*h_tibia*cosd(theta-90) + f_friction*l_tibia*cosd(theta),   (Forces_y(3)*Location(3)-f_friction*h_tibia*cosd(theta-90) + f_friction*l_tibia*cosd(theta)) + (Location(4) - Location(3))*Forces_y(5)];
                Moment_y =[0,    Forces_x(2)*Location(2),  Forces_x(3)*Location(3),  Forces_x(3)*Location(3)-f_friction*h_tibia*sind(theta-90) - f_friction*l_tibia*sind(theta),   (Forces_x(3)*Location(3)-f_friction*h_tibia*sind(theta-90) - f_friction*l_tibia*sind(theta)) + (Location(4) - Location(3))*Forces_x(5)];

                
                %% Critical Location - Step 1 (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(2)^2+Forces_y(2)^2);
                Total_Moment = sqrt(Moment_x(2)^2+Moment_y(2)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(1))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(1)*Total_Shear/((pi*d^2)/4);
                Axial_Stress = (4*f_friction*obj.CF_A(1))/(pi*d^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Shear_Stress^2);
                SafetyFactor(1) = obj.M_sy/equivalent_Stress;
				
				
                %% Critical Location - Pulley (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(3)^2+Forces_y(3)^2);
                Total_Moment = sqrt(Moment_x(3)^2+Moment_y(3)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(2))/(pi*D^3);
                Shear_Stress = (4/3)*obj.CF_S(2)*Total_Shear/((pi*D^2)/4);
                Axial_Stress = (4*f_friction*obj.CF_A(2))/(pi*D^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Shear_Stress^2);
                SafetyFactor(2) = obj.M_sy/equivalent_Stress;
				
				
                %% Critical Location - Step 2 (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(5)^2+Forces_y(5)^2);
                Total_Moment = sqrt(Moment_x(5)^2+Moment_y(5)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(3))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(3)*Total_Shear/((pi*d^2)/4);
                Axial_Stress = (4*f_friction*obj.CF_A(3))/(pi*d^2);
                equivalent_Stress = sqrt((Bending_Stress + Axial_Stress)^2+3*Shear_Stress^2);
                SafetyFactor(3) = obj.M_sy/equivalent_Stress;
                
                
            end
            obj.D_big =D;
            obj.d_small=d;

        end
		
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\KneeShaft.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_big"= ',num2str(obj.D_big),'\n'));
            fprintf(fid,strcat('"d_small"= ',num2str(obj.d_small),'\n'));
            fprintf(fid,strcat('"L_mid"= ',num2str(obj.L_mid),'\n'));
            fprintf(fid,strcat('"L_bearing"= ',num2str(obj.L_bearing),'\n'));
            fclose(fid);
        end
        
    end
end