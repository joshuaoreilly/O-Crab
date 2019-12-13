classdef Spring_Torsion_Knee
    properties
        bigR				% [mm] Coil Radius
        bigD				% [mm] Coil Diameter
        smalld				% [mm] Wire Diameter
        N					% [quantity] number of turns
        r					% [mm] Bend radius
        l =10;				% [mm] Offset length of both ends of spring
        Lmid				% [mm] Distance for mid plane
        k					% [N/mm] Spring Constant
        SF					% Safety Factor
        p					% [mm] Spring coil pitch
        Di					% [mm] Internal coil diameter
        L					% [mm] Length of spring
		correction_angle	% [deg] Angle to switch from spring deflection to prosition of leg

    end
    methods
        
        function obj = Spring_Torsion_Knee(leg,Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle)
            obj = obj.setParameters(leg,Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle);
        end
        
		% Properties and parameters calculation function
        function obj = setParameters(obj,leg,Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle)
            
            obj = obj.calculate(leg,Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle);
        end
		
		% Parametric Calculation function (Section 4.4 of Analysis Report)
        function obj = calculate(obj,leg,Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle)
        
            [k,d,D,l,SF,N,p,Di,theta_max] = torsionSpring(Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle);
            obj.bigR = D/2;
            obj.bigD =D;
            obj.smalld = d;
            obj.k = k;
            obj.N = N;
            obj.r = d/2;
            obj.Lmid = N*p/2;
            obj.SF=SF;
            obj.p = p;
            obj.Di = Di;
            obj.L = l;

			obj.correction_angle = theta_max*180/pi - leg.Phi + leg.Theta-360;
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\KneeTorsionSpring.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"bigR"= ',num2str(obj.bigR),'\n'));
            fprintf(fid,strcat('"smalld"= ',num2str(obj.smalld),'\n'));
            fprintf(fid,strcat('"N"= ',num2str(obj.N),'\n'));
            fprintf(fid,strcat('"r"= ',num2str(obj.r),'\n'));
            fprintf(fid,strcat('"l"= ',num2str(obj.l),'\n'));
            fprintf(fid,strcat('"Lmid"= ',num2str(obj.Lmid),'\n'));
            fprintf(fid,strcat('"p"= ',num2str(obj.p),'\n'));
            fclose(fid);
        end
        
    end
end