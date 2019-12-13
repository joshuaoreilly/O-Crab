classdef TibiaPulleyHolder
    properties
        D_kneeshaft				% [mm] Large Diameter of Knee Shaft
        do_tibia				% [mm] Small Diameter of Tibia Tube
        D_bellowholder			% [mm] Diameter of bellow holding cylinder
        D_pulley				% [mm] Diameter of knne pulley
        L_plate					% [mm] Length of structural plates
        L_shaft					% [mm] Length of shaft ___
        d_bolts					% [mm] Diameter of bolt holes
        L_bolts					% [mm] Length of bolt holes
        Fillet					% [mm] Radius of fillet
        mass					% [kg] Mass of Tibia Pulley Holder Piece
		density = 2.7/(10^6); 	% [kg/mm^3] Density of Aluminum
    end
    methods
        
		% Tibia Pulley Holder Constructor
        function obj = TibiaPulleyHolder(shaft_Knee, do_tibia, D_pulley)
           obj = obj.setParameters(shaft_Knee, do_tibia, D_pulley);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, shaft_Knee, do_tibia, D_pulley)
            h_thigh_plate = D_pulley +4;
            obj.D_kneeshaft = shaft_Knee.D_big;
            obj.do_tibia = do_tibia;
            obj.D_bellowholder = sqrt((h_thigh_plate)^2 + (shaft_Knee.L_total_knee_shaft)^2)+4;
            obj.D_pulley = D_pulley;
            obj.L_plate = D_pulley+5;
            obj.L_shaft = 0.5*D_pulley +5;
            obj.Fillet = D_pulley*0.5-0.5;
            obj.d_bolts = shaft_Knee.D_big;
            obj.L_bolts = shaft_Knee.D_big;
            obj.mass = pi*((obj.D_bellowholder/2)^2)*20*obj.density;
        end
        
		% Bolt calculation function
        function obj = calculateBolts(obj, R, D_pulley_min, t_pulley, t_tibia, FF, FN)
            obj.d_bolts = fasteners_knee(R, D_pulley_min, obj.D_kneeshaft, t_pulley, t_tibia, FF, FN);
            obj.L_bolts = (D_pulley_min - obj.D_kneeshaft)/4+0.5*obj.D_kneeshaft;
        end
		
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\TibiaPulleyHolder.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_kneeshaft"= ',num2str(obj.D_kneeshaft),'\n'));
            fprintf(fid,strcat('"do_tibia"= ',num2str(obj.do_tibia),'\n'));
            fprintf(fid,strcat('"D_bellowholder"= ',num2str(obj.D_bellowholder),'\n')); % 4 mm of bellow groove
            fprintf(fid,strcat('"D_pulley"= ',num2str(obj.D_pulley),'\n'));
            fprintf(fid,strcat('"L_plate"= ',num2str(obj.L_plate),'\n')); % 5mm clearance
            fprintf(fid,strcat('"L_shaft"= ',num2str(obj.L_shaft),'\n'));
            fprintf(fid,strcat('"d_bolts"= ',num2str(obj.d_bolts),'\n'));
            fprintf(fid,strcat('"L_bolts"= ',num2str(obj.L_bolts),'\n'));
            fprintf(fid,strcat('"Fillet"= ',num2str(obj.Fillet),'\n'));
            fclose(fid);
        end
        
    end
end