classdef Hip_Base
	properties
		filePath = '..\Solidworks\Equations\HipBase.txt';
		width;								% [mm] width of base
		thickness;							% [mm] thickness of base
		distance_between_hip_bracket_bolts;	% [mm]
		hip_bracket_bolt_to_adapter_bolt;	% [mm]
		bolt_diameter;						% [mm] bolt diameter
		bolt_ell;							% [mm] edge distance of bolt
		hip_plate_to_HD;					% [mm] distance from hip plate to HD output
		L_shaft;							% [mm] distance between hip brackets
		bracket_thickness;					% [mm] thickness of hip bracket
		density = 0.0000027;				% [g/mm^2] approximately: https://www.engineeringclicks.com/6061-t6-aluminum/
		mass;								% [kg] approximately
	end
	
	methods
		
		% Hip Base Constructor
		function obj = Hip_Base(HD_hip,hip_bracket,L_shaft,hip_plate_to_HD)
			obj = obj.setParameters(HD_hip,hip_bracket,L_shaft,hip_plate_to_HD);
		end
		
		% Properties and parameters calculation function
		function obj = setParameters(obj,HD_hip,hip_bracket,L_shaft,hip_plate_to_HD)
			obj.width = HD_hip.spline_outer_diameter;
			obj.thickness = HD_hip.spline_thickness;
			obj.bolt_diameter = hip_bracket.bolt_diameter;
			obj.bolt_ell = hip_bracket.bolt_ell;
			obj.hip_plate_to_HD = hip_plate_to_HD;
			obj.L_shaft = L_shaft;
			obj.bracket_thickness = hip_bracket.thickness;
			obj.distance_between_hip_bracket_bolts = L_shaft - (obj.bolt_diameter+(obj.bolt_ell*2));
			obj.hip_bracket_bolt_to_adapter_bolt = (obj.bolt_diameter/2) + obj.bolt_ell + hip_bracket.thickness + hip_plate_to_HD + HD_hip.thickness - (obj.bolt_ell + (obj.bolt_diameter/2));
			obj.mass = obj.density*(obj.thickness*(obj.distance_between_hip_bracket_bolts+obj.hip_bracket_bolt_to_adapter_bolt+obj.bolt_diameter+(obj.bolt_ell*2)+(obj.bracket_thickness*2)))*obj.thickness;
		end
	
		% Print function to TXT file
		function printTXT(obj,HD_hip)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"shaft length"=',num2str(obj.L_shaft),'\n'));
			fprintf(fid,strcat('"thickness hip plate"=',num2str(obj.bracket_thickness),'\n'));
			fprintf(fid,strcat('"hip plate to HD"=',num2str(obj.hip_plate_to_HD),'\n'));
			fprintf(fid,strcat('"bracket bolt diameter"=',num2str(obj.bolt_diameter),'\n'));
			fprintf(fid,strcat('"bracket ell"=',num2str(obj.bolt_ell),'\n'));
			fprintf(fid,strcat('"adapter width"=',num2str(obj.width),'\n'));
			fprintf(fid,strcat('"adapter thickness"=',num2str(obj.thickness),'\n'));
			fprintf(fid,strcat('"HD thickness"=',num2str(HD_hip.thickness),'\n'));
			fprintf(fid,strcat('"HD spline thickness"=',num2str(HD_hip.spline_thickness),'\n'));
			fprintf(fid,strcat('"from hip bracket bolt to hip bracket bolt"=',num2str(obj.distance_between_hip_bracket_bolts),'\n'));
			fprintf(fid,strcat('"from bracket bolt to adapter bolt"=',num2str(obj.hip_bracket_bolt_to_adapter_bolt),'\n'));
			%fprintf(fid,strcat('""=',num2str(),'\n'));
			fclose(fid);
		end
	end
end