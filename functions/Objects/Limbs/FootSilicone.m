classdef FootSilicone
    properties
        di_tibia	% [mm] Small diameter of Tibia Tube
    end
    methods
        
		% Foot Silicone Constructor
        function obj = FootSilicone(d_tibia_tube)
            obj = obj.setParameters(d_tibia_tube);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, d_tibia_tube)
            obj.di_tibia =d_tibia_tube;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\FootSilicone.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"di_tibia"= ',num2str(obj.di_tibia),'\n'));
            fclose(fid);
        end
        
    end
end