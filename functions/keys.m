% Parameters
% D 				[mm] Large Diameter of component
% Length_component	[mm] Length of component
% Torque 			[Nmm] Torque on the component

% Outputs
% key_width			[mm] Width of key
% key_height 		[mm] Height of key
function[key_width, key_height, worked]= keys(D, Torque, Length_component, name)
m_Sy = 205; %	[MPa] Yield Strength
%% Dimensions
worked = true;
key_width = D/4;
key_height = D/3;
length_shear = (8*Torque)/(0.58*m_Sy*D^2);
if (Length_component <  length_shear)
    %disp("Key Too Short") % Warning that the key is too short
	worked = false;
end
