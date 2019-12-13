classdef Pulley_Interior
    properties
        D_p			% [mm] Pitch Diameter
        d_i			% [mm] Hub Diameter
        w_k			% [mm] Width Key
        h_k			% [mm] Height Key
        W_p			% [mm] Width of the pulley
        d_bolts		% [mm] Diameter Bolt
        L_bolts		% [mm] Bolt Radius Location
    end
    methods
        
		% Pulley Interior Constructor
        function obj = Pulley_Interior(belt_System,D_kneeHip_shaft)
            obj = obj.setParameters(belt_System,D_kneeHip_shaft);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, belt_System,D_kneeHip_shaft)
            obj.D_p = belt_System.pulley_pitch_dia;
            obj.d_i = D_kneeHip_shaft;
            obj.W_p = belt_System.b_width;
            obj = obj.calculate(belt_System);
        end
		
		% Set Key Method
		% Parameters:
		% Key_HipKnee Object
        function obj = setKeys(obj,key_HipKnee)
            obj.w_k = key_HipKnee.w;
            obj.h_k = key_HipKnee.h/2;
        end
        
		% Calculate Bolt Method
		% Parameters:
		% Belt_System Object
        function obj = calculate(obj,belt_System)
            obj.d_bolts  = fasteners_kneeHip(belt_System.Pulley_Inner_Dia, obj.d_i, obj.W_p, 5, belt_System.M_k); %
            obj.L_bolts = (belt_System.Pulley_Inner_Dia - obj.d_i)/4+0.5*obj.d_i;
        end
        
		% Set Pulley Diameter Method
        function obj = setPulleyDiameter(obj, innerDiameter)
            obj.d_i = innerDiameter;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\InteriorTimingPulley.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_p"= ',num2str(obj.D_p),'\n'));
            fprintf(fid,strcat('"d_i"= ',num2str(obj.d_i),'\n'));
            fprintf(fid,strcat('"w_k"= ',num2str(obj.w_k),'\n'));
            fprintf(fid,strcat('"h_k"= ',num2str(obj.h_k),'\n'));
            fprintf(fid,strcat('"W_p"= ',num2str(obj.W_p),'\n'));
            fprintf(fid,strcat('"d_bolts"= ',num2str(obj.d_bolts),'\n'));
            fprintf(fid,strcat('"L_bolts"= ',num2str(obj.L_bolts),'\n'));
            fclose(fid);
        end
        
    end
end