classdef TibiaTube
    properties
        D						% [mm] Outer Diameter of the tube 
        d						% [mm] Inner Diameter of the tube
        sy = 250;				% [MPa] Yield Strength
        density = 2.7/(10^6); 	% [kg/mm^3] density of aluminum
        height					% [mm] Height between ground and r2
        r2_partial				% [mm] Distance of upper tibia before press fit
        r_bend					% [mm] Radius of bend
        r3_minusfoot			% [mm] Length of lower tibia witout foot
        m2						% [kg] mass of upper tibia
        m3						% [kg] mass of lower tibia
    end	
    methods
        
		% Tibia Tube Constructor
        function obj = TibiaTube(forces, leg, D_pulley)
            obj = obj.calculate(forces,leg ,D_pulley);
        end
        
        % Parametric Calculation function (Section 4.2 of Analysis Report)
        function obj = calculate(obj,forces, leg,D_pulley)
		
			% Variable Assignment
            obj.height = leg.r3*sind(leg.curveAngle);
            precision =0.5; % Precision of loop
            obj.D = 4 - precision; % Starting outter diameter
            n=0; % Starting safety factor
            phi = leg.Psy;
            FN = forces.FN;
            FF = forces.FF;
            ff = forces.ff;
            theta = 360-leg.Alpha;
            r2 = leg.r2;
            r3 = leg.r3;
			
			%% Determines optimal outter diameter with constant thickness for a safety factor of 2
            while(n<=2)
			
				%% Geometric Calculation
                obj.D=obj.D+precision;
                obj.d = obj.D - 3.175;
                A = pi/4 * (obj.D^2-obj.d^2);
                I = pi/64*(obj.D^4-obj.d^4);
                m2 = A*r2*obj.density;
                m3 = A*r3*obj.density;
                obj.m2 = m2;
                obj.m3 = m3;
				
                %% Joint Forces (Section 4.2.6 of Analysis Report, equation : 25, 26, 31, 32)
                B = [FF,FN-9.81*m3];
                Bm = FN*r3*cosd(theta)-FF*r3*sind(theta)-m3*9.81*r3/2*cosd(theta);
                Cm = B(1)*sind(phi)*r2 + B(2)*cosd(phi)*r2+Bm-m2*9.81*r2/2*cosd(phi);
                
                %% Internal Forces  (Section 4.2.6 of Analysis Report, equation : 36, 37, 41)
                Axial = -B(1)*cosd(phi)+B(2)*sind(phi)-m2*9.81*sind(phi);
                Radial = sqrt((B(1)*sind(phi)+B(2)*cosd(phi)-9.81*m2*cosd(phi))^2+ ff^2);
                Bending = sqrt((Cm)^2 + (ff*(r3+r2))^2);
                
                %% Internal Stresses (Section 4.2.6 of Analysis Report, equation : 42, 43, 44, 45, 46, 47)
                r_avg = obj.D/4+obj.d/4;
                Px = Axial/A;
                sigma_x = Px + Bending*obj.D/(2*I);
                Shear = Radial*2/A;
                Torsion = ((sqrt(leg.x_walking_max^2+obj.height^2 -r2^2))*ff)/(2*pi*r_avg^2*(obj.D-obj.d)/2);
                tau_xy = Shear + Torsion;
                e_equivalent = (sigma_x^2+3*tau_xy^2)^(1/2);
                n = obj.sy/e_equivalent;
            end
			%% Geometric Calculation Bend
            obj.r2_partial = r2 - 3 - (0.5*D_pulley+5);
            obj.r_bend = (obj.r2_partial-17)*tand(leg.curveAngle/2);
            obj.r3_minusfoot = r3-100;
        end
       
	   % Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\TibiaTube.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_i"= ',num2str(obj.d),'\n'));
            fprintf(fid,strcat('"d_o"= ',num2str(obj.D),'\n'));
            fprintf(fid,strcat('"r_bend"= ',num2str(obj.r_bend),'\n'));
            fprintf(fid,strcat('"r2_partial"= ',num2str(obj.r2_partial),'\n'));
            fprintf(fid,strcat('"r3_minusfoot"= ',num2str(obj.r3_minusfoot),'\n'));
            fclose(fid);
        end
        
    end
end