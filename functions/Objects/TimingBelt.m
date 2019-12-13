classdef TimingBelt
    properties
        R_i		% [mm] Inner Radius
        R_o		% [mm] Outer Radius
        C		% [mm] Distancee center to center of pulleys
    end
    methods
        
		% Timing Belt Constructor
        function obj = TimingBelt(belt_system)
            obj = obj.setParameters(belt_system);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, belt_system)
            obj.R_i = belt_system.pulley_pitch_dia/2;
            obj.R_o = belt_system.Pulley_Belt_Total_Dia/2;
            obj.C = belt_system.C;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\TimingBelt.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"R_i"= ',num2str(obj.R_i),'\n'));
            fprintf(fid,strcat('"R_o"= ',num2str(obj.R_o),'\n'));
            fprintf(fid,strcat('"C"= ',num2str(obj.C),'\n'));
            fclose(fid);
        end
        
    end
end