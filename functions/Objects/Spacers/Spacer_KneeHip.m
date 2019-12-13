classdef Spacer_KneeHip
    properties
        D_shafthipknee	% [mm] Inner diameter of spacer
        D_o				% [mm] Diameter of spring
        L				% [mm] Length of spacer
    end
    methods
        
		% Spacer Knee Hip Constructor
        function obj = Spacer_KneeHip(shaft_KneeHip,L1,d_o_spring,t_bolt_head)
            obj = obj.setParameters(shaft_KneeHip,L1,d_o_spring,t_bolt_head);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_KneeHip,L1,d_o_spring,t_bolt_head )
            obj.D_shafthipknee = shaft_KneeHip.D_big;
            obj.D_o = d_o_spring-3;
            obj.L = L1;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Spacers\HipKneeSpacerSpring.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_shafthipknee"= ',num2str(obj.D_shafthipknee),'\n'));
            fprintf(fid,strcat('"D_o"= ',num2str(obj.D_o),'\n'));
            fprintf(fid,strcat('"L"= ',num2str(obj.L),'\n'));
            fclose(fid);
        end
        
    end
end