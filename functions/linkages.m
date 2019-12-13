% Inputs
% x_reach 		= [mm] desired reach in x
% y_reach 		= [mm] desired reach in y
% Outputs
% r1 			= [mm] length of thigh linkage
% r2 			= [mm] length of upper tibia
% r3 			= [mm] length of lower tibia
% R 			= [mm] virtual length from knee to foot
% phi_min 		= [rad] minimum angle between knee and foot from horizontal
% phi_max 		= [rad] maximum angle between knee and foot from horizontal
% d 			= walking height from hip
% x_walking_min = [mm] minimum distance of foot from hip while walking
% x_walking_max = [mm] maximum distance of foot from hip while walking

function [r1,r2,r3,R,phi_min,phi_max,d,x_walking_min,x_walking_max] = linkages(x_reach,y_reach)
    % Reference values are given by workspace.m using r1=r2=100mm, r3 = 300mm and alpha = 69 degrees, theta_max = 28 degrees.
	% If the user gives a x or y reach higher than the reference, then the lengths will scale accordingly
	% The smallest desired reach will be respected, and the other will have higher range
	
	% Maximum reach in x and y (not necessarily at walking height)
    x_reference = 223.9456;
    y_reference = 52.5435;
	% walking x range and walking ground height
    x_walking_min_reference = 105.4968;
    x_walking_max_reference = 234.3159;
    ground_height_reference = 232.5574;
    
	% The ratio of x_reach to y_reach must be conserved
    if (x_reach/y_reach) < 4.2621
        x_reach = y_reach*4.2621;
    end
    
    r1 = 100*(x_reach/x_reference);
    r2 = 120*(x_reach/x_reference);
    r3 = 300*(x_reach/x_reference);
	% Geometric derivations similar to those in workspace.m
    R = sqrt(r2^2 + r3^2 - (2*r2*r3*cos(deg2rad(69))));
    beta = acos((r3^2 - R^2 - r2^2)/(-2*R*r2));
    phi_min = deg2rad(-22.5) - beta;
    phi_max = deg2rad(22.5) - beta;
    d = ground_height_reference*(x_reach/x_reference);
    x_walking_min = x_walking_min_reference*(x_reach/x_reference);
    x_walking_max = x_walking_max_reference*(x_reach/x_reference);
end

