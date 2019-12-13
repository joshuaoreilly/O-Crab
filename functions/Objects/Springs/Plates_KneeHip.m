classdef Plates_KneeHip
    properties
        D_hipkneeshaft	% [mm] Large diameter of the hip knee shaft
        D_o				% [mm] 
        d_bolts			% [mm] 
        L_bolts			% [mm] 
    end
    methods
        
        function obj = Plates_KneeHip(D_hipKnee_shaft,d_interior_pulley,L_interior_pulley,spring_nominal_d,spring_wire_d)
            obj = obj.setParameters(D_hipKnee_shaft,d_interior_pulley,L_interior_pulley,spring_nominal_d,spring_wire_d);
        end
        
        function obj = setParameters(obj,D_hipKnee_shaft,d_interior_pulley,L_interior_pulley,spring_nominal_d,spring_wire_d)
            obj.D_hipkneeshaft = D_hipKnee_shaft;
            obj.d_bolts = d_interior_pulley;
            obj.L_bolts = L_interior_pulley;
            obj.D_o = spring_nominal_d + 4*spring_wire_d;
        end
        
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipKneePulleyPlate.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"D_hipkneeshaft"= ',num2str(obj.D_hipkneeshaft),'\n'));
            fprintf(fid,strcat('"D_o"= ',num2str(obj.D_o),'\n'));
            fprintf(fid,strcat('"d_bolts"= ',num2str(obj.d_bolts),'\n'));
            fprintf(fid,strcat('"L_bolts"= ',num2str(obj.L_bolts),'\n'));
            fclose(fid);
        end
        
    end
end