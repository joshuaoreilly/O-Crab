classdef FootRod
    properties
        di_tibia	% [mm] Small Diameter Tibia Tube
        do_tibia	% [mm] Large Diameter Tibia Tube
    end
    methods
        
		% Foot Rod Constructor
        function obj = FootRod(d_tibia_tube,D_tibia_tube)
            obj = obj.setParameters(d_tibia_tube,D_tibia_tube);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, d_tibia_tube,D_tibia_tube)
            obj.di_tibia =d_tibia_tube;
            obj.do_tibia =D_tibia_tube;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\FootRod.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"di_tibia"= ',num2str(obj.di_tibia),'\n'));
            fprintf(fid,strcat('"do_tibia"= ',num2str(obj.do_tibia),'\n'));
            fclose(fid);
        end
        
    end
end