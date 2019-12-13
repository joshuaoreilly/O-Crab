classdef FootCap
    properties
        D_sock 		% [mm] Diameter of the cap
        do_tibia	% [mm] Large diameter of the tibia tube
    end
    methods
        
		% Foot Cap Constructor
        function obj = FootCap(d_tibia_tube,D_tibia_tube)
           obj = obj.setParameters(d_tibia_tube,D_tibia_tube);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, d_tibia_tube,D_tibia_tube)
            obj.D_sock =d_tibia_tube+8; % 2*4 mm of silicone thickness
            obj.do_tibia =D_tibia_tube;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\FootCap.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_sock"= ',num2str(obj.D_sock),'\n')); 
            fprintf(fid,strcat('"do_tibia"= ',num2str(obj.do_tibia),'\n'));
            fclose(fid);
        end
        
    end
end