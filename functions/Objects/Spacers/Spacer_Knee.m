classdef Spacer_Knee
    properties
        D_shaftknee % [mm] Inner diameter of spacer
        L			% [mm] Length of spacer
    end
    methods
        
		% Spacer Knee Constructor
        function obj = Spacer_Knee(shaft_Knee, t_pulley)
            obj = obj.setParameters(shaft_Knee, t_pulley);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,shaft_Knee, t_pulley)
            obj.D_shaftknee = shaft_Knee.D_big;
            obj.L = (shaft_Knee.L_mid-t_pulley-20)/2;
        end
		
        % Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Spacers\KneeSpacer.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_shaftknee"= ',num2str(obj.D_shaftknee),'\n'));
            fprintf(fid,strcat('"L"= ',num2str(obj.L),'\n'));
            fclose(fid);
            
        end
        
    end
end