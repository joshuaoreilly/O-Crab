classdef Pulley_Exterior
    properties
        D_p			% [mm] Pitch Diameter
        d_i			% [mm] Hub Diameter
        W_p			% [mm] Width of the pulley
        d_bolts		% [mm] Diameter Bolt
        L_bolts		% [mm] Bolt Radius Location
    end
    methods
        
		% Pulley Exterior Constructor
        function obj = Pulley_Exterior( belt_System,D_knee_shaft)
            obj = obj.setParameters( belt_System,D_knee_shaft);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, belt_System,D_knee_shaft)
            obj.D_p =  belt_System.pulley_pitch_dia;
            obj.d_i = D_knee_shaft;
            obj.W_p = belt_System.b_width;
        end
        
		% Set bolt method
		% Parameters
		% TibiPulleyHolder Object
        function obj = setBolts(obj, tibiaPullerHolder)
            obj.d_bolts = tibiaPullerHolder.d_bolts;
            obj.L_bolts = tibiaPullerHolder.L_bolts;
        end

        % Set Pulley Diameter method
		% Parameters
		% [mm] Diameter of knee
		function obj = setPulleyDiameter(obj, innerDiameter)
            obj.d_i = innerDiameter;
        end
        
        % Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\ExteriorTimingPulley.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_p"= ',num2str(obj.D_p),'\n'));
            fprintf(fid,strcat('"d_i"= ',num2str(obj.d_i),'\n'));
            fprintf(fid,strcat('"W_p"= ',num2str(obj.W_p),'\n'));
            fprintf(fid,strcat('"d_bolts"= ',num2str(obj.d_bolts),'\n'));
            fprintf(fid,strcat('"L_bolts"= ',num2str(obj.L_bolts),'\n'));
            fclose(fid);
        end
        
    end
end