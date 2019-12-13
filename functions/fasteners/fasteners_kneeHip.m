% From Analysis Report, Section 4.8 Fasteners
%% INPUTS
% D_pulley 		= [mm] outer diameter of pulley (from inside of teeth)
% D_shaft 		= [mm] diameter of shaft the pulley is mounted on
% t_pulley 		= [mm] thickness of pulley
% t_plates 		= [mm] thickness of tibia (one side of it)
% Torque 		= [Nmm] torque seen at knee hip
%% OUTPUTS
% d				= [mm] bolt diameter
function [d,ell] = fasteners_kneeHip(D_pulley,D_shaft,t_pulley,t_plates,Torque)
	d = linspace(1,20,20);
	% recommended distance from edge is 1.5 times the diameter; we're using 1.25 times since SF is so high [mm]
	% https://www.engineeringexpress.com/wiki/steel-bolt-edge-distance-requirements/
	ell = d.*1.25;
	
	% Material Properties
	Sp = 650;   	% [MPa] Proof strength
	Sy_b = 720;     % [MPa] Yield strength bolt
	Sut = 900;		% [MPa] Ultimate Tensile Strength bolt
	Se = 140;		% [MPa] Endurance strength bolt
	Sy_tibia = 276;	% [MPa] Yield strength Aluminium 6061
	Sy_pulley = 276;% [MPa] Yield strength Aluminium 6061
    SF = 2.5;		% Safety factor for all but tension
	Eb = 200;		% [MPa] Elastic Modulus bolt
	Em = 276;		% [MPa] Elastic Modulus Aluminium 6061
	
	%% GEOMETRIC PROPERTIES
	% Tension is neglected as the force is assumed to be taken by the pulley and shaft
	% Bolt is mounted in center of pulley (center of inner and outer diameter)
	r = D_shaft/2 + (D_pulley-D_shaft)/4;
	n = 2;
	% Since contact on both sides
	n_contact = n*2;
	% Bolt diameter
	Ab = pi*(d.^2)/4;
	% tensile strength area, Polyfit with MATLAB, below equation 155
	At = 0.7023*(d.^2) - 2.669*d + 9.963;
	
	%% FORCES AND MOMENTS
	% Pure moments applied to leg are assumed to be zero
	% Tension is assumed to be carried by the pulley and shaft
	% (Vy = My = 0)
	% Equations 138, 139, 140, 141, 142
	Vx = 0;
	Vy = 0;
	Vz = 0;
	My = Torque;
	Mz = 0;
	
	%% PURE SHEAR
	% Equations 143 to 148
	Fsh_primary_pulley = sqrt(Vz^2 + Vy^2)/n_contact;
	Fsh_secondary_pulley = My./(n_contact*r);
	Fsh_pulley = sqrt(Fsh_primary_pulley.^2 + Fsh_secondary_pulley.^2);
	SF_s_pulley = (0.58*Sy_b*(pi*(d.^2)./4))./Fsh_pulley;
	
	Fsh_primary_tibia = sqrt(Vz^2 + Vy^2)/n_contact;
	Fsh_secondary_tibia = My./(n_contact*r);
	Fsh_tibia = sqrt(Fsh_primary_tibia.^2 + Fsh_secondary_tibia.^2);
	SF_s_tibia = (0.58*Sy_b*(pi*(d.^2)./4))./Fsh_tibia;
	
	%% BEARING FORCES
	% Equations 149 to 151
	SF_b_pulley = t_pulley*Sy_b*d./Fsh_pulley;
	
	SF_b_tibia = t_plates*Sy_b*d./Fsh_tibia;
	
	%% EDGE SHEARING
	% Equations 152, 153
	SF_e_pulley = 0.577*Sy_pulley*t_pulley*ell./Fsh_pulley;
	
	SF_e_tibia = 0.577*Sy_tibia*t_plates*ell./Fsh_tibia;
	
	%% TENSION
	% Neglected
	
	%% RESULTS
	% Final d and ell
	% See parametrization flowcharts for vectorized parts
	[~,cols] = find(SF_s_pulley>2.5 & SF_b_pulley>2.5 & SF_e_pulley>2.5 & SF_s_tibia>2.5 & SF_b_tibia>2.5 & SF_e_tibia>2.5 );
	d = min(d(cols));
	if (d < 2)
		d = 2;
	end
	ell = d*1.25;
	[t_head,d_head,t_nut,d_nut,t_washer,od_washer,id_washer] = fasteners_general(d);
	% Approximately a couple extra threads extending beyond nut
	L_bolt = t_pulley + (t_plates*2) + (t_nut*1.2) + 2*t_washer;
	
	%--------------------------------------%
	%% PRINT TO FILE
	%--------------------------------------%
	% FastenersKneeHip.txt contains dimensions for the bolts and nuts
	filePath = '..\Solidworks\Equations\FastenersKneeHip.txt';
	fid = fopen(filePath,'wt');
	fprintf(fid,strcat('"diameter bolt"=',num2str(d),'\n'));
	fprintf(fid,strcat('"ell"=',num2str(ell),'\n'));
	fprintf(fid,strcat('"head thickness"=',num2str(t_head),'\n'));
	fprintf(fid,strcat('"head diameter"=',num2str(d_head),'\n'));
	fprintf(fid,strcat('"nut thickness"=',num2str(t_nut),'\n'));
	fprintf(fid,strcat('"nut diameter"=',num2str(d_nut),'\n'));
	fprintf(fid,strcat('"washer thickness"=',num2str(t_washer),'\n'));
	fprintf(fid,strcat('"washer outer diameter"=',num2str(od_washer),'\n'));
	fprintf(fid,strcat('"bolt length"=',num2str(L_bolt),'\n'));
	fclose(fid);
	
end