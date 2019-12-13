% Parameters
% Area				% [mm^2] Total area of solar panels

%Outputs
% Watts_produced	% [W] Watt produced by solar panels
function [Watts_produced] = solarEnergy(Area)
	averageWattsPerArea = 130.78; % [W/m^2]
	Watts_produced = averageWattsPerArea * Area/(1000^2);
	

