function [x,y] = foot_position(theta,phi,r1,R)
	x = (r1*cos(theta)) + (R*cos(theta+phi));
	y = (r1*sin(theta)) + (R*sin(theta+phi));
end