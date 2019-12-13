function[] = main(litterWeight, BoxArea, x_reach, y_reach)

%% Assumed Constant Forever
runTimeDays =1; % [Days]
armWeight = 6; % [kg]
electronicsWeight = 0.5; %[kg]
t_bearing = 12; %[mm]
L3 = 7.5+5; % [mm]
t_plate = 10; % [mm]
Spring_free_angle_h = 180; % [deg]
Spring_free_angle_k = 180; % [deg]

%% Estimated first
BoxArea = BoxArea*(10^3)/150; % Convert to mm^3
TopArea = 0.5*1000^2; % Area of solar cells
D_knee_shaft = 21.5; % Outer diameter Knee Shaft
D_kneeHip_shaft = 21.5; % Outer diameter Hip Knee Shaft
Dmax_h = 500; % Max hip diameter
Dmin_h = 25; % Min hip diameter
Dmax_k = 500; % Diametre Hd
Dmin_k = 1; % Spacer
M =20 + litterWeight; % Total Robot Weight
M_old = 0; % Previous estimated robot weight

% Main Iteration Cycle
while(abs(M-M_old)>1) % Loops until the change in weight it less than 1 kg
    
    %% Length and Angles
    Leg_Object = Leg(x_reach,y_reach);
    %% Normal Force
    Force_Object = Forces(M, Leg_Object);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% Belt %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    belt_System = Belt_System(Force_Object.Torque_hipKnee*1000);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% Spring %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Set Max Torque at Joints
    Mmax_h = Force_Object.Torque_hip*1000;
    Mmin_h = Force_Object.Torque_hip_min*1000;
    Mmax_k = Force_Object.Torque_hipKnee*1000;
    Mmin_k = Force_Object.Torque_hipKnee_min*1000;
    
	%Set Max and Min angle
    MaxTheta_h = Leg_Object.Theta;
    MinTheta_h = Leg_Object.Theta_min;
    MaxTheta_k = Leg_Object.Psy_relative;
    MinTheta_k = Leg_Object.Psy_relative_min;
      
	%Calculate the spring
    spring_Torsion_Hip = Spring_Torsion_Hip(Leg_Object,Mmax_h,Mmin_h,Dmin_h,Dmax_h,MaxTheta_h,MinTheta_h,Spring_free_angle_h);
    spring_Torsion_Knee = Spring_Torsion_Knee(Leg_Object,Mmax_k,Mmin_k,Dmin_k,Dmax_k,MaxTheta_k,MinTheta_k,Spring_free_angle_k);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%   Shafts  %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % KneeHip
    shaft_KneeHip = Shaft_KneeHip(belt_System.T_tight, belt_System.T_slack, Force_Object.Torque_hipKnee*1000, t_bearing, spring_Torsion_Knee.L, L3, belt_System.b_width);
    
    % Knee
    shaft_Knee = Shaft_Knee(Force_Object,Leg_Object, belt_System.T_tight, belt_System.T_slack,spring_Torsion_Knee.L,belt_System.b_width, shaft_KneeHip.L_mid,t_bearing);
    
    % Hip
    shaft_Hip = Shaft_Hip(Force_Object,Leg_Object, spring_Torsion_Hip.L, L3, t_plate,t_bearing,shaft_KneeHip.L_mid,spring_Torsion_Hip.L);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%   Tibia  %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Tibia and components
    tibiaTube = TibiaTube(Force_Object, Leg_Object, belt_System.Pulley_Belt_Total_Dia);
    footCap = FootCap(tibiaTube.d,tibiaTube.D);
    footRod = FootRod(tibiaTube.d,tibiaTube.D);
    footSilicone = FootSilicone(tibiaTube.d);
    tibiaPulleyHolder = TibiaPulleyHolder(shaft_Knee, tibiaTube.D, belt_System.Pulley_Belt_Total_Dia);
    tibiaPulleyHolder = tibiaPulleyHolder.calculateBolts(Leg_Object.R, belt_System.Pulley_Inner_Dia, belt_System.b_width, 10, Force_Object.FF, Force_Object.FN);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% Harmonic Drive %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get torques and angles, anglesd, anglesdd over walking cycle
    [max_torque_theta,max_torque_phi,max_thetad,max_phid,theta, phi,thetad, phid,thetadd, phidd,torque_theta,torque_phi] = Torques_Angles(Leg_Object, Force_Object, spring_Torsion_Hip.k, spring_Torsion_Knee.k, spring_Torsion_Hip.correction_angle, spring_Torsion_Knee.correction_angle);
    % Get harmonic drive specs
    HD_hip = Harmonic_Drive(max_torque_theta,'Hip');
    HD_knee = Harmonic_Drive(max_torque_phi,'Knee');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%   Pulley  %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pulley_Exterior = Pulley_Exterior(belt_System,shaft_Knee.D_big);
    pulley_Interior = Pulley_Interior(belt_System,shaft_KneeHip.D_big);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%   Shaft Components  %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % KneeHip Shaft Components
    pulley_Exterior = pulley_Exterior.setBolts(tibiaPulleyHolder);
    bearing_KneeHip = Bearing_KneeHip(shaft_KneeHip.d_small);
    key_KneeHip_Pulley = Key_KneeHip_Pulley(shaft_KneeHip);
    pulley_Interior = pulley_Interior.setKeys(key_KneeHip_Pulley);
    key_KneeHip_Hub = Key_KneeHip_Hub(shaft_KneeHip);
    spacer_KneeHip = Spacer_KneeHip(shaft_KneeHip,spring_Torsion_Knee.L,spring_Torsion_Knee.Di,fasteners_general(pulley_Interior.d_bolts));
    
    % Knee Shaft Components
    bearing_Knee = Bearing_Knee(shaft_Knee.d_small);
    spacer_Knee = Spacer_Knee(shaft_Knee, belt_System.b_width);
    
    % Hip Shaft Components
    bearing_Hip = Bearing_Hip(shaft_Hip.d_small);
    key_Hip_Plates = Key_Hip_Plates(shaft_Hip);
    key_Hip_Collar = Key_Hip_Collar(shaft_Hip);
    spacer_Hip_Mid = Spacer_Hip_Mid(shaft_Hip.D_big, shaft_KneeHip.L_mid);
    spacer_Hip_Spring = Spacer_Hip_Spring(shaft_Hip.D_big, spring_Torsion_Hip.L,spring_Torsion_Hip.Di);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Loop Variables
    D_knee_shaft = shaft_Knee.D_big;
    D_kneeHip_shaft = shaft_KneeHip.D_big;
    
    Dmin_h = spacer_Hip_Spring.D_shafthip +9;
    Dmin_k = spacer_KneeHip.D_shafthipknee +9; %Spacer
    Dmax_h = max([HD_hip.spline_outer_diameter,belt_System.Pulley_Belt_Total_Dia]);
    Dmax_k = max([HD_knee.spline_outer_diameter,belt_System.Pulley_Belt_Total_Dia]);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%   Motor  %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get maximum torque and angular velocity experienced by motor
    [max_torque_theta_motor,max_thetad_motor] = HD_hip.getInputs(max_torque_theta,max_thetad);
    [max_torque_phi_motor,max_phid_motor] = HD_knee.getInputs(max_torque_phi,max_phid);
    
    % Get motor specs
    motor_hip = Motor(max_torque_theta_motor,HD_hip,'Hip');
    motor_knee = Motor(max_torque_phi_motor,HD_knee,'Knee');
    
    % Get average current draw of robot
    [current_consumed,walking_speed] = Power_Consumption(Leg_Object,HD_hip,HD_knee,motor_hip,motor_knee,theta,phi,thetad,phid,torque_theta,torque_phi);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% Battery %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get battery specs
    battery = Battery(runTimeDays,10,solarEnergy(TopArea),current_consumed);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% Adpaters %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get knee adapter
    adapter_knee = Adapter_Knee(HD_knee,motor_knee,27.5,belt_System.Pulley_Belt_Total_Dia);
    
    % Get hip brackets
    hip_bracket = Hip_Bracket(HD_hip,adapter_knee,Leg_Object,(shaft_KneeHip.L_mid + 2*2 + 2*10 +2*spring_Torsion_Hip.L+2*2),(shaft_Hip.d_small +2*2),belt_System.Pulley_Belt_Total_Dia,Force_Object.FF,Force_Object.ff,Force_Object.FN); % 2 mm bushing diameter
    
    % Get hip adapter
    adapter_hip = Adapter_Hip(HD_hip,motor_hip,hip_bracket);
    
    % Get hip base
    hip_base = Hip_Base(HD_hip,hip_bracket,(shaft_KneeHip.L_mid + 2*2 + 2*10 +2*spring_Torsion_Hip.L+2*2),27.5);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% Plates %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    plates_Hip_1 = Plates_Hip_1(shaft_Knee.d_small,shaft_Hip.D_big,shaft_KneeHip,belt_System.Pulley_Belt_Total_Dia,Leg_Object.r1,hip_bracket.distance_between_shafts,adapter_knee,key_Hip_Plates,spring_Torsion_Hip,spring_Torsion_Knee);
    plates_Hip_2 = Plates_Hip_2(shaft_Knee.d_small,shaft_Hip.D_big,shaft_KneeHip,belt_System.Pulley_Belt_Total_Dia,Leg_Object.r1,hip_bracket.distance_between_shafts,adapter_knee,key_Hip_Plates,spring_Torsion_Hip,spring_Torsion_Knee);
    plates_KneeHip = Plates_KneeHip(shaft_KneeHip.D_big,pulley_Interior.d_bolts,pulley_Interior.L_bolts,spring_Torsion_Knee.bigD,spring_Torsion_Knee.smalld);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Other %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Collar
    collar_Hip = Collar_Hip(shaft_Hip.d_small, key_Hip_Collar,HD_hip.flex_bolt_diameter,HD_hip.flex_mounting_diameter,HD_hip.flex_num_bolts);
    collar_KneeHip = Collar_KneeHip(shaft_KneeHip.d_small, key_KneeHip_Hub,HD_knee.flex_bolt_diameter,HD_knee.flex_mounting_diameter,HD_knee.flex_num_bolts);
    
    % Re calculate object dimensions
    belt_System = belt_System.setBeltDimensions(Leg_Object.r1,hip_bracket.distance_between_shafts);
    timingBelt = TimingBelt(belt_System);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Chassis %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    chassis = Chassis(shaft_KneeHip,spring_Torsion_Hip,plates_Hip_1,BoxArea,hip_base,hip_bracket,motor_hip,HD_hip,belt_System);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Bellow %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bellow = Bellow(plates_Hip_1,chassis,tibiaPulleyHolder);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% Weight %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M_old = M; % Set approximated as old weight calculated
    M = 0; % Reset approximated weight
    
    % Tibia
    M = M + tibiaTube.m2 + tibiaTube.m3 + tibiaPulleyHolder.mass;
    
    % Shaft
    M = M + shaft_KneeHip.mass + shaft_Knee.mass + shaft_Hip.mass;
    
    % Brackets
    M = M + hip_bracket.mass*2 + hip_base.mass + adapter_hip.mass;
    
    % Motor
    M = M + motor_hip.mass + motor_knee.mass;
    
    % HD
    M = M + HD_hip.mass + HD_knee.mass;
    
    % Battery
    M = M*5 + battery.mass;
    
    % Total
    M = M + litterWeight + armWeight + electronicsWeight + chassis.mass;
    TopArea = chassis.area;
