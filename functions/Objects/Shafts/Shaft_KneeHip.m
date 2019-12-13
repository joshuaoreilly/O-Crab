classdef Shaft_KneeHip
    properties
        D_big						% [mm] Big diameter of shaft
        d_small						% [mm] Small diameter of shaft
        L_bearing					% [mm] Length bearing
        L_mid						% [mm] Leangth of bid diameter
        w_keypulley					% [mm] Width key pulley
        h_keypulley					% [mm] Height key pulley
        w_keyhub					% [mm] Width key hub
        h_keyhub					% [mm] Height key hub
        Plane_keyhub				% [mm] Plane for collar key
		mass						% [Kg] Mass
		worked_keypulley			% Boolean if key length is sufficient for pulley
		worked_keyhub				% Boolean if key length is sufficient for hub
		
        % Constants
        M_sy = 240;					% [MPa] Yield Strength
        density = 8 * (10^(-6));	% [kg/mm^3] Density
		
        %Concentration Factors
        CF_B = [2,1.8,2,1.8];		% Bending
        CF_S = [1.7,1.8,1.7,1.8];	% Shear
        CF_T = [1.7,1.8,1.7,1.8];	% Torsion
    end
    methods
        
		% Shaft Knee Hip Constructor
        function obj = Shaft_KneeHip(F_T1, F_T2, Torque, t_bearing, L1, L3, belt_width)
            obj = obj.setParameters(F_T1, F_T2, Torque, t_bearing, L1, L3, belt_width);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, F_T1, F_T2, Torque, t_bearing, L1, L3, belt_width)
            obj.L_bearing = t_bearing;
            obj.L_mid = belt_width + 10 + 2*L1;
            obj.Plane_keyhub = obj.L_mid/2+obj.L_bearing+20;
            obj = obj.calculate(F_T1, F_T2, Torque, L1, L3, belt_width);
            obj = obj.keys(Torque,belt_width);
            obj.mass = pi*((obj.D_big/2)^2)*(obj.L_mid)*obj.density;
        end
        
		% Parametric Calculation function (Section 4.5.5.3 of Analysis Report)
        function obj = calculate(obj, F_T1, F_T2, Torque, L1, L3, belt_width)
            t_pulley = belt_width+10;
            t_bearing = obj.L_bearing;
            T = Torque/0.95;
            delta_1 =180;
            delta_2 =180;
            
            %% Parametrization Loop
            D =5;
            SafetyFactor = [0,0,0,0];
            while(SafetyFactor(1) < 2.5 || SafetyFactor(2) < 2.5 || SafetyFactor(3)< 2.5 || SafetyFactor(4)< 2.5)
                D = D + 0.5;
                d = D - 4;
                
                %% Joint Forces (Equation 104, 105, 106, 107 in Analysis Report)
                B_y_2 = ((0.5*t_bearing + L1 + 0.5*t_pulley)*(F_T1*sind(delta_1) + F_T2 * sind(delta_2)))/(t_bearing + 2*L1 + t_pulley);
                B_x_2 = -((0.5*t_bearing + L1 + 0.5*t_pulley)*(F_T1*cosd(delta_1) + F_T2 * cosd(delta_2)))/(t_bearing + 2*L1 + t_pulley);
                
                B_x_1 = -F_T1*cosd(delta_1) - F_T2* cosd(delta_2) - B_x_2;
                B_y_1 = F_T1*sind(delta_1) + F_T2* sind(delta_2) - B_y_2;
                
                %% Shear and Moment Graph
                
                %(1) 0, (2) Step1, (3) Pulley, (4) Step 2, (5) Bearing 2, (6) Hub
                Location =  [0, t_bearing/2,                0.5*t_bearing+L1+0.5*t_pulley,                      0.5*t_bearing+L1+0.5*t_pulley+0.5*t_pulley+L1,                     0.5*t_bearing+L1+0.5*t_pulley+0.5*t_pulley+L1+0.5*t_bearing, 0.5*t_bearing+L1+0.5*t_pulley+0.5*t_pulley+L1+0.5*t_bearing + 0.5*t_bearing+L3 ];
                Forces_x =  [0, B_x_1,  B_x_1,              B_x_1+F_T1*cosd(delta_2)+F_T2*cosd(delta_2),        B_x_1+F_T1*cosd(delta_2)+F_T2*cosd(delta_2),                       B_x_1+F_T1*cosd(delta_2)+F_T2*cosd(delta_2)+ B_x_2];
                Forces_y =  [0, -B_y_1,  -B_y_1,            -B_y_1 + F_T1*sind(delta_1) + F_T2*sind(delta_2) ,  -B_y_1 + F_T1*sind(delta_1) + F_T2*sind(delta_2),                  -B_y_1 + F_T1*sind(delta_1) + F_T2*sind(delta_2) - B_y_2];
                Moment_x =  [0, Forces_y(2)*Location(2),    Forces_y(3)*Location(3),                            Forces_y(3)*Location(3)+Forces_y(4)*(Location(4)-Location(3)),     Forces_y(3)*Location(3)+Forces_y(4)*(Location(4)-Location(3))+Forces_y(5)*(Location(5)-Location(4))];
                Moment_y =  [0, Forces_x(2)*Location(2),    Forces_x(3)*Location(3),                            Forces_x(3)*Location(3)+Forces_x(4)*(Location(4)-Location(3)),     Forces_x(3)*Location(3)+Forces_x(4)*(Location(4)-Location(3))+Forces_x(5)*(Location(5)-Location(4))];
                Torsion  =  [0, 0,                          T,                                                  T,                                                                  T];
                
                
                %% Critical Location - Step 1 (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(2)^2+Forces_y(2)^2);
                Total_Moment = sqrt(Moment_x(2)^2+Moment_y(2)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(1))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(1)*Total_Shear/((pi*d^2)/4);
                Torsion_Stress = (16*obj.CF_T(1)*Torsion(2)/(pi*d^3));
                equivalent_Stress = sqrt(Bending_Stress^2+3*Torsion_Stress^2);
                SafetyFactor(1) = obj.M_sy/equivalent_Stress;
				
				
                %% Critical Location - Pulley (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(3)^2+Forces_y(3)^2);
                Total_Moment = sqrt(Moment_x(3)^2+Moment_y(3)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(2))/(pi*D^3);
                Shear_Stress = (4/3)*obj.CF_S(2)*Total_Shear/((pi*D^2)/4);
                Torsion_Stress = (16*obj.CF_T(2)*Torsion(3)/(pi*D^3));
                equivalent_Stress = sqrt(Bending_Stress^2+3*Torsion_Stress^2);
                SafetyFactor(2) = obj.M_sy/equivalent_Stress;
				
				
                %% Critical Location - Step 2 (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(4)^2+Forces_y(4)^2);
                Total_Moment = sqrt(Moment_x(4)^2+Moment_y(4)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(3))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(3)*Total_Shear/((pi*d^2)/4);
                Torsion_Stress = (16*obj.CF_T(3)*Torsion(4)/(pi*d^3));
                equivalent_Stress = sqrt(Bending_Stress^2+3*Torsion_Stress^2);
                SafetyFactor(3) = obj.M_sy/equivalent_Stress;
                
				
                %% Critical Location - Hub (Equation 91 to 96 in Analysis Report)                
                Total_Shear = sqrt(Forces_x(5)^2+Forces_y(5)^2);
                Total_Moment = sqrt(Moment_x(5)^2+Moment_y(5)^2);
                
                Bending_Stress = (32*Total_Moment*obj.CF_B(4))/(pi*d^3);
                Shear_Stress = (4/3)*obj.CF_S(4)*Total_Shear/((pi*d^2)/4);
                Torsion_Stress = (16*obj.CF_T(4)*Torsion(4)/(pi*d^3));
                equivalent_Stress = sqrt(Bending_Stress^2+3*Torsion_Stress^2);
                SafetyFactor(4) = obj.M_sy/equivalent_Stress;
                
            end
            obj.D_big=D;
            obj.d_small=d;
            
        end
		
		% Key calculation function
        function obj = keys(obj,Torque,t_pulley)
            [obj.w_keypulley, h_keypulley,obj.worked_keypulley] = keys(obj.D_big,Torque,t_pulley);
            [obj.w_keyhub, h_keyhub, obj.worked_keyhub] = keys(obj.d_small,Torque, 15);
            obj.h_keypulley = h_keypulley/2;
            obj.h_keyhub = h_keyhub/2;
        end
		
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipKneeShaft.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_big"= ',num2str(obj.D_big),'\n'));
            fprintf(fid,strcat('"d_small"= ',num2str(obj.d_small),'\n'));
            fprintf(fid,strcat('"L_bearing"= ',num2str(obj.L_bearing),'\n'));
            fprintf(fid,strcat('"L_mid"= ',num2str(obj.L_mid),'\n'));
            fprintf(fid,strcat('"w_keypulley"= ',num2str(obj.w_keypulley),'\n'));
            fprintf(fid,strcat('"h_keypulley"= ',num2str(obj.h_keypulley),'\n'));
            fprintf(fid,strcat('"w_keyhub"= ',num2str(obj.w_keyhub),'\n'));
            fprintf(fid,strcat('"h_keyhub"= ',num2str(obj.h_keyhub),'\n'));
            fprintf(fid,strcat('"Plane_keyhub"= ',num2str(obj.Plane_keyhub),'\n'));
            fclose(fid);
        end
        
    end
end