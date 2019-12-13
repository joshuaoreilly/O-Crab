classdef Bearing_Knee
    properties
        d_shaftknee	% [mm] Diameter
    end
    methods
        
		% Bearing Knee Constructor
        function obj = Bearing_Knee(shaft_Knee_d)
            obj = obj.setParameters(shaft_Knee_d);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_Knee_d)
            obj.d_shaftknee = shaft_Knee_d;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\KneeBearing.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_shaftknee"= ',num2str(obj.d_shaftknee),'\n'));
            fclose(fid);
        end
        
    end
end