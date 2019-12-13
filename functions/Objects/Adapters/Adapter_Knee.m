classdef Adapter_Knee
	properties
		filePath = '..\Solidworks\Equations\AdapterKnee.txt';
		tube_diameter;			% [mm] diameter of tube surrounding HD	
		mounting_diameter;		% [mm] mounting diameter for adapter on hip plate
		outer_diameter;			% [mm] outer diameter of adapter
		bolt_angle;				% [deg] angle between horizontal and supporting bolts (above and below parallel)
		bolt_diameter;			% [mm] diameter of bolts connecting to hip plates
		hip_plate_to_HD;		% [mm] distance from hip plate to HD flexspline face
		hip_plate_height;		% [mm] height of hip plate
		height_outer_diameter;	% [mm] height of mounting section of adapter
		density = 0.0000027;	% [kg/mm^3] approximately: https://www.engineeringclicks.com/6061-t6-aluminum/
		mass;					% [kg] approximately
	end
	
	methods
		
		% Constructor
		function obj = Adapter_Knee(HD_knee,motor_knee,hip_plate_to_HD,max_diameter_pulley)
			obj = obj.setParameters(HD_knee,motor_knee,hip_plate_to_HD,max_diameter_pulley);
		end
		
		% Properties and parameters calculation
		% Purely geometric, not in reports
		function obj = setParameters(obj,HD_knee,motor_knee,hip_plate_to_HD,max_diameter_pulley)
			obj.hip_plate_height = max_diameter_pulley +4;
			obj.tube_diameter = HD_knee.spline_outer_diameter + (HD_knee.spline_thickness*2);
			obj.mounting_diameter = obj.tube_diameter + ((HD_knee.spline_outer_diameter-HD_knee.spline_mounting_diameter));
			obj.outer_diameter = obj.mounting_diameter + ((HD_knee.spline_outer_diameter-HD_knee.spline_mounting_diameter));
			obj.height_outer_diameter = min(obj.hip_plate_height, obj.tube_diameter);
			obj.bolt_angle = asind((obj.height_outer_diameter/2)/(obj.outer_diameter/2))/2;
			obj.bolt_diameter = HD_knee.spline_bolt_diameter;
			obj.hip_plate_to_HD = hip_plate_to_HD;
			% approximately
			obj.mass = obj.density * ((motor_knee.adapter_thickness*pi*(obj.outer_diameter/2)^2) + ((((obj.outer_diameter-HD_knee.spline_outer_diameter)/2)^2)*pi*obj.hip_plate_to_HD));
		end
	
		% Print function to TXT file
		function printTXT(obj,HD_knee,motor_knee)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"adapter thickness"=',num2str(motor_knee.adapter_thickness),'\n'));
			fprintf(fid,strcat('"spline outer diameter"=',num2str(HD_knee.spline_outer_diameter),'\n'));
			fprintf(fid,strcat('"HD thickness"=',num2str(HD_knee.thickness),'\n'));
			fprintf(fid,strcat('"spline thickness"=',num2str(HD_knee.spline_thickness),'\n'));
			fprintf(fid,strcat('"spline mounting diameter"=',num2str(HD_knee.spline_mounting_diameter),'\n'));
			fprintf(fid,strcat('"spline bolt quantity"=',num2str(HD_knee.spline_num_bolts),'\n'));
			fprintf(fid,strcat('"spline bolts diameter"=',num2str(HD_knee.spline_bolt_diameter),'\n'));
			fprintf(fid,strcat('"motor shaft diameter"=',num2str(HD_knee.shaft_diameter),'\n'));
			fprintf(fid,strcat('"motor mounting diameter"=',num2str(motor_knee.mounting_diameter),'\n'));
			fprintf(fid,strcat('"motor bolt quantity"=',num2str(3),'\n'));			% always 3 bolts
			fprintf(fid,strcat('"motor bolt diameter"=',num2str(motor_knee.bolt_diameter),'\n'));
			fprintf(fid,strcat('"from hd output to hip plate"=',num2str(obj.hip_plate_to_HD),'\n'));
			fprintf(fid,strcat('"hip plate height"=',num2str(obj.hip_plate_height),'\n'));
			fprintf(fid,strcat('"adapter tube diameter"=',num2str(obj.tube_diameter),'\n'));
			fprintf(fid,strcat('"adapter mounting diameter"=',num2str(obj.mounting_diameter),'\n'));
			fprintf(fid,strcat('"adapter outer diameter"=',num2str(obj.outer_diameter),'\n'));
			fprintf(fid,strcat('"adapter secondary bolt angle"=',num2str(obj.bolt_angle),'\n'));
			fprintf(fid,strcat('"height of outer diameter"=',num2str(obj.height_outer_diameter),'\n'));
			%fprintf(fid,strcat('""=',num2str(),'\n'));
			fclose(fid);
		end
	
	end
end