end


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Print %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% KneeHip %%%%%%%%%%
shaft_KneeHip.printTXT();
bearing_KneeHip.printTXT();
key_KneeHip_Pulley.printTXT();
key_KneeHip_Hub.printTXT();
spacer_KneeHip.printTXT();
collar_KneeHip.printTXT();
plates_KneeHip.printTXT();

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Knee %%%%%%%%%%
shaft_Knee.printTXT();
bearing_Knee.printTXT();
spacer_Knee.printTXT();

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Hip %%%%%%%%%%
shaft_Hip.printTXT();
bearing_Hip.printTXT();
key_Hip_Plates.printTXT();
key_Hip_Collar.printTXT();
spacer_Hip_Mid.printTXT();
spacer_Hip_Spring.printTXT();
collar_Hip.printTXT();

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Limb %%%%%%%%%%
tibiaTube.printTXT();
tibiaPulleyHolder.printTXT();
footCap.printTXT();
footRod.printTXT();
footSilicone.printTXT();

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Springs %%%%%%%%%%
spring_Torsion_Hip.printTXT();
spring_Torsion_Knee.printTXT();

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Pulley %%%%%%%%%%
pulley_Exterior.printTXT();
pulley_Interior.printTXT();

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Plates %%%%%%%%%%
plates_Hip_1.printTXT();
plates_Hip_2.printTXT();

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Josh %%%%%%%%%%
HD_hip.printTXT();
HD_knee.printTXT();
motor_hip.printTXT();
motor_knee.printTXT();
battery.printTXT();
adapter_knee.printTXT(HD_knee,motor_knee);
hip_bracket.printTXT();
adapter_hip.printTXT(HD_hip,motor_hip);
hip_base.printTXT(HD_hip);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Other %%%%%%%%%%%%%%%%
timingBelt.printTXT();
chassis.printTXT();
bellow.printTXT();





%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Output %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(not(shaft_Hip.worked_keyplates))
    disp ("Hip shaft plate keys insufficiently long")
end
if(not(shaft_Hip.worked_keyhub))
    disp ("Hip shaft hub keys insufficiently long")
end
if(not(shaft_KneeHip.worked_keypulley))
    disp ("Knee Hip shaft pulley keys insufficiently long")
end
if(not(shaft_KneeHip.worked_keyhub))
    disp ("Knee Hip shaft hub keys insufficiently long")
end

disp(['Number of Solar Cells: ', num2str(floor(chassis.area/(125^2)))])

disp(['Run Hour per Day: ', num2str(battery.running_hours_per_day), ' h'])

disp(['Walking Speed: ', num2str(Leg_Object.ed), ' mm/s'])

disp(['Robot Total Weight: ', num2str(M) , ' kg'])

disp("Calculations Complete, Solid Work can now be updated")
end
