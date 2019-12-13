classdef Bearing_Hip
    properties
        d_shafthip	% [mm] Diameter
    end
    methods
        
		% Bearing Hip Constructor
        function obj = Bearing_Hip(d_shaft_Hip)
            obj = obj.setParameters(d_shaft_Hip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,d_shaft_Hip)
            obj.d_shafthip = d_shaft_Hip;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipBearing.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_shafthip"= ',num2str(obj.d_shafthip),'\n'));
            fclose(fid);
            
        end
        
    end
end