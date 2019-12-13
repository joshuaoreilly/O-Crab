classdef Collar_Hip
    properties
        d_hipshaft	% [mm] Small Diameter
        D_o			% [mm] Large Diameter
        d_bolts		% [mm] Diameter of bolt holes
        L_bolts		% [mm] Length of bolt holes
        w_k			% [mm] Width of key
        h_k			% [mm] Height of key
        n_bolts		% [quantity] Number of bolts
    end
    methods
        
		% Collar Hip Constructor
        function obj = Collar_Hip(d_hip_shaft, key_Hip_Collar,d_bolt_HD_flexSpline,L_bolt_HD_flexSpline,n_bolts_HD_flexSpline)
            obj = obj.setParameters(d_hip_shaft, key_Hip_Collar,d_bolt_HD_flexSpline,L_bolt_HD_flexSpline,n_bolts_HD_flexSpline);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj, d_hip_shaft, key_Hip_Collar,d_bolt_HD_flexSpline,L_bolt_HD_flexSpline,n_bolts_HD_flexSpline)
            obj.d_hipshaft = d_hip_shaft;
            obj.d_bolts = d_bolt_HD_flexSpline;
            obj.L_bolts = L_bolt_HD_flexSpline/2;
            obj.w_k = key_Hip_Collar.w;
            obj.h_k = key_Hip_Collar.h/2;
            obj.n_bolts = n_bolts_HD_flexSpline;
            obj.D_o = (obj.L_bolts +1.5*obj.d_bolts)*2;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\HipCollarOutput2.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"d_hipshaft"= ',num2str(obj.d_hipshaft),'\n'));
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