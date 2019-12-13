classdef Spacer_Hip_Spring
    properties
        D_shafthip	% [mm] Inner diameter of spacer
        L			% [mm] Length of spacer
        D_o			% [mm] Diameter of spring
    end
    methods
        
		% Spacer Hip Spring Constructor
        function obj = Spacer_Hip_Spring(D_shaft_Hip, w_spring_hip,d_o_spring)
            obj = obj.setParameters(D_shaft_Hip, w_spring_hip,d_o_spring);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,D_shaft_Hip, w_spring_hip,d_o_spring)
            obj.D_shafthip = D_shaft_Hip;
            obj.L = w_spring_hip;
            obj.D_o = d_o_spring-3; % d_o_spring is Di_h from torsionSpring.m
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Spacers\HipSpacerSpring.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_shafthip"= ',num2str(obj.D_shafthip),'\n'));
            fprintf(fid,strcat('"L"= ',num2str(obj.L),'\n'));
            fprintf(fid,strcat('"D_o"= ',num2str(obj.D_o),'\n'));
            fclose(fid);
            
        end
        
    end
end