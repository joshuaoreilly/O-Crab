function [t_head,d_head,t_nut,d_nut,t_washer,od_washer,id_washer] = fasteners_general(d)
	% Functions extracted using polyfit(x,y,1)
	% Bolt dimensions taken from McMaster Grade 8.8 metric bolts
	% Nuts dimensions following ISO 4032, taken from: https://www.amesweb.info/Fasteners/Nut/Metric-Hex-Nut-Sizes-Dimensions-Chart.aspx
	
	%% INPUTS
	% d 		= bolt diameter [mm]
	
	%% OUTPUTS
	% t_head 	= thickness of head [mm]
	% d_head 	= diameter of head [mm]
	% t_nut 	= thickness of nut [mm]
	% d_nut 	= diameter of nut [mm]
	% t_washer 	= thickness of washer [mm]
	% od_washer = outer diameter of washer [mm]
	% id_washer = inner diameter of washer [mm]
	
	t_head = 0.60433*d + 0.39;
	d_head = 1.5617*d + 0.5761;
	t_nut = 0.8584*d - 0.0455;
	d_nut = 1.5045*d + 0.9042;
	t_washer = 0.2254*d - 0.1096;
	od_washer = 1.8473*d + 1.2575;
	%id_washer = 1.038*d + 0.1222; We'll simplify by just using d
	id_washer = d;
end