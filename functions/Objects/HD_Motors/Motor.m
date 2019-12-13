classdef Motor
	properties
		filePath;
		name;						% 'Hip' or 'Knee'
		torque_nominal;				% [mNm]
		power_nominal;				% [W]
		speed_nominal;				% [RPM]
		current_nominal;			% [A]
		resistance;					% [Ohms]
		torque_const;				% [mNm/A]
		speed_const;				% [RPM/V]
		mass;						% [kg]
		inertia;					% [gcm^2]
		diameter_outer;				% [mm]
		thickness;					% [mm] (exluding shaft diameter)
		mounting_diameter;			% [mm] (always 3)
		bolt_diameter;				% [mm]
		bolt_depth;					% [mm]
		efficiency_max;				% [frac]
		shaft_diameter;				% [mm]
		shaft_length;				% [mm]
		key_width;					% [mm]
		key_height;					% [mm]
		key_length;					% [mm]
		% Polyfit functions from generate_motor_functions.m
		T = [1  -4.47388539068991e-14;
			0.371251182445849	-3.96043280431109;
			-0.890576993210452	3157.56845966845;
			0.00436690058974527	1.12390912813721;
			-0.00636435419784517	7.19743966864434;
			0.146918265140937	19.7946858605065;
			-0.0490022633920436	113.413595477954;
			1.74501207080679e-18	3;
			0.0115249147411334	33.1160654320377;
			0.682852347817259	47.2171719217119;
			3.71306346334785	-278.889925136164;
			0.0474433809398074	35.5646211593142;
			0.00930449005014656	27.1840445766206;
			0.0382290835378379	21.3960316237073;
			0.0020249467122444	2.73644608019762;
			0.00142808192465724	4.25529396274844;
			0.000179149339976652	0.680570335542018];
		fasteners;	% fastener object for mounting
		adapter_thickness;			% [mm] (stored here since it depends on the thickness of the bolt head)
	end
	methods
		
		% Constructor
		function obj = Motor(torque_max,HD,motor_name)
			%% INPUTS
			% torque_max 	= max torque seen by motor [mNm]
			% HD 			= paired harmonic drive
			obj = obj.setParameters(torque_max,HD);
			obj.name = motor_name;
			obj.filePath = strcat('..\Solidworks\Equations\Motor',motor_name,'.txt');
		end
		
		% Properties and parameters calculation
		function obj = setParameters(obj,torque_max,HD)
			obj.torque_nominal = obj.T(1,1)*torque_max + obj.T(1,2);
			obj.power_nominal = obj.T(2,1)*torque_max + obj.T(2,2);
			obj.speed_nominal = obj.T(3,1)*torque_max + obj.T(3,2);
			obj.current_nominal = obj.T(4,1)*torque_max + obj.T(4,2);
			obj.resistance = obj.T(5,1)*torque_max + obj.T(5,2);
			obj.torque_const = obj.T(6,1)*torque_max + obj.T(6,2);
			obj.speed_const = obj.T(7,1)*torque_max + obj.T(7,2);
			obj.mass = obj.T(10,1)*torque_max + obj.T(10,2);
			obj.inertia = obj.T(11,1)*torque_max + obj.T(11,2);
			obj.diameter_outer = obj.T(12,1)*torque_max + obj.T(12,2);
			obj.thickness = obj.T(13,1)*torque_max + obj.T(13,2);
			obj.mounting_diameter = obj.T(14,1)*torque_max + obj.T(14,2);
			obj.bolt_diameter = obj.T(15,1)*torque_max + obj.T(15,2);
			obj.bolt_depth = obj.T(16,1)*torque_max + obj.T(16,2);
			obj.efficiency_max = obj.T(16,1)*torque_max + obj.T(16,2);
			obj.shaft_diameter = HD.shaft_diameter;
			obj.key_width = HD.key_width;
			obj.key_height = HD.key_height;
			obj.key_length = HD.key_length;
			%% Tweak values
			% Make sure Watts is positive (round up to 3W if
			% necessary)
			if obj.power_nominal < 3
				obj.power_nominal = 3;
			end
			% Make sure RPM doesn't round down to 0
			if obj.speed_nominal < 1500
				obj.speed_nominal = 1500;
			end
			% Terminal Resistance
			if obj.resistance < 0.1
				obj.resistance = 0.1;
			end
			% Speed Constant is defined by Maxon as the following:
			obj.speed_const = 30000/(pi*(obj.torque_const));
			% Mass: g -> kg
			obj.mass = obj.mass/1000;
			% Rotor inertia
			if obj.inertia < 3
				obj.inertia = 3;
			end
			% Round screw diameter to closest integer
			obj.bolt_diameter = ceil(obj.bolt_diameter);
			% Make sure maximum efficiency is below 0.9
			if obj.efficiency_max > 0.9
				obj.efficiency_max = 0.9;
			end
			obj.fasteners = Fastener(obj.bolt_diameter);
			% Determined experimentally
			obj.adapter_thickness = max(obj.fasteners.thickness_head*3,HD.spline_thickness);
			obj.shaft_length = obj.adapter_thickness + HD.spline_thickness;
			
			% Cheating: At a certain point, the motor outgrows the harmonic drive and their bolts intefere
			% in order to solve this, we will artificially constrain the motor diameter to that of the harmonic drive
			% (in reality, would need to use a different motor or additional reducer)
			if obj.diameter_outer >  HD.spline_outer_diameter
				obj.diameter_outer = HD.spline_outer_diameter;
				obj.mounting_diameter = obj.diameter_outer/2;	% Lazy way to guesstimate
				
			end
		end
		
		% Analysis Report, Section 3.5.2 Motor Power Consumption
		function current = getPower(obj,torque,rpm)
			%% getPower
			% INPUTS:
			% torque = torque at output of motor [mNm]
			% rpm = speed at output of motor [rpm]
			% OUTPUTS:
			% current into motor [A]
			% Equation 18
			U = (1./obj.speed_const).*(((30000.*obj.resistance.*torque)./(pi.*obj.torque_const.^2))+rpm);
			a = obj.resistance;
			b = -U;
			c = (pi.*rpm.*torque)./(30000);
			I_upper = (-b+sqrt((b.^2)-(4.*a.*c)))./(2.*a);
			I_lower = (-b-sqrt((b.^2)-(4.*a.*c)))./(2.*a);
			% When speed is 0, I_lower = 0
			if I_lower <= 0
				current = I_upper;
			else
				current = I_lower;
			end
		end
		
		% Print function to TXT file
		function printTXT(obj)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"outer diameter"=',num2str(obj.diameter_outer),'\n'));
			fprintf(fid,strcat('"motor thickness"=',num2str(obj.thickness),'\n'));
			fprintf(fid,strcat('"mounting diameter"=',num2str(obj.mounting_diameter),'\n'));
			fprintf(fid,strcat('"screw diameter"=',num2str(obj.bolt_diameter),'\n'));
			fprintf(fid,strcat('"screw depth"=',num2str(obj.bolt_depth),'\n'));
			fprintf(fid,strcat('"shaft length"=',num2str(obj.shaft_length),'\n'));
			fprintf(fid,strcat('"shaft diameter"=',num2str(obj.shaft_diameter),'\n'));	% Approximately
			fprintf(fid,strcat('"key width"=',num2str(obj.key_width),'\n'));			% Approximately
			fprintf(fid,strcat('"key height"=',num2str(obj.key_height),'\n'));			% Approximately
			fprintf(fid,strcat('"key length"=',num2str(obj.key_length),'\n'));			% spline thickness
			fclose(fid);
		end
	
	end
end