classdef Bellow
    properties
        bellow_inner_length    % [mm] Bellow inner length excluding flanges
        bellow_thickness       % [mm] Bellow wall thickness
        large_fold_length      % [mm] Bellow large fold length
        Bellow_small_inner_d   % [mm] Bellow tibia inner flange diameter
        Bellow_large_inner_D   % [mm] Bellow chassis inner flange diameter
        R_chassis_flange       % [mm} Bellow tibia inner flange radius
        R_knee_flange          % [mm] Bellow chassis inner flange radius
    end
    
    methods
        
        % Bellow Constructor
        function obj = Bellow(plates_Hip_1,chassis,tibiaPulleyHolder)
            obj = obj.setParameters(plates_Hip_1,chassis,tibiaPulleyHolder);
        end
        
        % Properties and parameters calculation function
        function obj = setParameters(obj,plates_Hip_1,chassis,tibiaPulleyHolder)
            obj.bellow_inner_length = plates_Hip_1.r1 - (chassis.L - 2) + (tibiaPulleyHolder.L_shaft + 5);
            obj.Bellow_small_inner_d = tibiaPulleyHolder.D_bellowholder - 4;
            obj.Bellow_large_inner_D = chassis.D_i + 2*chassis.t_wall;
            obj = obj.calculate();
        end
        
        % Parametric Calculation function
        function obj = calculate(obj)
            
            %% Parameterized Bellow Dimensions
            obj.R_chassis_flange = obj.Bellow_large_inner_D/2;
            obj.R_knee_flange = obj.Bellow_small_inner_d/2;
            % Possible scenarios for fold length
            large_fold_length1 = (obj.R_chassis_flange-obj.R_knee_flange)/2;
            large_fold_length2 = obj.bellow_inner_length/5;
            % Picks the largest value for the fold length
            obj.large_fold_length = max(large_fold_length1,large_fold_length2);
            
            %% Constant bellow dimensions
            obj.bellow_thickness = 2;
            
        end
        
        % Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Bellow.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"R_chassis_flange"=',num2str(obj.R_chassis_flange),'\n'));
            fprintf(fid,strcat('"R_knee_flange"=',num2str(obj.R_knee_flange),'\n'));
            fprintf(fid,strcat('"bellow_thickness"=',num2str(obj.bellow_thickness),'\n'));
            fprintf(fid,strcat('"large_fold_length"=',num2str(obj.large_fold_length),'\n'));
            fprintf(fid,strcat('"bellow_inner_length"=',num2str(obj.bellow_inner_length),'\n'));
            fclose(fid);
        end
    end
end