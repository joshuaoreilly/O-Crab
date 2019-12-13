classdef Key_KneeHip_Pulley
    properties
        h	% [mm] Height
        w	% [mm] Width
    end
    methods
        
		% Key Knee Hip Pulley Constructor
        function obj = Key_KneeHip_Pulley(shaft_KneeHip)
            obj = obj.setParameters(shaft_KneeHip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_KneeHip )
            obj.h = shaft_KneeHip.h_keypulley*2;
            obj.w = shaft_KneeHip.w_keypulley;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Keys\HipKneeKeyPulley.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"h"= ',num2str(obj.h),'\n'));
            fprintf(fid,strcat('"w"= ',num2str(obj.w),'\n'));
            fclose(fid);
        end
        
    end
end