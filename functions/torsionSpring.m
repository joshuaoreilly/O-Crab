% Parameters
% Mmax			[Nmm] Maximum torque
% Mmin			[Nmm] Minimum torque
% Dmin			[mm] Minimum possible diameter
% Dmax			[mm] Maximum possible diameter
% MaxAngle		[deg] Maximum rotation angle
% MinAngle		[deg] Minimum rotation angle
% freeAngle		[deg] Spring free angle

%Outputs
% k				[N/mm] Spring Constant	
% d				[mm] Wire Diameter
% D				[mm] Coil diameter
% l				[mm] Length of spring
% SF			[] Safety Factor
% N				[quantity] Number of turns
% p				[mm] Pitch
% Di			[mm] Internal coil diameter
% theta_max		[deg] Max deflection

% Parametric Calculation function (Section 4.4 of Analysis Report)
function [k,d,D,l,SF,N,p,Di,theta_max] = torsionSpring(Mmax,Mmin,Dmin,Dmax,MaxAngle,MinAngle,free_angle)
%% Spring material: music wire
E = 207E3;  % MPa    (E = 207 GPa)
A = 2211;   % MPa mm (A = 2211 MPa mm)
m = 0.145;  % 

%% Finding backdriving torque (Section 4.4.3 of Analysis Report)
Back_driving_torque = Mmax/5;
Max_M_spring = 1/2*(Mmax - Back_driving_torque);
Min_M_spring = 1/2*(Mmin - Back_driving_torque);

%% Finding the minimal spring constant k (Section 4.4.6 of Analysis Report)
% Equation 70
k_min = (Max_M_spring - Min_M_spring)/(abs(deg2rad(MaxAngle - MinAngle))); 
% Equation 71 and 72
theta_max = Max_M_spring/k_min;
theta_min = Min_M_spring/k_min;

%% Geometric Calculation
if free_angle <= 180
    angle = free_angle + 180;
else
    angle = free_angle - 180;
end
%% Starting Values
L_arm = 0;
N_f = 1; 
N_p = -1/360*angle+1; %Eq. 73
N_b = N_f + N_p; %Eq. 74

%% Vectorized parametrization method, see Capstone Report Appendix

N_f_nomatrix = linspace(1,10,10);
N_f          = repmat(N_f_nomatrix,100,1,100);
d_nomatrix   = linspace(1,15,100);
d            = repmat(d_nomatrix',1,10,100);
D_nomatrix   = linspace(1,100,100);
D_reshaped   = reshape(D_nomatrix,[1,1,100]);
D            = repmat(D_reshaped,100,10,1);

% Section 4.4.6 of Analyis Report
N_b = N_f + N_p; %Eq. 74
N_a = N_b + (2.*L_arm./(3.*pi.*D)); %Eq. 75

k = (d.^4.*E)./(64.*D.*N_a); %Eq. 77

M = k.*theta_max; %Eq. 79

theta_prime = (10.8.*M.*D.*N_b)./(d.^4.*E); %Eq. 80
D_prime     = (N_b.*D)./(N_b + theta_prime); %Eq. 81
D_i_prime   = D_prime - d; %Eq. 82

C     = D./d;
K_i   = (4.*C.^2 - C - 1)./(4.*C.*(C - 1)); %Eq. 83
sigma = K_i.*32.*M./(pi.*d.^3); %Eq. 84
S_ut  = A./d.^m;
S_y   = 0.78.*S_ut;
SF    = S_y./sigma; %Eq. 85

%% Find vectorized solution
%[rows,cols,depth] = ind2sub(size(N_f),find((SF>=1) & (k>=k_min) & (D_i_prime>Dmin) & (C<=12) & (C>=4) & ((D+4*d)<Dmax)));
[rows,cols,depth] = ind2sub(size(N_f),find((SF>=1) & (k>=k_min)  & (C<=12) & (C>=4)));

Nf_matching = zeros(size(rows,1),1);
d_matching  = zeros(size(rows,1),1);
% D_matching  = zeros(size(rows,1),1);
% SF_matching  = zeros(size(rows,1),1);
% k_matching  = zeros(size(rows,1),1);
% Di_matching  = zeros(size(rows,1),1);
for i=1:1:size(rows,1)
    Nf_matching(i) = N_f(rows(i),cols(i),depth(i));
    d_matching(i)  = d(rows(i),cols(i),depth(i));
    D_matching(i)  = D(rows(i),cols(i),depth(i));
    SF_matching(i) = SF(rows(i),cols(i),depth(i));
    k_matching(i)  = k(rows(i),cols(i),depth(i));
    Di_matching(i)  = D_i_prime(rows(i),cols(i),depth(i));
end

L     = Nf_matching.*d_matching;
[l,i] = min(L);

N  = Nf_matching(i);
d  = d_matching(i);
D  = D_matching(i);
SF = SF_matching(i);
k  = k_matching(i);
Di = Di_matching(i);

% Small modification to pitch for solid works
p = d*1.01;
l = l/d*p+2*d;

end