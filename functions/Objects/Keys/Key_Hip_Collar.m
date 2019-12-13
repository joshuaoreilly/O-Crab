classdef Key_Hip_Collar
    properties
        h 	% [mm] Height
        w	% [mm] Width
    end
    methods
        
		% Key Hip Collar Constructor
        function obj = Key_Hip_Collar(shaft_Hip)
            obj = obj.setParameters(shaft_Hip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_Hip)
            obj.h = shaft_Hip.h_keyhub*2;
            obj.w = shaft_Hip.w_keyhub;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Keys\HipKeyFlangeCollar.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"h"= ',num2str(obj.h),'\n'));
            fprintf(fid,strcat('"w"= ',num2str(obj.w),'\n'));
            fclose(fid);
            
        end
        
    end
end