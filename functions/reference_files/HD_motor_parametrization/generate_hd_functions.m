clc;clear;
%% IMPORT DATA

hd_specs = importdata('HDSpecs.csv',',',1);
% Starts with largest denominator first, so must flip
data = flipud(hd_specs.data);

%% GENERATE LINEAR FUNCTIONS FOR PARAMETERS
% Col 1 = size 
% Col 2 = torque (Nm)
% Col 3 = repeat torque limit (Nm)
% Col 4 = average input speed limit (rpm)
% Col 5 = moment of inertia I (x10^-4 kgm^2)
% Col 6 = moment of inertia J (x10^-5 kgfms^2)
% Col 7 = backdriving torque (Nm)
% Col 8 = starting torque (Nm)
% Col 9 = mass (kg)
% Col 10 = spline ring outer diameter (mm)
% Col 11 = total thickness (mm)
% Col 12 = spline ring thickness (mm)
% Col 13 = spline ring mounting diameter (mm)
% Col 14 = spline ring number of bolts
% Col 15 = spline ring bolt diameter (mm)
% Col 16 = flexspline outer diameter (mm)
% Col 17 = flexspline mounting diameter (mm)
% Col 18 = flexspline number of bolts
% Col 19 = flexspline bolt diameter (mm)
% Col 20 = bearing mounting diameter (mm)
% Col 21 = bearing number of bolts (mm)
% Col 22 = bearing bolt diameter (mm)

functions = zeros(size(data,2),2);
for i=1:1:size(data,2)
    P = polyfit(data(:,2),data(:,i),1);
    functions(i,1) = P(1);
    functions(i,2) = P(2);
end

%% DATA STORAGE
T = table(functions(:,1),functions(:,2),'VariableNames',{'Poly1','Poly2'},'RowNames',hd_specs.colheaders');
writetable(T,'hd_spec_functions.csv','WriteRowNames',true)

%% PLOTTING
% This is optional and solely for illustrative purposed

torque = data(:,2);
for i=1:1:size(hd_specs.data,2)
    figure(i)
    hold on
    plot(torque,data(:,i),'o');
    line([0,350],[functions(i,1)*0+functions(i,2), functions(i,1)*350+functions(i,2)],'Color','red');
    xlabel('Torque (mNm)');
    ylabel(hd_specs.colheaders(i));
    title(strcat(hd_specs.colheaders(i),' as a function of torque'));
    legend('Actual values', 'Linear Approximation');
end
