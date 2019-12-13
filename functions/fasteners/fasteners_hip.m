%% INPUTS
% r1 			= length of thigh member [mm]
% R 			= virtual length of tibia (straight line from knee to foot) [mm]
% t 			= thickness of hip brackets and plate [mm]
% H_bracket 	= height of the hip bracket (from center of shaft to
% W_bracket 	= width of bracket [mm]
% L_shaft 		= lengt of shaft between brackets [mm]
%Fx,Fz,Fz 		= forces along fastener x, y and z [N]
%% OUTPUTS
% d				= [mm] bolt diameter
function [d,ell] = fasteners_hip(r1,R,t,H_bracket,W_bracket,L_shaft,Fx,Fy,Fz)
	d = linspace(1,20,20);
	% recommended distance from edge is 1.5 times the diameter; we're using 1.25 times since SF is so high [mm]
	% https://www.engineeringexpress.com/wiki/steel-bolt-edge-distance-requirements/
	ell = d.*1.25;
	
	%% Material Properties
	Sp = 650;   	% [MPa] Proof strength
	Sy_b = 720;     % [MPa] Yield strength bolt
	Sut = 900;		% [MPa] Ultimate Tensile Strength bolt
	Se = 140;		% [MPa] Endurance strength bolt
	Sy_alu = 276;	% [MPa] Yield strength Aluminium 6061
    SF = 2.5;		% Safety factor for all but tension
	Eb = 200;		% [MPa] Elastic Modulus bolt
	Em = 276;		% [MPa] Elastic Modulus Aluminium 6061
	
	%% GEOMETRIC PROPERTIES
    % theta = angle between thigh and robot horizontal plane [rad]. 17
    % degrees was found to give the largest moment
    % phi = angle between tibia and robot horizontal plane [rad]. -51
    % degrees was found to give the largest moment
	theta = deg2rad(17.1887);
	phi = deg2rad(-51.8913);
	
	% Since the bolts are not necessarily all the same distance from the centroid, we will use the smallest distance for shear and largest distance for tension (gives lowest SF)
	% From centroid to center of bolt
	% Based on Figure 45 of Analysis Report
	rx = (W_bracket/2) - (ell+(d./2));
	ry = (L_shaft/2) - (ell+(d./2));
	r_shear = min(rx,ry);
	r_tension = max(rx,ry);
	% From centroid to edge of plate
	rpx = (W_bracket/2);
	rpy = (L_shaft) + t;
	
	% Number of bolts
	n = 4;
	% thickness of both members
	g = t+t;
	% Bolt diameter
	Ab = pi*(d.^2)/4;
	% tensile strength area, Polyfit with MATLAB, below equation 155
	At = 0.7023*(d.^2) - 2.669*d + 9.963;
	
	%% GEOMETRIC DERIVATIONS
	x = r1.*cos(theta) + R.*cos(phi);
	y = 0;
	z = r1.*sin(theta) + R.*sin(phi) - (H_bracket+t);
	rho = 0;							%rho = atan2(y,x);
	epsilon = atan2(z,x);
	P = sqrt(r1.^2 + R.^2 - (2*r1.*R.*cos(phi - pi - theta)));
	
	%% FORCES AND MOMENTS
	% Pure moments applied to leg are assumed to be zero
	% Equations 138, 139, 140, 141, 142
	Vx = Fx;
	Vy = Fy;
	Ft = Fz;
	My = (Fz*cos(epsilon) - Fx*sin(epsilon))*P + 0;
	Mz = (Fy*cos(rho) - Fx*sin(rho))*P + 0;

	%% PURE SHEAR
	% Equations 143 to 148
	Fsh_primary = sqrt(Vx^2 + Vy^2)/n;
	Fsh_secondary = Mz./(n*r_shear);
	Fsh = sqrt(Fsh_primary.^2 + Fsh_secondary.^2);
	SF_s = (0.58*Sy_b*(pi*(d.^2)./4))./Fsh;
	
	%% BEARING FORCES
	% Equations 149 to 151
	SF_b = t*Sy_b*d./Fsh;
	
	%% EDGE SHEARING
	% Equations 152, 153
	SF_e = 0.577*Sy_alu*t*ell./Fsh;
	
	%% TENSION
	% Equations 155 to 164
	Fi = 0.7*Sp*At;
	T = 0.2*Fi.*d;
	kb = Eb*Ab./g;
	Am = d.^2 + 0.68*g*d + 0.065*(g^2);
	km = (Em*Am)./g;
	Fb = Fi + (((kb)/(kb+km)).*(1/n).*(Ft+(My./(rpx+r_tension))));
	Fm = Fi - (((km)/(kb+km)).*(1/n).*(Ft+(My./(rpx+r_tension))));
	sigma_b = Fb*4./(pi*(d.^2));
	SF_t = Sy_b./sigma_b;
	
	%% RESULTS
	% Final d and ell
	% See parametrization flowcharts for vectorized parts
	[~,cols] = find(SF_s>2.5 & SF_b>2.5 & SF_e>2.5 & SF_t>2);
	d = min(d(cols));
	ell = d*1.25;
	[t_head,d_head,t_nut,d_nut,t_washer,od_washer,id_washer] = fasteners_general(d);
	L_bolt = g + (t_nut*1.2) + 2*t_washer;		% Approximately a couple extra threads extending beyond nut
	
	%--------------------------------------%
	%% PRINT TO FILE
	%--------------------------------------%
	% FastenersHip.txt contains dimensions for the bolts and nuts
	filePath = '..\Solidworks\Equations\FastenersHip.txt';
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