classdef Fastener
	properties
		diameter;					% [mm]
		thickness_head;				% [mm]
		diameter_head;				% [mm]
		thickness_nut;				% [mm]
		diameter_nut;				% [mm]
		thickness_washer;			% [mm]
		od_washer;					% [mm] (outer diameter)
		id_washer;					% [mm] (inner diameter)
	end
	methods
	
		function obj = Fastener(diameter)
			% M4, M5, etc. [mm]
			obj = obj.setParameters(diameter);
		end
		
		function obj = setParameters(obj,diameter)
			% Functions extracted using polyfit(x,y,1)
			% Bolt dimensions taken from McMaster Grade 8.8 metric bolts
			% Nuts dimensions following ISO 4032, taken from: https://www.amesweb.info/Fasteners/Nut/Metric-Hex-Nut-Sizes-Dimensions-Chart.aspx
	
			obj.diameter = diameter;
			obj.thickness_head = 0.60433*diameter + 0.39;
			obj.diameter_head = 1.5617*diameter + 0.5761;
			obj.thickness_nut = 0.8584*diameter - 0.0455;
			obj.diameter_nut = 1.5045*diameter + 0.9042;
			obj.thickness_washer = 0.2254*diameter - 0.1096;
			obj.od_washer = 1.8473*diameter + 1.2575;
			%id_washer = 1.038*diameter + 0.1222; We'll simplify by just using diameter
			obj.id_washer = diameter;
		end
		
		function printTXT()
			fprintf('This isn''t implemented yet');
		end
	
	end
end