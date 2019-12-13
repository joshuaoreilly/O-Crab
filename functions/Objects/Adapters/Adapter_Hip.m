classdef Adapter_Hip
	properties
		filePath = '..\Solidworks\Equations\AdapterHip.txt';
		width;					% [mm] equal to outer diameter of HD 
		thickness;				% [mm] thickness between HD and motor
		mount_thickness;		% [mm] thickness of section that connects adapter to base
		height;					% [mm] height from base to center of motor shaft
		bracket_bolt_diameter;	% [mm] bolt diameter of brackets holding up leg
		bracket_ell;			% [mm] distance from bolt edge to plate edge of brackets holding up leg
		density = 0.0000027;	% [kg/mm^3] approximately: https://www.engineeringclicks.com/6061-t6-aluminum/
		mass;					% [kg] approximately
	end
	
	methods
		
		% Constructor
		function obj = Adapter_Hip(HD_hip,motor_hip,hip_bracket)
			obj = obj.setParameters(HD_hip,motor_hip,hip_bracket);
		end
		
		% Properties and parameters calculation
		% Purely geometric, not in reports
		function obj = setParameters(obj,HD_hip,motor_hip,hip_bracket)
			obj.width = HD_hip.spline_outer_diameter;
			obj.mount_thickness = HD_hip.spline_thickness;
			obj.thickness = motor_hip.adapter_thickness;
			obj.height = hip_bracket.height;
			obj.bracket_bolt_diameter = hip_bracket.bolt_diameter;
			obj.bracket_ell = hip_bracket.bolt_ell;
			% approximately
			obj.mass = obj.density*((obj.height+(HD_hip.spline_outer_diameter/2)) + (obj.bracket_bolt_diameter+(obj.bracket_ell)))*obj.thickness*HD_hip.spline_outer_diameter;
		end
	
		% Print function to TXT file
		function printTXT(obj,HD_hip,motor_hip)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"bracket height"=',num2str(obj.height),'\n'));
			fprintf(fid,strcat('"bracket width"=',num2str(obj.width),'\n'));
			fprintf(fid,strcat('"bracket thickness"=',num2str(obj.mount_thickness),'\n'));
			fprintf(fid,strcat('"adapter thickness"=',num2str(obj.thickness),'\n'));
			fprintf(fid,strcat('"spline mounting diameter"=',num2str(HD_hip.spline_mounting_diameter),'\n'));
			fprintf(fid,strcat('"spline bolt quantity"=',num2str(HD_hip.spline_num_bolts),'\n'));
			fprintf(fid,strcat('"spline bolts diameter"=',num2str(HD_hip.spline_bolt_diameter),'\n'));
			fprintf(fid,strcat('"motor shaft diameter"=',num2str(motor_hip.shaft_diameter),'\n'));
			fprintf(fid,strcat('"motor mounting diameter"=',num2str(motor_hip.mounting_diameter),'\n'));
			fprintf(fid,strcat('"motor bolt quantity"=',num2str(3),'\n'));			% always 3 bolts
			fprintf(fid,strcat('"motor bolt diameter"=',num2str(motor_hip.bolt_diameter),'\n'));
			fprintf(fid,strcat('"bracket bolt diameter"=',num2str(obj.bracket_bolt_diameter),'\n'));
			fprintf(fid,strcat('"bracket bolt ell"=',num2str(obj.bracket_ell),'\n'));
			%fprintf(fid,strcat('""=',num2str(),'\n'));
			fclose(fid);
		end
	
	end
end