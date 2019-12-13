classdef Key_Hip_Plates
    properties
        h	% [mm] Height
        w	% [mm] Width
    end
    methods
        
		% Key Hip Plates Constructor
        function obj = Key_Hip_Plates(shaft_Hip)
            obj = obj.setParameters(shaft_Hip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_Hip)
            obj.h = shaft_Hip.h_keyplates*2;
            obj.w = shaft_Hip.w_keyplates; 
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Keys\HipKeyPlates.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"h"= ',num2str(obj.h),'\n'));
            fprintf(fid,strcat('"w"= ',num2str(obj.w),'\n'));
            fclose(fid);
            
        end
        
    end
end