classdef Collar_KneeHip
    properties
        d_hipkneeshaft	% [mm] Small Diameter
        D_o				% [mm] Large Diameter
        d_bolts			% [mm] Diameter of bolt hole
        L_bolts			% [mm] Length of bolt hole
        w_k				% [mm] Width of key
        h_k				% [mm] Height of key
        n_bolts			% [quantity] Number of bolts
    end
    methods
        
		% Collar Knee Hip Constructor
        function obj = Collar_KneeHip(d_hipKnee_shaft, key_KneeHip_Hub,d_bolt_HD_flexSpline,L_bolt_HD_flexSpline,n_bolts_HD_flexSpline)
            obj = obj.setParameters(d_hipKnee_shaft, key_KneeHip_Hub,d_bolt_HD_flexSpline,L_bolt_HD_flexSpline,n_bolts_HD_flexSpline);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, d_hipKnee_shaft, key_KneeHip_Hub,d_bolt_HD_flexSpline,L_bolt_HD_flexSpline,n_bolts_HD_flexSpline)
            obj.d_hipkneeshaft = d_hipKnee_shaft;
            obj.d_bolts = d_bolt_HD_flexSpline;
            obj.L_bolts = L_bolt_HD_flexSpline/2;
            obj.w_k = key_KneeHip_Hub.w;
            obj.h_k = key_KneeHip_Hub.h/2;
            obj.n_bolts = n_bolts_HD_flexSpline;
            obj.D_o = (obj.L_bolts +1.5*obj.d_bolts)*2;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipKneeCollarOutput2.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_hipkneeshaft"= ',num2str(obj.d_hipkneeshaft),'\n'));
            fprintf(fid,strcat('"D_o"= ',num2str(obj.D_o),'\n'));
            fprintf(fid,strcat('"d_bolts"= ',num2str(obj.d_bolts),'\n'));
            fprintf(fid,strcat('"L_bolts"= ',num2str(obj.L_bolts),'\n'));
            fprintf(fid,strcat('"w_k"= ',num2str(obj.w_k),'\n'));
            fprintf(fid,strcat('"h_k"= ',num2str(obj.h_k),'\n'));
            fprintf(fid,strcat('"n_bolts"= ',num2str(obj.n_bolts),'\n'));
            fclose(fid);
        end
        
    end
end