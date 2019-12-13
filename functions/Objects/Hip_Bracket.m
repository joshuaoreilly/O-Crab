classdef Hip_Bracket
	properties
		filePath = '..\Solidworks\Equations\HipBracket.txt';
		thickness;						% [mm]
		height;							% [mm] from center of shaft to base
		bracket_width;					% [mm] equal to outer diameter of HD
		bolt_diameter;					% [mm]
		bolt_ell;						% [mm] from bolt edge to bracket edge
		bushing_diameter;				% [mm]
		spline_thickness;				% [mm] harmonic drive spline thickness
		distance_between_drives;		% [mm] from edge of hip HD to edge of knee HD adapter
		distance_between_shafts;		% [mm] from center of knee shaft to center of hip shaft
		density = 0.0000027;			% [kg/mm^3] approximately: https://www.engineeringclicks.com/6061-t6-aluminum/
		mass;							% [kg] approximate mass
	end
	
	methods
		% Hip Bracket Constructor
		function obj = Hip_Bracket(HD_hip,adapter_knee,leg,shaft_length,bushing_diameter,pulley_diameter,Fx,Fy,Fz)
			obj = obj.setParameters(HD_hip,adapter_knee,leg,shaft_length,bushing_diameter,pulley_diameter,Fx,Fy,Fz);
		end
		
		% Properties and parameters calculation function
		function obj = setParameters(obj,HD_hip,adapter_knee,leg,shaft_length,bushing_diameter,pulley_diameter,Fx,Fy,Fz)
			%% INPUTS
			% HD_hip			= hip harmonic drive object
			% adapter_knee		= knee adapter object
			% shaft_length 		= length of shaft between hip brackets [mm]
			% bushing_diameter 	= outer diameter of bushing [mm]
			% pulley_diameter 	= outer diameter of pulley [mm]
			% Fx, Fy, Fz 		= forces along fastener x (friction), y (friction) and z axes (normal) [N]
			
			% maximum hip angle
			theta_max = deg2rad(28);
			% alpha	= distance between edge of knee adapter and hip bracket (so they don't interfere when at 28 degrees)
			alpha = ceil((adapter_knee.outer_diameter/2)*((1/cos(theta_max))-1));
			beta = alpha;
			obj.distance_between_drives = alpha;
			obj.distance_between_shafts = HD_hip.spline_outer_diameter/2 + adapter_knee.outer_diameter/2 + alpha;
			plate_L_end = (adapter_knee.outer_diameter/2 + 5);
			plate_height = pulley_diameter+4;
			% bracket needs to be tall enough so that hip plates and knee adapters don't touch chassis
			% three cases: either hip plate is taller than adapter_knee, hip plate is less tall but
			% is closer to ground at 28degrees, and hip plate is smaller and adapter_knee closer to 
			% ground at 28degrees
			if (plate_height > adapter_knee.outer_diameter)
				max_diameter = plate_height;
				obj.height = obj.distance_between_shafts*sin(theta_max) + max_diameter/2 + (plate_L_end*sin(theta_max)) - ((max_diameter/2)*(1-cos(theta_max)));
			else
				if (((plate_L_end)*sin(theta_max)+(plate_height/2)*cos(theta_max)) > (adapter_knee.tube_diameter/2))
					% if vertical projection of hip plate is higher than radius of knee adapter
					obj.height = obj.distance_between_shafts*sin(theta_max) + ((plate_L_end)*sin(theta_max)+(plate_height/2)*cos(theta_max));
				else
					% if radius of knee adapter is higher than vertical projection of hip plate
					obj.height = obj.distance_between_shafts*sin(theta_max) + adapter_knee.tube_diameter/2;
				end
			end
			obj.bracket_width = HD_hip.spline_outer_diameter;
			% Same thickness as the bushings
			obj.thickness = 10;
			
			% Get dimensions of bolts that fasten to chassis
			[d_bolt,ell] = fasteners_hip(leg.r1,leg.R,obj.thickness,obj.height,obj.bracket_width,shaft_length,Fx,Fy,Fz);
			obj.bolt_diameter = d_bolt;
			obj.bolt_ell = ell;
			
			obj.bushing_diameter = bushing_diameter;
			obj.spline_thickness = HD_hip.spline_thickness;
			
			% mass of mounting and adapter section + mass of section that attaches to hip base (approximately)
			obj.mass = obj.density*((obj.height+HD_hip.spline_outer_diameter/2) + (obj.bolt_diameter+obj.bolt_ell*2))*HD_hip.spline_outer_diameter*obj.thickness;
		end
	
		% Print function to TXT file
		function printTXT(obj)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"bracket height"=',num2str(obj.height),'\n'));
			fprintf(fid,strcat('"bracket width"=',num2str(obj.bracket_width),'\n'));
			fprintf(fid,strcat('"bracket thickness"=',num2str(obj.thickness),'\n'));
			fprintf(fid,strcat('"bushing diameter"=',num2str(obj.bushing_diameter),'\n'));
			fprintf(fid,strcat('"ell"=',num2str(obj.bolt_ell),'\n'));
			fprintf(fid,strcat('"hip bolt diameter"=',num2str(obj.bolt_diameter),'\n'));
			fprintf(fid,strcat('"adapter thickness"=',num2str(obj.spline_thickness),'\n'));
			fclose(fid);
		end
	end
end