classdef Chassis
    properties
        Hip_HD_D                % [mm]   Harmonic Drive outer diameter
        Hip_plate_width         % [mm]   Hip plates total width
        Hip_plate_height        % [mm]   Hip plates heigth
        theta_max = 28;         % [deg]  Highest angular position of thigh
        t_plate                 % [mm]   Thickness of mounting plate
        L_bracket_hole          % [mm]   L-bracket hole position from plate 
        BoxArea                 % [mm^2] Litter box surface area
        Hip_shaft_shortside_L   % [mm]   Shaft length from pulley to end
        Hip_plate_L             % [mm]   Dist b/w hip shaft & end of plate
        Total_hip_L             % [mm]   Total hip plates length
        Chassis_width           % [mm]   Chassis outer width
        Chassis_depth           % [mm]   Chassis outer depth
        B_D                     % [mm]   Depth of plate for WR2B
        B_W                     % [mm]   Width of plate for WR2B
        Chassis_height          % [mm]   Chassis height
        t_wall                  % [mm]   Chassis wall thickness
        B_t_plate               % [mm]   Thickness of plate for WR2B
        D_i                     % [mm]   Inner diameter of leg hole
        Hole_vert_P             % [mm]   Leg hole vertical position
        Leg_spacing             % [mm]   Distance between leg mid planes
        Hole_front_horiz_P      % [mm]   Front leg holes horiz position
        l_flange                % [mm]   Length of flange to mount bellow
        Leg_spacing_half        % [mm]   Half the distance between legs
        fillet_r                % [mm]   Inner chassis fillet radius
        fillet_r_outside        % [mm]   Outer chassis fillet radius
        Lip_offset              % [mm]   Lip offset distance from wall
        Lip_inner_r             % [mm]   Lip inner fillet radius
        Lip_outer_r             % [mm]   Lip outer fillet radius
        Lip_width               % [mm]   Lip width
        L                       % [mm]   Variable used in Analysis Sec4.9.6
        mass                    % [mm]   Approximated mass of chassis
        area                    % [mm]   Approximated chassis cover area
        L_hipknee               % [mm]   Length between hip and knee shaft
        R_pulley_max            % [mm]   Maximum pulley radius
    end
    
    methods
        
        % Chassis Constructor
        function obj = Chassis(shaft_HipKnee,spring_Torsion_Hip,plates_Hip_1,BoxArea,hip_base,hip_bracket,motor_hip,HD_hip,belt_System)
            obj = obj.setParameters(shaft_HipKnee,spring_Torsion_Hip,plates_Hip_1,BoxArea,hip_base,hip_bracket,motor_hip,HD_hip,belt_System);
        end
        
        % Properties and parameters calculation function
        function obj = setParameters(obj,shaft_HipKnee,spring_Torsion_Hip,plates_Hip_1,BoxArea,hip_base,hip_bracket,motor_hip,HD_hip,belt_System)
            obj.Hip_plate_width = shaft_HipKnee.L_mid+2*2+2*10;
            obj.Hip_plate_height = plates_Hip_1.height;
            obj.Hip_shaft_shortside_L = (shaft_HipKnee.L_mid+2*2)/2+10+spring_Torsion_Hip.L+2+10;
            obj.Hip_plate_L = plates_Hip_1.L_hipknee + plates_Hip_1.L_end;
            obj.L_hipknee = plates_Hip_1.L_hipknee;
            obj.R_pulley_max = belt_System.Pulley_Belt_Total_Dia/2;
            obj.BoxArea = BoxArea;
            obj.Hip_HD_D = HD_hip.spline_outer_diameter;
            obj.t_plate = hip_base.thickness;
            obj.L_bracket_hole = hip_bracket.height + hip_base.thickness;
            obj.Total_hip_L = hip_base.distance_between_hip_bracket_bolts + hip_base.hip_bracket_bolt_to_adapter_bolt + (hip_base.bolt_diameter+(hip_base.bolt_ell*2)) + hip_bracket.thickness + motor_hip.adapter_thickness + motor_hip.thickness;
            obj = obj.calculate();
        end
        
        function obj = calculate(obj)
            %% Constants
            obj.fillet_r = 5;
            obj.t_wall = 5;
            obj.B_t_plate = 2*obj.t_wall;
            obj.fillet_r_outside = obj.fillet_r + obj.t_wall;
            obj.l_flange = 12;
            spacing = 5;
            obj.Lip_offset = obj.t_wall/2;
            obj.Lip_inner_r = obj.fillet_r + obj.Lip_offset;
            obj.Lip_width = 2*obj.t_wall - 2*obj.Lip_offset;
            obj.Lip_outer_r = obj.Lip_inner_r + obj.Lip_width;
            
            %% Minimum Leg Hole Dimensions
            obj.L = obj.Hip_HD_D/2 + obj.fillet_r + obj.t_wall + obj.l_flange;
            H = obj.L*tand(obj.theta_max)+obj.Hip_plate_height/(2*cosd(obj.theta_max));
            R_i_min = sqrt(H^2+(obj.Hip_plate_width/2)^2);
            R_i = R_i_min + 2.5; % for precautions
            obj.D_i = 2*R_i;
            D_o = obj.D_i + 2*obj.t_wall;
            
            %% Litter Box Dimensions
            BoxRatio = 7/6;
            Box_width = sqrt(obj.BoxArea/BoxRatio);
            Box_depth = BoxRatio*Box_width;
            ExtraSpaceRatio = 1.1;
            Box_W = Box_width*ExtraSpaceRatio;
            Box_D = Box_depth*ExtraSpaceRatio;
            Hand_space = 50;
            Arm_space = 120;
            obj.B_W = Box_W;
            obj.B_D = Box_D + Hand_space + Arm_space;
            
            %% Other Chassis Dimensions
            
            obj.Hole_vert_P          = obj.t_wall + obj.L_bracket_hole;
            Hole_front_horiz_P1      = obj.B_W/2 + obj.t_wall + obj.Hip_shaft_shortside_L +1;
            Hole_front_horiz_P2      = obj.B_W/2 + obj.t_wall + obj.fillet_r + D_o/2 +1;
            obj.Hole_front_horiz_P   = max(Hole_front_horiz_P1,Hole_front_horiz_P2);
            
            Motor_side_hip_L      = obj.Total_hip_L - obj.Hip_shaft_shortside_L;
            obj.Leg_spacing       = 2*Motor_side_hip_L + spacing;
            obj.Leg_spacing_half  = obj.Leg_spacing/2;
            
            Chassis_back_width1   = 2*obj.Leg_spacing + 2*obj.Hip_shaft_shortside_L + 2*obj.t_wall + 2*obj.fillet_r + 2*spacing;
            Chassis_back_width2   = 2*obj.Leg_spacing + D_o + 2*obj.t_wall + 2*obj.fillet_r;
            Chassis_front_width1  = 2*obj.Total_hip_L + 4*obj.t_wall + obj.B_W + 4*obj.fillet_r;
            Chassis_front_width2  = 2*(obj.Total_hip_L - Motor_side_hip_L) + 4*obj.t_wall + obj.B_W + 4*obj.fillet_r + D_o;
            obj.Chassis_width     = max([Chassis_back_width1,Chassis_back_width2,Chassis_front_width1,Chassis_front_width2]);
            
            Chassis_side_depth    = 2*(obj.L - obj.l_flange + obj.Hip_plate_L) + spacing;
            Chassis_center_depth1 = (obj.L - obj.l_flange + obj.Hip_plate_L + obj.t_wall) + 2*spacing + obj.B_D;
            Chassis_center_depth2 = (obj.L - obj.l_flange + obj.L_hipknee + obj.R_pulley_max + obj.t_wall) + 2*spacing + obj.B_D;
            obj.Chassis_depth     = max([Chassis_side_depth,Chassis_center_depth1,Chassis_center_depth2]);
            
            Chassis_height1       = obj.Hole_vert_P + D_o/2 + 3*spacing;
            Chassis_height2       = obj.t_wall + obj.fillet_r + D_o + 3*spacing;
            obj.Chassis_height    = max(Chassis_height1,Chassis_height2);
            
            % Chassis mass
            material_density = 1.18E-6; % [kg/mm^3] for acrylic
            V_o = obj.Chassis_width * obj.Chassis_depth * obj.Chassis_height;
            V_i = (obj.Chassis_width - 2*obj.t_wall) * (obj.Chassis_depth - 2*obj.t_wall) * (obj.Chassis_height - 2*obj.t_wall);
            obj.mass = (V_o - V_i) * material_density;
            
            % Solar cell available area
            obj.area = (obj.Chassis_width * obj.Chassis_depth) - (Box_W * Box_D);
            
        end
        
		% Print function to TXT file
        function printTXT(obj)
            filePath = '..\Solidworks\Equations\Chassis.txt';
            fid = fopen(filePath,'wt');
            fprintf(fid,strcat('"Width"=',num2str(obj.Chassis_width),'\n'));
            fprintf(fid,strcat('"Depth"=',num2str(obj.Chassis_depth),'\n'));
            fprintf(fid,strcat('"2B_depth"=',num2str(obj.B_D),'\n'));
            fprintf(fid,strcat('"2B_width"=',num2str(obj.B_W),'\n'));
            fprintf(fid,strcat('"Chassis_height"=',num2str(obj.Chassis_height),'\n'));
            fprintf(fid,strcat('"Wall_thickness"=',num2str(obj.t_wall),'\n'));
            fprintf(fid,strcat('"2B_plate_thickness"=',num2str(obj.B_t_plate),'\n'));
            fprintf(fid,strcat('"Leg_hole_inner_D"=',num2str(obj.D_i),'\n'));
            fprintf(fid,strcat('"Leg_hole_vertical_P"=',num2str(obj.Hole_vert_P),'\n'));
            fprintf(fid,strcat('"Leg_spacing"=',num2str(obj.Leg_spacing),'\n'));
            fprintf(fid,strcat('"Front_leg_horizontal_P"=',num2str(obj.Hole_front_horiz_P),'\n'));
            fprintf(fid,strcat('"Flange_length"=',num2str(obj.l_flange),'\n'));
            fprintf(fid,strcat('"Flange_thickness"=',num2str(obj.t_wall),'\n'));
            fprintf(fid,strcat('"Half_leg_spacing"=',num2str(obj.Leg_spacing_half),'\n'));
            fprintf(fid,strcat('"fillet_r"=',num2str(obj.fillet_r),'\n'));
            fprintf(fid,strcat('"fillet_r_outside"=',num2str(obj.fillet_r_outside),'\n'));
            fprintf(fid,strcat('"Lip_offset"=',num2str(obj.Lip_offset),'\n'));
            fprintf(fid,strcat('"Lip_inner_r"=',num2str(obj.Lip_inner_r),'\n'));
            fprintf(fid,strcat('"Lip_outer_r"=',num2str(obj.Lip_outer_r),'\n'));
            fprintf(fid,strcat('"Lip_width"=',num2str(obj.Lip_width),'\n'));
            fclose(fid);
        end
    end
end