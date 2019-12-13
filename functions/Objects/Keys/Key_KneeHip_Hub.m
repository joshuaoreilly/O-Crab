classdef Key_KneeHip_Hub
    properties
        h	% [mm] Height
        w	% [mm] Width
    end
    methods
        
		% Key Knee Hip Hub Constructor
        function obj = Key_KneeHip_Hub(shaft_KneeHip)
            obj = obj.setParameters(shaft_KneeHip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_KneeHip )
            obj.h = shaft_KneeHip.h_keyhub*2;
            obj.w = shaft_KneeHip.w_keyhub;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Keys\HipKneeKeyFlangeCollar.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"h"= ',num2str(obj.h),'\n'));
            fprintf(fid,strcat('"w"= ',num2str(obj.w),'\n'));
            fclose(fid);
        end
        
    end
end