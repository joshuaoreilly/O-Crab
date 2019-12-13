clc;clear;
%% IMPORT DATA
motor_specs = importdata('MotorSpecs.csv',',',1);
% Starts with largest denominator first, so must flip
data_flipped = flipud(motor_specs.data);

%% GENERATED FUNCTIONS FOR PARAMETERS
% Col 2 = torque (mNm)
% Col 3 = Power (W)
% Col 4 = RPM (rpm)
% Col 5 = Current (A)
% Col 6 = Motor resistance (Ohms)
% Col 7 = Torque constant (mNm/A)
% Col 8 = Poles (#)
% Col 9 = Voltage (V)
% Col 10 = Mass (g)
% Col 11 = Rotor inertia (gcm^2)
% Col 12 = Outer Diameter (mm)
% Col 13 = Thickness without shaft (mm)
% Col 14 = Mounting Diameter (mm)
% Col 15 = Screw diameter (M--)
% Col 16 = Screw depth (mm)
% Col 17 = Maximum efficiency (fraction)

functions= zeros(size(motor_specs.data,2),2);
for i=1:1:size(motor_specs.data,2)
    P = polyfit(data_flipped(:,1),data_flipped(:,i),1);
    functions(i,1) = P(1); functions(i,2) = P(2);
end

%% DATA STORAGE
T = table(functions(:,1),functions(:,2),'VariableNames',{'Poly1','Poly2'},'RowNames',motor_specs.colheaders');
writetable(T,'motor_spec_functions.csv','WriteRowNames',true)

%% PLOTTING
% This is optional and solely for illustrative purposed

torque = data_flipped(:,1);
for i=1:1:size(motor_specs.data,2)
    figure(i)
    hold on
    plot(torque,data_flipped(:,i),'o');
    line([0,1500],[functions(i,1)*0+functions(i,2), functions(i,1)*1500+functions(i,2)],'Color','red');
    xlabel('Torque (mNm)');
    ylabel(motor_specs.colheaders(i));
    title(strcat(motor_specs.colheaders(i),' as a function of torque'));
    legend('Actual values', 'Linear Approximation');
end
