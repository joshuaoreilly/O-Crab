% Parameters
% A 	[mm] Position of point 1
% C 	[mm] Position of point 2
% D 	[mm] Position of point 3
% CG 	[mm] Position of centre of gravity
% W 	[kg] Weight of robot
% Slope [deg] Slope of ground

%Ouputs
% ff1	[N] Friction force at foot 1
% ff2 	[N] Friction force at foot 2

%Friction Calculation (Section 3.1.2 of Analysis Report)
function[ff1,ff2] = friction_Forces(A, C, D, CG, W, Slope)

FW = W*9.81;
ff1 = FW*sind(Slope)*abs(A(1)-CG(1))/abs(A(1)-D(1));
ff2 = FW*sind(Slope)-ff1;