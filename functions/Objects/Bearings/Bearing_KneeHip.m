classdef Bearing_KneeHip
    properties
        d_shafthipknee	% [mm] Diameter
    end
    methods
	
        % Bearing Knee Hip Constructor
        function obj = Bearing_KneeHip(d_shaft_KneeHip)
            obj = obj.setParameters(d_shaft_KneeHip);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, d_shaft_KneeHip)
            obj.d_shafthipknee = d_shaft_KneeHip;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipKneeBearing.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_shafthipknee"= ',num2str(obj.d_shafthipknee),'\n'));
            fclose(fid);
        end
        
    end
end