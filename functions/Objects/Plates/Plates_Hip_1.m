classdef Plates_Hip_1
    properties
        d_knee					% [mm] Small diameter of the knee shaft
        d_hip					% [mm] Large diameter of the hip shaft
        d_hipknee				% [mm] Small diameter of the hip knee shaft
        height					% [mm] Height of the hip plate
        curve					% [mm] Fillet of the plates
        r1						% [mm] Length of the thigh
        L_hipknee				% [mm] Distance between hip and hip knee shafts
        L_end					% [mm] Length of the end of the plates
        w_k						% [mm] Width of key
        h_k						% [mm] Height of key
        r_springHip				% [mm] Radius spring mounting for hip
        Rnom_springHip			% [mm] Radius of spring for hip
        dHolder_springHip		% [mm] Size of spring holder for hip
        d_springHip				% [mm] Spring wire diameter for hip
        r_springKnee			% [mm] Radius spring mounting for knee
        Rnom_springKnee			% [mm] Radius of spring for knee
        dHolder_springKnee		% [mm] Size of spring holder for knee
        d_springKnee			% [mm] Spring wire diameter for knee
        HipSpacing				% [mm] Distance between hip plates plus alignment pin penetration distance
        d_boltsAdapter			% [mm] Size of bolt for knee adapter
        L_boltsAdapter			% [mm] Distance of bolt from center of shaft
        angle					% [mm] Angle separating bolts
    end
    methods
        
		% Plates Hip 1 Constructor
        function obj = Plates_Hip_1(d_knee_shaft,D_hip_shaft,shaft_hipKnee,max_diameter_pulley,leg_r1,distance_between_shafts,adapter_Knee,key_Hip_Plates,spring_Torsion_Hip,spring_Torsion_Knee)
            obj = obj.setParameters(d_knee_shaft,D_hip_shaft,shaft_hipKnee,max_diameter_pulley,leg_r1,distance_between_shafts,adapter_Knee,key_Hip_Plates,spring_Torsion_Hip,spring_Torsion_Knee );
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,d_knee_shaft,D_hip_shaft,shaft_hipKnee,max_diameter_pulley,leg_r1,distance_between_shafts,adapter_Knee,key_Hip_Plates,spring_Torsion_Hip,spring_Torsion_Knee)
            obj.d_knee = d_knee_shaft + 4;
            obj.d_hip = D_hip_shaft;
            obj.d_hipknee = shaft_hipKnee.d_small +4;
            obj.height = max_diameter_pulley +4;
            obj.curve = obj.height /2;
            obj.r1 = leg_r1;
            obj.L_hipknee = distance_between_shafts; %from hip bracket
            obj.L_end = adapter_Knee.outer_diameter/2+5;
            obj.w_k = key_Hip_Plates.w;
            obj.h_k = key_Hip_Plates.h/2;
            obj.r_springHip = spring_Torsion_Hip.r;
            obj.Rnom_springHip =  spring_Torsion_Hip.bigR;
            obj.d_springHip = spring_Torsion_Hip.smalld;
            obj.dHolder_springHip = obj.d_springHip * 4;
            obj.r_springKnee = spring_Torsion_Knee.r;
            obj.Rnom_springKnee = spring_Torsion_Knee.bigR;
            obj.d_springKnee = spring_Torsion_Knee.smalld;
            obj.dHolder_springKnee = obj.d_springKnee *4;
            obj.HipSpacing = shaft_hipKnee.L_mid + 4 + 4; %Bearing flange + Alignment Pin
            obj.d_boltsAdapter = adapter_Knee.bolt_diameter;
            obj.L_boltsAdapter = adapter_Knee.mounting_diameter/2;
            obj.angle = adapter_Knee.bolt_angle;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipPlate1.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_knee"= ',num2str(obj.d_knee),'\n'));
            fprintf(fid,strcat('"d_hip"= ',num2str(obj.d_hip),'\n'));
            fprintf(fid,strcat('"d_hipknee"= ',num2str(obj.d_hipknee),'\n'));
            fprintf(fid,strcat('"height"= ',num2str(obj.height),'\n'));
            fprintf(fid,strcat('"curve"= ',num2str(obj.curve),'\n'));
            fprintf(fid,strcat('"r1"= ',num2str(obj.r1),'\n'));
            fprintf(fid,strcat('"L_hipknee"= ',num2str(obj.L_hipknee),'\n'));
            fprintf(fid,strcat('"L_end"= ',num2str(obj.L_end),'\n'));
            fprintf(fid,strcat('"w_k"= ',num2str(obj.w_k),'\n'));
            fprintf(fid,strcat('"h_k"= ',num2str(obj.h_k),'\n'));
            fprintf(fid,strcat('"r_springHip"= ',num2str(obj.r_springHip),'\n'));
            fprintf(fid,strcat('"Rnom_springHip"= ',num2str(obj.Rnom_springHip),'\n'));
            fprintf(fid,strcat('"dHolder_springHip"= ',num2str(obj.dHolder_springHip),'\n'));
            fprintf(fid,strcat('"d_springHip"= ',num2str(obj.d_springHip),'\n'));
            fprintf(fid,strcat('"r_springKnee"= ',num2str(obj.r_springKnee),'\n'));
            fprintf(fid,strcat('"Rnom_springKnee"= ',num2str(obj.Rnom_springKnee),'\n'));
            fprintf(fid,strcat('"dHolder_springKnee"= ',num2str(obj.dHolder_springKnee),'\n'));
            fprintf(fid,strcat('"d_springKnee"= ',num2str(obj.d_springKnee),'\n'));
            fprintf(fid,strcat('"HipSpacing"= ',num2str(obj.HipSpacing),'\n'));
            fprintf(fid,strcat('"d_boltsAdapter"= ',num2str(obj.d_boltsAdapter),'\n'));
            fprintf(fid,strcat('"L_boltsAdapter"= ',num2str(obj.L_boltsAdapter),'\n'));
            fprintf(fid,strcat('"angle"= ',num2str(obj.angle),'\n'));
            fclose(fid);
        end
        
    end
end