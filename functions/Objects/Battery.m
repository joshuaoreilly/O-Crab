classdef Battery
	properties
		filePath = '..\Solidworks\Equations\Battery.txt';
		length;					% [mm]
		height;					% [mm]
		width;					% [mm]
		mass;					% [kg]
		voltage_cell = 3.6;		% [V]
		Ah_cell = 3.4;			% [Ah]
		mass_cell = 0.05;		% [kg]
		height_cell = 65.08;	% [mm]
		diameter_cell = 18.63;	% [mm]
		cells_parallel;
		cells_series;
		cells_total;
		cells_per_battery;
		cells_per_layer;
		running_hours_per_day;	% [h]
		case_width;				% [mm]
		case_length;			% [mm]

	end
	methods
	
		% Constructor
		function obj = Battery(days,active_hours,power_solar,current_consumed)
			obj = obj.setParameters(days,active_hours,power_solar,current_consumed);
		end
		
		% Properties and parameters calculation
		% From Analysis Report, section 3.5 Power Consumption
		function obj = setParameters(obj,days,active_hours,power_solar,current_consumed)
			% motors run at 48 volts
			voltage = 48;
			% Equation 19
			power_consumed = voltage*current_consumed;
			% Equation 21
			obj.running_hours_per_day = power_solar*active_hours/power_consumed;
			% Number of hours of work the battery can hold
			hours_in_battery = obj.running_hours_per_day*days;
			% Equations 22, 23, 24
			obj.cells_series = ceil(voltage/obj.voltage_cell);
			obj.cells_parallel = ceil(current_consumed*hours_in_battery/obj.Ah_cell);
			obj.cells_total = obj.cells_parallel*obj.cells_series;
			obj.mass = obj.cells_total*obj.mass_cell;
			
			% Dimensions of battery packs (geometric, not based on reports)
			% 2 batteries, one on either side of robot
			obj.cells_per_battery = round(obj.cells_total/2,1);
			% 1 layers of cells
			obj.height = obj.height_cell;
			cells_wide = round(sqrt(obj.cells_per_battery));
			obj.width = cells_wide*obj.diameter_cell;
			obj.length = obj.width;
			% dimensions of plates that will sandwich the batteries
			obj.case_width = obj.width + obj.diameter_cell;
			obj.case_length = obj.length + obj.diameter_cell;
		end
		
		% Print function to TXT file
		function printTXT(obj)
			fid = fopen(obj.filePath,'wt');
			fprintf(fid,strcat('"height"=',num2str(obj.height),'\n'));
			fprintf(fid,strcat('"width"=',num2str(obj.width),'\n'));
			fprintf(fid,strcat('"length"=',num2str(obj.length),'\n'));
			fprintf(fid,strcat('"diameter of cell"=',num2str(obj.diameter_cell),'\n'));
			fprintf(fid,strcat('"height of cell"=',num2str(obj.height_cell),'\n'));
			fprintf(fid,strcat('"case width"=',num2str(obj.case_width),'\n'));
			fprintf(fid,strcat('"case_length"=',num2str(obj.case_length),'\n'));
			fclose(fid);
		end
	end
end