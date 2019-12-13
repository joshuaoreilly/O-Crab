% Parameters
% P1 	[mm] Position of point 1
% P2	[mm] Position of point 2
% P3 	[mm] Position of point 3
% CG 	[mm] Position of centre of gravity
% W 	[kg] Weight of robot
% Slope [deg] Slope of ground

% Outputs
% N1 	[N] Normal Force at P1
% N2	[N] Normal Force at P2
% N3 	[N] Normal Force at P3

% Normal Force Calculation Function (Section 3.1.1 of Analysis Report)
function[N1,N2,N3] = forces(P1, P2, P3, CG, W, Slope)

FW = W*9.81;
matrixForce = [FW*cosd(Slope); (FW*cosd(Slope)*(CG(2)-P1(2))); FW*(cosd(Slope)*(CG(1)-P2(1))-sind(Slope)*(CG(3)-P2(3)))];
matrixDistance = [1 1 1; 0 (P2(2)-P1(2)) (P3(2)-P1(2)); (P1(1)-P2(1)) 0 (P3(1)-P2(1))];
matrix = transpose(inv(matrixDistance)*matrixForce);

N1=matrix(1);
N2=matrix(2);
N3=matrix(3);