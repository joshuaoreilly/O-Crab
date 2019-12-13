classdef Spacer_Hip_Mid
    properties
        D_shafthip	% [mm] Inner diameter of spacer
        L			% [mm] Length of spacer
    end
    methods
        
		% Spacer Hip Mid Constructor
        function obj = Spacer_Hip_Mid(D_shaft_Hip, L_mid_KneeHip)
            obj = obj.setParameters(D_shaft_Hip, L_mid_KneeHip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,D_shaft_Hip, L_mid_KneeHip)
            obj.D_shafthip = D_shaft_Hip;
            obj.L = L_mid_KneeHip+4;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Spacers\HipSpacerMid.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_shafthip"= ',num2str(obj.D_shafthip),'\n'));
            fprintf(fid,strcat('"L"= ',num2str(obj.L),'\n'));
            fclose(fid);
            
        end
        
    end
end