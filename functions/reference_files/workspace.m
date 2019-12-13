%% Purpose
% This script calculated the workspace for a given leg configuration, the
% largest achievable x and r range for movement, as well as the range in x
% during "regular walking". This is used to generate the reference values used in `linkages.m`

%% Leg configuration
% This was determined experimentally from Analysis Report, Section 3.4
alpha = deg2rad(69);
r1 = 100;
r2 = 100;
r3 = 300;
theta_min = 0;
% Higher thetas doesn't fit the chassis
theta_max = deg2rad(28);
% relative to linkage r1
psi_min = deg2rad(-22.5);
psi_max = deg2rad(22.5);

% Geometric properties derived following convention in workspace_variables.png
R = sqrt(r2^2 + r3^2 - (2*r2*r3*cos(alpha)));
beta = acos((r3^2 - R^2 - r2^2)/(-2*R*r2));
% Works in phi relative to thigh linkage, not horizontal
phi_min = psi_min - beta;
phi_max = psi_max - beta;

% Ground height is determined (quasi-arbitrarily) when theta is max and phi is min
[~,ground_height] = foot_position(theta_max,phi_min,r1,R);

%% Simulation Properties
steps = 1000;
precision = 1;

% Generate values of theta and phi over all 4 phases:
% phase 1: theta = 28, phi goes from min to max
% phase 2: theta goes from 28 to 0, phi constant
% phase 3: theta = 0, phi goes from max to min
% phase 4: theta goes from 0 to 28, phi constant (closes cycle)
theta1 = ones(1,steps)*theta_max;
theta2 = linspace(theta_max,theta_min,steps);
theta3 = ones(1,steps)*theta_min;
theta4 = linspace(theta_min,theta_max,steps);
phi1 = linspace(phi_min,phi_max,steps);
phi2 = ones(1,steps)*phi_max;
phi3 = linspace(phi_max,phi_min,steps);
phi4 = ones(1,steps)*phi_min;

[x1,y1] = foot_position(theta1,phi1,r1,R);
[x2,y2] = foot_position(theta2,phi2,r1,R);
[x3,y3] = foot_position(theta3,phi3,r1,R);
[x4,y4] = foot_position(theta4,phi4,r1,R);

% All x, y, theta and phi over all cycles
x = [x1,x2,x3,x4];
y = [y1,y2,y3,y4];
theta = [theta1,theta2,theta3,theta4];
phi = [phi1,phi2,phi3,phi4];

x_min = min(x);
x_max = max(x);
y_min = min(y);
y_max = max(y); 

% Generate range of possible values of x and y in workspace
x_range = linspace(x_min,x_max,steps);
y_range = linspace(y_min,y_max,steps);

% y_max - y_min
y_reach = 0;
% value of x at location of y_reach
x_at_y_reach = 0;
y_min = 0;
y_max = 0;
% x_max - x_min
x_reach = 0;
% value of y at location of x_reach
y_at_x_reach = 0;
x_min = 0;
x_max = 0;

% Iterate over x, find maximum y_range
for i=1:length(x_range)
    [~,cols] = find((x>(x_range(i)-precision)) & (x<(x_range(i)+precision)));
    yVals = y(cols);
    yVals1 = repmat(yVals,[length(yVals),1]);
    yVals2 = repmat(yVals',[1,length(yVals)]);
    y_reach_i = max(abs(yVals1 - yVals2),[],'all');
    if (y_reach_i > y_reach)
        y_reach = y_reach_i;
        x_at_y_reach = x_range(i);
        y_min = min(yVals1,[],'all');
        y_max = max(yVals1,[],'all');
    end
end
% Iterate over y, find maximum x_range
for i=1:length(y_range)
    [~,cols] = find((y>(y_range(i)-precision)) & (y<(y_range(i)+precision)));
    xVals = x(cols);
    xVals1 = repmat(xVals,[length(xVals),1]);
    xVals2 = repmat(xVals',[1,length(xVals)]);
    x_reach_i = max(abs(xVals1 - xVals2),[],'all');
    if (x_reach_i > x_reach)
        x_reach = x_reach_i;
        y_at_x_reach = y_range(i);
        x_min = min(xVals1,[],'all');
        x_max = max(xVals1,[],'all');
    end
end

% Find x_range for the (pretty much arbitrarily) chosen walking height
% y=d=-ground_height [mm]; although x_range can be higher, this is the distance that'll
% be used for regular walking conditions. -ground_height is
% the foot height when theta = 28degrees, phi = min
[~,cols] = find((y>(ground_height-precision)) & (y<(ground_height+precision)));
WxVals = x(cols);
WxVals1 = repmat(WxVals,[length(WxVals),1]);
WxVals2 = repmat(WxVals',[1,length(WxVals)]);
% Wx_reach is the distance the leg can reach in x over any y in the workspace
Wx_reach = max(abs(WxVals1 - WxVals2),[],'all');
Wx_min = min(WxVals1,[],'all');
Wx_max = max(WxVals1,[],'all');

% This is what we use in linkages as x_reference and y_reference
fprintf('Reach in x: %f at y=%f\n',x_reach,y_at_x_reach);
fprintf('Reach in y: %f at x=%f\n',y_reach,x_at_y_reach);

figure;
title('Workspace and range visualization');
xlabel('x (mm)');
ylabel('y (mm)');
hold on;
plot(x1,y1,'-b','LineWidth',1.5);
plot(x2,y2,'-b','LineWidth',1.5,'HandleVisibility','off');
plot(x3,y3,'-b','LineWidth',1.5,'HandleVisibility','off');
plot(x4,y4,'-b','LineWidth',1.5,'HandleVisibility','off');
plot([x_at_y_reach x_at_y_reach],[y_min y_max],'--r','LineWidth',1);
plot([x_min x_max],[y_at_x_reach y_at_x_reach],'--r','LineWidth',1,'HandleVisibility','off');
plot([Wx_min Wx_max],[ground_height ground_height],'-.k','LineWidth',1);
plot(0,0,'b*','LineWidth',3,'HandleVisibility','off');
legend('Workspace','Maximum x-y range','Walking x range');