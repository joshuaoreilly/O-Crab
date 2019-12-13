classdef Harmonic_Drive
	properties
		filePath;
		name;						% 'Hip' or 'Knee'
		gear_ratio = 100;			% always
		torque_rated;				% [Nm]
		torque_repeat_limit;		% [Nm]
		speed_avg_input_limit;		% [rpm]
		inertia_I;					% [kgm^2]
		inertia_J;					% [kgfms^2]
		torque_backdriving;			% [Nm]
		torque_starting;			% [Nm]
		mass;						% [kg]
		spline_outer_diameter;		% [mm]
		thickness;					% [mm] (thickness of entire HD)
		spline_thickness;			% [mm]
		spline_mounting_diameter;	% [mm]
		spline_num_bolts;			% [qty]
		spline_bolt_diameter;		% [mm]
		flex_outer_diameter;		% [mm]
		flex_mounting_diameter;		% [mm]
		flex_num_bolts;				% [qty]
		flex_bolt_diameter;			% [mm]
		shaft_diameter;				% [mm]
		key_width;					% [mm]
		key_height;					% [mm]
		key_length;					% [mm]
		% Polyfit functions from generate_hd_functions.m
		T = [0.105039984693498  18.0800657612682;
			1                   8.31777767726056e-15;
			2.0676453497642     12.5829417537992;
			-2.84250955770586   3660.41143310669;
			0.0264563259788898	-0.887074575970917;
			0.026982497617217	-0.904619392487767;
			0.198435069605609	0.650071324047861;
			0.00166096629380689	0.00471147845928719;
			0.00567155506266099	-0.0259402692101916;
			0.350091945307601	63.0494201599388;
			0.0657187501107241	13.104629153926;
			0.0264860948223631	5.45233335577342;
			0.30887865699617	56.2916958683074;
			0.00874277635854066	9.99399786701059;
			0.0107686734010552	3.22755131398525;
			0.267665368684739	49.533971576676;
			0.130782899235738	21.9512477279411;
			0.00610754234976068	9.13055879362087;
			0.0239809837970755	3.74058813108318;
			0.124895919329065	22.7953095492023;
			6.22181530996435e-18	4;
			0.010132585487877	2.83407716319495];
		spline_fasteners;			% spline fastener specs
		flex_fasteners;				% flex fastener specs
	end
	
	methods
		% Constructor
		function obj = Harmonic_Drive(torque_max,hd_name)
			% torque_max [Nm]
			obj = obj.setParameters(torque_max);
			obj.name = hd_name;
			obj.filePath = strcat('..\Solidworks\Equations\HD',hd_name,'.txt');
		end
		
		% Properties and parameters calculation
		function obj = setParameters(obj,torque_max)
			% torque_max [Nm]
			obj.torque_rated = obj.T(2,1)*torque_max + obj.T(2,2);
			obj.torque_repeat_limit = obj.T(3,1)*torque_max + obj.T(3,2);
			obj.speed_avg_input_limit = obj.T(4,1)*torque_max + obj.T(4,2);
			obj.inertia_I = obj.T(5,1)*torque_max + obj.T(5,2);
			obj.inertia_J = obj.T(6,1)*torque_max + obj.T(6,2);
			obj.torque_backdriving = obj.T(7,1)*torque_max + obj.T(7,2);
			obj.torque_starting = obj.T(8,1)*torque_max + obj.T(8,2);
			obj.mass = obj.T(9,1)*torque_max + obj.T(9,2);
			obj.spline_outer_diameter = obj.T(10,1)*torque_max + obj.T(10,2);
			obj.thickness = obj.T(11,1)*torque_max + obj.T(11,2);
			obj.spline_thickness = obj.T(12,1)*torque_max + obj.T(12,2);
			obj.spline_mounting_diameter = obj.T(13,1)*torque_max + obj.T(13,2);
			obj.spline_num_bolts = obj.T(14,1)*torque_max + obj.T(14,2);
			obj.spline_bolt_diameter = obj.T(15,1)*torque_max + obj.T(15,2);
			obj.flex_outer_diameter = obj.T(16,1)*torque_max + obj.T(16,2);
			obj.flex_mounting_diameter = obj.T(17,1)*torque_max + obj.T(17,2);;
			obj.flex_num_bolts = obj.T(18,1)*torque_max + obj.T(18,2);
			obj.flex_bolt_diameter = obj.T(19,1)*torque_max + obj.T(19,2);
			%% Tweak values
			% no negative inertia
			if obj.inertia_I < 0.021
				obj.inertia_I = 0.021;
			end
			% convert from x10^-4 kgm^2 to kgm^2
			obj.inertia_I = obj.inertia_I/(10^4);
			% no negative inertia
			if obj.inertia_J < 0.021
				obj.inertia_J = 0.021;
			end
			% convert from x10^-5 kgfms^2 to kgfms^2
			obj.inertia_J = obj.inertia_J/(10^5);
			% no negative mass
			if obj.mass < 0.06
				obj.mass = 0.06;
			end
			% round number of spline bolts to integer
			obj.spline_num_bolts = ceil(obj.spline_num_bolts);
			% round spline bolt diameter to nearest mm
			obj.spline_bolt_diameter = ceil(obj.spline_bolt_diameter);
			% round number of flex bolts to integer
			obj.flex_num_bolts = ceil(obj.flex_num_bolts);
			% round flex bolts to nearest mm
			obj.flex_bolt_diameter = ceil(obj.flex_bolt_diameter);
			% Values below are approximated from HD website
			obj.shaft_diameter = obj.flex_bolt_diameter*2;
			obj.key_width = obj.flex_bolt_diameter*0.6;
			obj.key_height = obj.flex_bolt_diameter*0.2;
			obj.key_length = obj.spline_thickness;
			obj.spline_fasteners = Fastener(obj.spline_bolt_diameter);
			obj.flex_fasteners = Fastener(obj.flex_bolt_diameter);
		end
		
		% From Analysis Report, Section 3.5.1 Harmonic Drive Efficiency
		function [torque_input,rpm_input] = getInputs(obj,torque_output,rad_s_output)
			%% getInputs
			% INPUTS
			% torque_output = torque at output of HD [Nm]
			% rad_s_output = speed output of HD [rad/s]
			% OUTPUTS
			% rpm_input = rpm at input of HD [rpn]
			% torque_output = torque at input of HD [mNm]
			
			rpm_output = rad_s_output*30./pi;
			rpm_input = rpm_output*obj.gear_ratio;
			
			%% SPEED EFFICIENCY
			% Equation 13
			eta_r = (4.848*(10^(-9)))*(rpm_input.^2) + (-5.879*(10^(-5)))*(rpm_input) + 0.8367;
			if eta_r > 0.81
				eta_r = 0.81;
			elseif eta_r < 0.69
				eta_r = 0.69;
			end
			
			%% TORQUE EFFICIENCY
			% Equations 14, 15
			alpha = torque_output./obj.torque_rated;
			if alpha > 1
				alpha = 1;
			end
			k_e = (-1.481*(alpha.^4))+(4.312*(alpha.^3))-(5.013*(alpha.^2))+(3.159.*alpha)-0.02076;
			if k_e < 0.3
				k_e = 0.3;
			end
			
			%% MOTOR TORQUE
			% Equations 16, 17
			eta_HD = eta_r.*k_e;
			% Input torque in mNm
			torque_input = torque_output.*1000./(obj.gear_ratio.*eta_HD);
		end
		
		% Print function to TXT file
		function printTXT(obj)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"spline outer diameter"=',num2str(obj.spline_outer_diameter),'\n'));
			fprintf(fid,strcat('"thickness total"=',num2str(obj.thickness),'\n'));
			fprintf(fid,strcat('"thickness spline"=',num2str(obj.spline_thickness),'\n'));
			fprintf(fid,strcat('"spline mounting diameter"=',num2str(obj.spline_mounting_diameter),'\n'));
			fprintf(fid,strcat('"spline bolts"=',num2str(obj.spline_num_bolts),'\n'));
			fprintf(fid,strcat('"spline bolt diameter"=',num2str(obj.spline_bolt_diameter),'\n'));
			fprintf(fid,strcat('"flex outer diameter"=',num2str(obj.flex_outer_diameter),'\n'));
			fprintf(fid,strcat('"flex mounting diameter"=',num2str(obj.flex_mounting_diameter),'\n'));
			fprintf(fid,strcat('"flex bolts"=',num2str(obj.flex_num_bolts),'\n'));
			fprintf(fid,strcat('"flex bolt diameter"=',num2str(obj.flex_bolt_diameter),'\n'));
			fprintf(fid,strcat('"input shaft diameter"=',num2str(obj.shaft_diameter),'\n'));	% Approximately
			fprintf(fid,strcat('"key width"=',num2str(obj.key_width),'\n'));				% Approximately
			fprintf(fid,strcat('"key height"=',num2str(obj.key_height),'\n'));				% Approximately
			fclose(fid);
		end
		
	end
end