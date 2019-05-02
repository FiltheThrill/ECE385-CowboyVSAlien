	//-------------------------------------------------------------------------
	//    Color_Mapper.sv                                                    --
	//    Stephen Kempf                                                      --
	//    3-1-06                                                             --
	//                                                                       --
	//    Modified by David Kesler  07-16-2008                               --
	//    Translated by Joe Meng    07-07-2013                               --
	//    Modified by Po-Han Huang  10-06-2017                               --
	//                                                                       --
	//    Fall 2017 Distribution                                             --
	//                                                                       --
	//    For use with ECE 385 Lab 8                                         --
	//    University of Illinois ECE Department                              --
	//-------------------------------------------------------------------------

	// color_mapper: Decide which color to be output to VGA for each pixel.
	module  color_mapper ( input start, GGA, GGC, AVC,  
								  input [1:0] hp,
								  input [0:42][0:26][0:3] cowboy,
								  input [0:11][0:57][0:3] platform,
								  input [0:12][0:57][0:3] ground,
								  input [0:57][0:57][0:3] alien,
								  input [0:7][0:3][0:3] laser,
								  input [0:41][0:26][0:3] cactus,
								  input [0:24][0:68][0:3] UFO,
								  input [0:39][0:79][0:3] cloud,
								  input [0:75][0:493][0:0] cowboy_txt,
								  input [0:75][0:111][0:0] vs,
								  input [0:75][0:285][0:0] alien_txt,
								  input [0:75][0:266][0:0] win,
								  input [0:151][0:106][0:2] saloons,
								  input [0:24][0:24][0:1] power,
								  input [0:34][0:34][0:3] spike,
								  input        [9:0] DrawX, DrawY, 
															CowboyX, CowboyY,
															SpikeX, SpikeY,
															PlatformX, PlatformY,
															Platform1X, Platform1Y,
															Platform2X, Platform2Y,
															Platform3X, Platform3Y,
															AlienX, AlienY,
															LaserX, LaserY,
															UFOX, UFOY,
															Start0X, Start0Y,
															Start1X, Start1Y,
															Start2X, Start2Y,
															End0X, End0Y,
															End1X, End1Y,
															PowerupX, PowerupY,
															SaloonX, SaloonY,
															CloudX, CloudY,
															Cactus0X, Cactus0Y,
															Cactus1X, Cactus1Y,
															Cactus2X, Cactus2Y,
															Cactus3X, Cactus3Y,
															GroundX0, GroundY0,
															GroundX1, GroundY1,
															GroundX2, GroundY2,
															GroundX3, GroundY3,
															GroundX4, GroundY4,
															GroundX5, GroundY5,
															GroundX6, GroundY6,
															GroundX7, GroundY7,
															GroundX8, GroundY8,
															GroundX9, GroundY9,
															GroundX10, GroundY10,
															GroundX11, GroundY11,
															GroundX12, GroundY12,
															GroundX13, GroundY13,
															GroundX14, GroundY14,
															GroundX15, GroundY15,
															GroundX16, GroundY16,
															GroundX17, GroundY17,// Current pixel coordinates
								  output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
								);
		 logic start0_pix, start1_pix, start2_pix, end0_pix, end1_pix;
		 logic [2:0] saloon_pix;
		 logic [1:0] power_pix;
		 logic [7:0] Red, Green, Blue;
		 logic [3:0] cowboy_pix, platform_pix, platform1_pix, platform2_pix, platform3_pix, alien_pix, laser_pix, 
						 ground0_pix, ground1_pix, ground2_pix, cactus0_pix, cactus1_pix, cactus2_pix, cactus3_pix,
						 ground3_pix, ground4_pix, ground5_pix, ground6_pix, ground7_pix, ground8_pix, spike_pix,
						 ground9_pix, ground10_pix, ground11_pix, ground12_pix, UFO_pix, cloud_pix, 
						 ground13_pix, ground14_pix, ground15_pix, ground16_pix, ground17_pix;
		 // Output colors to VGA
		 assign VGA_R = Red;
		 assign VGA_G = Green;
		 assign VGA_B = Blue;
		 parameter [9:0] CowboyW = 10'd27;
		 parameter [9:0] CowboyH = 10'd43;
		 parameter [9:0] PlatformW = 10'd58;
		 parameter [9:0] PlatformH = 10'd12;
		 parameter [9:0] AlienH = 10'd58;
		 parameter [9:0] AlienW = 10'd58;
		 parameter [9:0] GroundH = 10'd15;
		 parameter [9:0] GroundW = 10'd58;
		 parameter [9:0] LaserH = 10'd8;
		 parameter [9:0] LaserW = 10'd4;
		 parameter [9:0] CactusH = 10'd41;
		 parameter [9:0] CactusW = 10'd27;
		 parameter [9:0] UFOH = 10'd25;
		 parameter [9:0] UFOW = 10'd71;
		 parameter [9:0] CloudH = 10'd40;
		 parameter [9:0] CloudW = 10'd80;
		 parameter [9:0] cowboy_txtW = 10'd494;
		 parameter [9:0] vsW = 10'd112;
		 parameter [9:0] alien_txtW = 10'd286;
		 parameter [9:0] txtH = 10'd76;
		 parameter [9:0] winW = 10'd267;
		 parameter [9:0] SaloonH = 10'd152;
		 parameter [9:0] SaloonW = 10'd107;
		 parameter [9:0] PowerupH = 10'd25;
		 parameter [9:0] PowerupW = 10'd25;
		 parameter [9:0] SpikeW = 10'd35;
		 parameter [9:0] SpikeH = 10'd35;
		 
		 
		 
		
		
		always_comb
			begin
				if(start == 1'b1)
					begin
						if((DrawX >= Start0X) && (DrawX <= (Start0X + cowboy_txtW)) && (DrawY >= Start0Y) && (DrawY <= (Start0Y + txtH)))
							begin
								start0_pix = cowboy_txt[DrawY-Start0Y][DrawX-Start0X];
							end
		 
						else 
							begin
								start0_pix = 1'b0;	  
							end		
					end
				else
					begin
						start0_pix = 1'b0;
					end
			end
		
		always_comb
			begin
				if(start == 1'b1)
					begin
						if((DrawX >= Start2X) && (DrawX <= (Start2X + alien_txtW)) && (DrawY >= Start2Y) && (DrawY <= (Start2Y + txtH)))
							begin
								start2_pix = alien_txt[DrawY-Start2Y][DrawX-Start2X];
							end
		 
						else 
							begin
								start2_pix = 1'b0;	  
							end		
					end
				else
					begin
						start2_pix = 1'b0;
					end
			end
			
			always_comb
			begin
				if(start == 1'b1)
					begin
						if((DrawX >= Start1X) && (DrawX <= (Start1X + vsW)) && (DrawY >= Start1Y) && (DrawY <= (Start1Y + txtH)))
							begin
								start1_pix = vs[DrawY-Start1Y][DrawX-Start1X];
							end
		 
						else 
							begin
								start1_pix = 1'b0;	  
							end		
					end
				else
					begin
						start1_pix = 1'b0;
					end
			end
		always_comb
		begin
			if(GGC == 1'b1)
				begin
					if((DrawX >= End0X) && (DrawX <= (End0X + cowboy_txtW)) && (DrawY >= End0Y) && (DrawY <= (End0Y + txtH)))
						begin
							end0_pix = cowboy_txt[DrawY-End0Y][DrawX-End0X];
						end
					else
						begin
							end0_pix = 0;
						end
						
				end
			else if(GGA == 1'b1)
				begin
					if((DrawX >= End0X) && (DrawX <= (End0X + cowboy_txtW)) && (DrawY >= End0Y) && (DrawY <= (End0Y + txtH)))
						begin
							end0_pix = alien_txt[DrawY-End0Y][DrawX-End0X];
						end
					else
						begin
							end0_pix = 0;
						end
				end
			else
				begin
					end0_pix = 0;
				end
		end
		
		always_comb
			begin
				if((GGC == 1'b1) || (GGA == 1'b1))
					begin
						if((DrawX >= End1X) && (DrawX <= (End1X + winW)) && (DrawY >= End1Y) && (DrawY <= (End1Y + txtH)))
							begin
								end1_pix = win[DrawY-End1Y][DrawX-End1X];
							end
						else
							begin
								end1_pix = 4'b0;
							end
					end
				else
					begin
						end1_pix = 4'b0;
					end
			end
		always_comb
			begin
				if((DrawX >= LaserX) && (DrawX <= (LaserX + LaserW)) && (DrawY >= LaserY) && (DrawY <= (LaserY + LaserH)))
					begin
						laser_pix = laser[DrawY-LaserY][DrawX-LaserX];
					end
		 
				else 
					begin
						laser_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= SpikeX) && (DrawX <= (SpikeX + SpikeW)) && (DrawY >= SpikeY) && (DrawY <= (SpikeY + SpikeH)))
					begin
						spike_pix = spike[DrawY-SpikeY][DrawX-SpikeX];
					end
		 
				else 
					begin
						spike_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= PowerupX) && (DrawX <= (PowerupX + PowerupW)) && (DrawY >= PowerupY) && (DrawY <= (PowerupY + PowerupH)))
					begin
						power_pix = power[DrawY-PowerupY][DrawX-PowerupX];
					end
		 
				else 
					begin
						power_pix = 4'b0;	  
					end		

			end 
				always_comb
			begin
				if((DrawX >= SaloonX) && (DrawX <= (SaloonX + SaloonW)) && (DrawY >= SaloonY) && (DrawY <= (SaloonY + SaloonH)))
					begin
						saloon_pix = saloons[DrawY-SaloonY][DrawX-SaloonX];
					end
		 
				else 
					begin
						saloon_pix = 3'b0;	  
					end		

			end 
			always_comb
			begin
				if((DrawX >= Cactus0X) && (DrawX <= (Cactus0X + CactusW)) && (DrawY >= Cactus0Y) && (DrawY <= (Cactus0Y + CactusH)))
					begin
						cactus0_pix = cactus[DrawY-Cactus0Y][DrawX-Cactus0X];
					end
		 
				else 
					begin
						cactus0_pix = 4'b0;	  
					end		

			end 
		
				always_comb
			begin
				if((DrawX >= Cactus1X) && (DrawX <= (Cactus1X + CactusW)) && (DrawY >= Cactus1Y) && (DrawY <= (Cactus1Y + CactusH)))
					begin
						cactus1_pix = cactus[DrawY-Cactus1Y][DrawX-Cactus1X];
					end
		 
				else 
					begin
						cactus1_pix = 4'b0;	  
					end		

			end 
			
					always_comb
			begin
				if((DrawX >= Cactus2X) && (DrawX <= (Cactus2X + CactusW)) && (DrawY >= Cactus2Y) && (DrawY <= (Cactus2Y + CactusH)))
					begin
						cactus2_pix = cactus[DrawY-Cactus2Y][DrawX-Cactus2X];
					end
		 
				else 
					begin
						cactus2_pix = 4'b0;	  
					end		

			end 
			
					always_comb
			begin
				if((DrawX >= Cactus3X) && (DrawX <= (Cactus3X + CactusW)) && (DrawY >= Cactus3Y) && (DrawY <= (Cactus3Y + CactusH)))
					begin
						cactus3_pix = cactus[DrawY-Cactus3Y][DrawX-Cactus3X];
					end
		 
				else 
					begin
						cactus3_pix = 4'b0;	  
					end		

			end 
			
		 always_comb
			begin
				if((DrawX >= CowboyX) && (DrawX <= (CowboyX + CowboyW)) && (DrawY >= CowboyY) && (DrawY <= (CowboyY + CowboyH)))
					begin
						cowboy_pix = cowboy[DrawY-CowboyY][DrawX-CowboyX];
					end
		 
				else 
					begin
						cowboy_pix = 4'b0;	  
					end		

			end 
			
		 always_comb
			begin
				if((DrawX >= AlienX) && (DrawX <= (AlienX + AlienW)) && (DrawY >= AlienY) && (DrawY <= (AlienY + AlienH)))
					begin
						alien_pix = alien[DrawY-AlienY][DrawX-AlienX];
					end
		 
				else 
					begin
						alien_pix = 4'b0;	  
					end		

			end 
		
		 always_comb
			begin
				if((DrawX >= GroundX0) && (DrawX <= (GroundX0 + GroundW)) && (DrawY >= GroundY0) && (DrawY <= (GroundY0 + GroundH)))
					begin
						ground0_pix = ground[DrawY-GroundY0][DrawX-GroundX0];
					end
		 
				else 
					begin
						ground0_pix = 4'b0;	  
					end		

			end 
		
		 always_comb
			begin
				if((DrawX >= GroundX1) && (DrawX <= (GroundX1 + GroundW)) && (DrawY >= GroundY1) && (DrawY <= (GroundY1 + GroundH)))
					begin
						ground1_pix = ground[DrawY-GroundY1][DrawX-GroundX1];
					end
		 
				else 
					begin
						ground1_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= GroundX2) && (DrawX <= (GroundX2 + GroundW)) && (DrawY >= GroundY2) && (DrawY <= (GroundY2 + GroundH)))
					begin
						ground2_pix = ground[DrawY-GroundY2][DrawX-GroundX2];
					end
		 
				else 
					begin
						ground2_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= GroundX3) && (DrawX <= (GroundX3 + GroundW)) && (DrawY >= GroundY3) && (DrawY <= (GroundY3 + GroundH)))
					begin
						ground3_pix = ground[DrawY-GroundY3][DrawX-GroundX3];
					end
		 
				else 
					begin
						ground3_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= GroundX4) && (DrawX <= (GroundX4 + GroundW)) && (DrawY >= GroundY4) && (DrawY <= (GroundY4 + GroundH)))
					begin
						ground4_pix = ground[DrawY-GroundY4][DrawX-GroundX4];
					end
		 
				else 
					begin
						ground4_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX5) && (DrawX <= (GroundX5 + GroundW)) && (DrawY >= GroundY5) && (DrawY <= (GroundY5 + GroundH)))
					begin
						ground5_pix = ground[DrawY-GroundY5][DrawX-GroundX5];
					end
		 
				else 
					begin
						ground5_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX6) && (DrawX <= (GroundX6 + GroundW)) && (DrawY >= GroundY6) && (DrawY <= (GroundY6 + GroundH)))
					begin
						ground6_pix = ground[DrawY-GroundY6][DrawX-GroundX6];
					end
		 
				else 
					begin
						ground6_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= GroundX7) && (DrawX <= (GroundX7 + GroundW)) && (DrawY >= GroundY7) && (DrawY <= (GroundY7 + GroundH)))
					begin
						ground7_pix = ground[DrawY-GroundY7][DrawX-GroundX7];
					end
		 
				else 
					begin
						ground7_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX8) && (DrawX <= (GroundX8 + GroundW)) && (DrawY >= GroundY8) && (DrawY <= (GroundY8 + GroundH)))
					begin
						ground8_pix = ground[DrawY-GroundY8][DrawX-GroundX8];
					end
		 
				else 
					begin
						ground8_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX9) && (DrawX <= (GroundX9 + GroundW)) && (DrawY >= GroundY9) && (DrawY <= (GroundY9 + GroundH)))
					begin
						ground9_pix = ground[DrawY-GroundY9][DrawX-GroundX9];
					end
		 
				else 
					begin
						ground9_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX10) && (DrawX <= (GroundX10 + GroundW)) && (DrawY >= GroundY10) && (DrawY <= (GroundY10 + GroundH)))
					begin
						ground10_pix = ground[DrawY-GroundY10][DrawX-GroundX10];
					end
		 
				else 
					begin
						ground10_pix = 4'b0;	  
					end		

			end 
	
		always_comb
			begin
				if((DrawX >= GroundX11) && (DrawX <= (GroundX11 + GroundW)) && (DrawY >= GroundY11) && (DrawY <= (GroundY11 + GroundH)))
					begin
						ground11_pix = ground[DrawY-GroundY11][DrawX-GroundX11];
					end
		 
				else 
					begin
						ground11_pix = 4'b0;	  
					end		

			end
			
		always_comb
			begin
				if((DrawX >= GroundX12) && (DrawX <= (GroundX12 + GroundW)) && (DrawY >= GroundY12) && (DrawY <= (GroundY12 + GroundH)))
					begin
						ground12_pix = ground[DrawY-GroundY12][DrawX-GroundX12];
					end
		 
				else 
					begin
						ground12_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX13) && (DrawX <= (GroundX13 + GroundW)) && (DrawY >= GroundY13) && (DrawY <= (GroundY13 + GroundH)))
					begin
						ground13_pix = ground[DrawY-GroundY13][DrawX-GroundX13];
					end
		 
				else 
					begin
						ground13_pix = 4'b0;	  
					end		

			end 
		
		always_comb
			begin
				if((DrawX >= GroundX14) && (DrawX <= (GroundX14 + GroundW)) && (DrawY >= GroundY14) && (DrawY <= (GroundY14 + GroundH)))
					begin
						ground14_pix = ground[DrawY-GroundY14][DrawX-GroundX14];
					end
		 
				else 
					begin
						ground14_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX15) && (DrawX <= (GroundX15 + GroundW)) && (DrawY >= GroundY15) && (DrawY <= (GroundY15 + GroundH)))
					begin
						ground15_pix = ground[DrawY-GroundY15][DrawX-GroundX15];
					end
		 
				else 
					begin
						ground15_pix = 4'b0;	  
					end		

			end 
			
		always_comb
			begin
				if((DrawX >= GroundX16) && (DrawX <= (GroundX16 + GroundW)) && (DrawY >= GroundY16) && (DrawY <= (GroundY16 + GroundH)))
					begin
						ground16_pix = ground[DrawY-GroundY16][DrawX-GroundX16];
					end
		 
				else 
					begin
						ground16_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= GroundX17) && (DrawX <= (GroundX17 + GroundW)) && (DrawY >= GroundY17) && (DrawY <= (GroundY17 + GroundH)))
					begin
						ground17_pix = ground[DrawY-GroundY17][DrawX-GroundX17];
					end
		 
				else 
					begin
						ground17_pix = 4'b0;	  
					end		

			end 
		always_comb
			begin
				if((DrawX >= PlatformX) && (DrawX <= (PlatformX + PlatformW)) && (DrawY >= PlatformY) && (DrawY <= (PlatformY + PlatformH)))
					begin
						platform_pix = platform[DrawY-PlatformY][DrawX-PlatformX];
					end
		 
				else 
					begin
						platform_pix = 4'b0;	  
					end		

			end
		always_comb
			begin
				if((DrawX >= Platform1X) && (DrawX <= (Platform1X + PlatformW)) && (DrawY >= Platform1Y) && (DrawY <= (Platform1Y + PlatformH)))
					begin
						platform1_pix = platform[DrawY-Platform1Y][DrawX-Platform1X];
					end
		 
				else 
					begin
						platform1_pix = 4'b0;	  
					end		
			end	
			
		always_comb
			begin
				if((DrawX >= Platform2X) && (DrawX <= (Platform2X + PlatformW)) && (DrawY >= Platform2Y) && (DrawY <= (Platform2Y + PlatformH)))
					begin
						platform2_pix = platform[DrawY-Platform2Y][DrawX-Platform2X];
					end
		 
				else 
					begin
						platform2_pix = 4'b0;	  
					end		
			end
			
		always_comb
			begin
				if((DrawX >= Platform3X) && (DrawX <= (Platform3X + PlatformW)) && (DrawY >= Platform3Y) && (DrawY <= (Platform3Y + PlatformH)))
					begin
						platform3_pix = platform[DrawY-Platform3Y][DrawX-Platform3X];
					end
		 
				else 
					begin
						platform3_pix = 4'b0;	  
					end		

			end
		always_comb
			begin
				if((DrawX >= UFOX) && (DrawX <= (UFOX + UFOW)) && (DrawY >= UFOY) && (DrawY <= (UFOY + UFOH)))
					begin
						UFO_pix = UFO[DrawY-UFOY][DrawX-UFOX];
					end
		 
				else 
					begin
						UFO_pix = 4'b0;	  
					end		

			end	
		
		always_comb
			begin
				if((DrawX >= CloudX) && (DrawX <= (CloudX + CloudW)) && (DrawY >= CloudY) && (DrawY <= (CloudY + CloudH)))
					begin
						cloud_pix = cloud[DrawY-CloudY][DrawX-CloudX];
					end
		 
				else 
					begin
						cloud_pix = 4'b0;	  
					end		

			end	
		 always_comb
			begin
				if((start0_pix == 1'b1) || (start1_pix == 1'b1) || (start2_pix == 1'b1))
				begin
					Red = 8'd0;
					Green = 8'd0;
					Blue= 8'd0;
				end
				else if((end0_pix == 1'b1) || (end1_pix == 1'b1))
				begin
					Red = 8'd0;
					Green = 8'd0;
					Blue= 8'd0;
				end
				else if(laser_pix == 4'b0001)
				begin
					Red = 8'd20;
					Green = 8'd255;
					Blue = 8'd43;
				end
				else if(laser_pix == 4'b0010)
				begin
					Red = 8'd0;
					Green = 8'd201;
					Blue = 8'd19;
				end
				else if(spike_pix == 4'b0001)
					begin
						Red = 8'd109;
						Green = 8'd109;
						Blue = 8'd109;
					end
				else if(spike_pix == 4'b0010)
					begin
						Red = 8'd44;
						Green = 8'd244;
						Blue = 8'd63;
					end
				else if(cowboy_pix == 4'b0001)
				begin
					Red = 8'd209;
					Green = 8'd147;
					Blue = 8'd73;
				end
			
				else if(cowboy_pix == 4'b0010)
				begin
					Red = 8'd168;
					Green = 8'd124;
					Blue = 8'd67;
				end
				
				else if(cowboy_pix == 4'b0011)
				begin
					Red = 8'd255;
					Green = 8'd199;
					Blue = 8'd45;
				end
				
				else if(cowboy_pix == 4'b0100)
				begin
					Red = 8'd209;
					Green = 8'd40;
					Blue = 8'd25;
				end
				
				else if(cowboy_pix == 4'b0101)
				begin
					Red = 8'd255;
					Green = 8'd206;
					Blue = 8'd160;
				end
				
				else if(cowboy_pix == 4'b0110)
				begin
					Red = 8'd255;
					Green = 8'd183;
					Blue = 8'd132;
				end
				
				else if(cowboy_pix == 4'b0111) 
				begin
					if(hp == 2'b01)
					begin
						Red = 8'd20;
						Green = 8'd133;
						Blue = 8'd255;
					end
					else if(hp == 2'b10)
						begin
							Red = 8'd0;
							Green = 8'd0;
							Blue = 8'd0;
						end
					else 
						begin
							Red = 8'd255;
							Green = 8'd255;
							Blue = 8'd255;
						end
				end
				else if(cowboy_pix == 4'b1000)
				begin
					Red = 8'd1;
					Green = 8'd81;
					Blue = 8'd168;
				end
				else if(cowboy_pix == 4'b1001)
				begin
					Red = 8'd0;
					Green = 8'd3;
					Blue = 8'd7;
				end
				else if(saloon_pix == 3'b001)
				begin
					Red = 8'd186;
					Green = 8'd141;
					Blue = 8'd113;
				end
				else if(saloon_pix == 3'b010)
				begin
					Red = 8'd130;
					Green = 8'd97;
					Blue = 8'd78;
				end
				else if(saloon_pix == 3'b011)
				begin
					Red = 8'd99;
					Green = 8'd74;
					Blue = 8'd59;
				end
				else if(saloon_pix == 3'b011)
				begin
					Red = 8'd99;
					Green = 8'd74;
					Blue = 8'd59;
				end
				else if(saloon_pix == 3'b100)
				begin
					Red = 8'd0;
					Green = 8'd0;
					Blue = 8'd0;
				end
				else if(saloon_pix == 3'b101)
				begin
					Red = 8'd255;
					Green = 8'd215;
					Blue = 8'd58;
				end
				else if(saloon_pix == 3'b110)
				begin
					Red = 8'd127;
					Green = 8'd243;
					Blue = 8'd249;
				end
				else if(saloon_pix == 3'b111)
				begin
					Red = 8'd255;
					Green = 8'd255;
					Blue = 8'd255;
				end
				else if(alien_pix == 4'b0001)
				begin
					Red = 8'd196;
					Green = 8'd196;
					Blue = 8'd196;
				end
				else if(alien_pix == 4'b0010)
				begin
					Red = 8'd140;
					Green = 8'd138;
					Blue = 8'd138;
				end
				else if(alien_pix == 4'b0011)
				begin
					Red = 8'd0;
					Green = 8'd0;
					Blue = 8'd0;
				end
				else if(alien_pix == 4'b0100)
				begin
					Red = 8'd255;
					Green = 8'd255;
					Blue = 8'd255;
				end
				else if(alien_pix == 4'b0101)
				begin
					Red = 8'd255;
					Green = 8'd22;
					Blue = 8'd22;
				end
				else if(alien_pix == 4'b0110)
				begin
					Red = 8'd249;
					Green = 8'd229;
					Blue = 8'd7;
				end
				else if(alien_pix == 4'b0111)
				begin
					Red = 8'd56;
					Green = 8'd219;
					Blue = 8'd2;
				end
				else if(alien_pix == 4'b1000)
				begin
					Red = 8'd235;
					Green = 8'd4;
					Blue = 8'd247;
				end
				else if((cactus0_pix == 4'b0001) || (cactus1_pix == 4'b0001) || (cactus2_pix == 4'b0001) || (cactus3_pix == 4'b0001))
				begin
					Red = 8'd78;
					Green = 8'd155;
					Blue = 8'd34;
				end
				else if((cactus0_pix == 4'b0010) || (cactus1_pix == 4'b0010) || (cactus2_pix == 4'b0010) || (cactus3_pix == 4'b0010))
				begin
					Red = 8'd36;
					Green = 8'd96;
					Blue = 8'd0;
				end
				else if((cactus0_pix == 4'b0011) || (cactus1_pix == 4'b0011) || (cactus2_pix == 4'b0011) || (cactus3_pix == 4'b0011))
				begin
					Red = 8'd229;
					Green = 8'd255;
					Blue = 8'd214;
				end
				else if((cactus0_pix == 4'b0100) || (cactus1_pix == 4'b0100) || (cactus2_pix == 4'b0100) || (cactus3_pix == 4'b0100))
				begin
					Red = 8'd0;
					Green = 8'd0;
					Blue = 8'd0;
				end
				else if(platform_pix == 4'b0010)
				begin
					Red = 8'd53;
					Green = 8'd207;
					Blue = 8'd255;
				end
				else if(platform_pix == 4'b0011)
				begin
					Red = 8'd76;
					Green = 8'd76;
					Blue = 8'd76;
				end
					else if(platform_pix == 4'b0100)
				begin
					Red = 8'd2;
					Green = 8'd229;
					Blue = 8'd255;
				end
					else if(platform_pix == 4'b0001)
				begin
					Red = 8'd175;
					Green = 8'd175;
					Blue = 8'd175;
				end
				else if(platform1_pix == 4'b0010)
				begin
					Red = 8'd53;
					Green = 8'd207;
					Blue = 8'd255;
				end
				else if(platform1_pix == 4'b0011)
				begin
					Red = 8'd76;
					Green = 8'd76;
					Blue = 8'd76;
				end
					else if(platform1_pix == 4'b0100)
				begin
					Red = 8'd2;
					Green = 8'd229;
					Blue = 8'd255;
				end
					else if(platform1_pix == 4'b0001)
				begin
					Red = 8'd175;
					Green = 8'd175;
					Blue = 8'd175;
				end
				else if(platform2_pix == 4'b0010)
				begin
					Red = 8'd53;
					Green = 8'd207;
					Blue = 8'd255;
				end
				else if(platform2_pix == 4'b0011)
				begin
					Red = 8'd76;
					Green = 8'd76;
					Blue = 8'd76;
				end
					else if(platform2_pix == 4'b0100)
				begin
					Red = 8'd2;
					Green = 8'd229;
					Blue = 8'd255;
				end
					else if(platform2_pix == 4'b0001)
				begin
					Red = 8'd175;
					Green = 8'd175;
					Blue = 8'd175;
				end
				else if(platform3_pix == 4'b0010)
				begin
					Red = 8'd53;
					Green = 8'd207;
					Blue = 8'd255;
				end
				else if(platform3_pix == 4'b0011)
				begin
					Red = 8'd76;
					Green = 8'd76;
					Blue = 8'd76;
				end
					else if(platform3_pix == 4'b0100)
				begin
					Red = 8'd2;
					Green = 8'd229;
					Blue = 8'd255;
				end
					else if(platform3_pix == 4'b0001)
				begin
					Red = 8'd175;
					Green = 8'd175;
					Blue = 8'd175;
				end
					else if(power_pix == 2'b01)
				begin
					Red = 8'd155;
					Green = 8'd155;
					Blue = 8'd155;
				end
					else if((AVC == 1'b0) && (power_pix == 2'b10))
				begin
					Red = 8'd58;
					Green = 8'd245;
					Blue = 8'd255;
				end
					else if((AVC == 1'b1) && (power_pix == 2'b10))
				begin
					Red = 8'd255;
					Green = 8'd30;
					Blue = 8'd30;
				end
					else if((ground0_pix == 4'b0001) || (ground1_pix == 4'b0001) || (ground2_pix == 4'b0001) || (ground3_pix == 4'b0001) || (ground4_pix == 4'b0001) || (ground5_pix == 4'b0001) || (ground6_pix == 4'b0001) || (ground7_pix == 4'b0001) || (ground8_pix == 4'b0001) || (ground9_pix == 4'b0001) || (ground10_pix == 4'b0001) || (ground11_pix == 4'b0001) || (ground12_pix == 4'b0001) || (ground13_pix == 4'b0001) || (ground14_pix == 4'b0001) || (ground15_pix == 4'b0001) || (ground16_pix == 4'b0001))
				begin
					Red = 8'd255;
					Green = 8'd236;
					Blue = 8'd142;
				end
					else if((ground0_pix == 4'b0010) || (ground1_pix == 4'b0010) || (ground2_pix == 4'b0010) || (ground3_pix == 4'b0010) || (ground4_pix == 4'b0010) || (ground5_pix == 4'b0010) || (ground6_pix == 4'b0010) || (ground7_pix == 4'b0010) || (ground8_pix == 4'b0010) || (ground9_pix == 4'b0010) || (ground10_pix == 4'b0010) || (ground11_pix == 4'b0010) || (ground12_pix == 4'b0010) || (ground13_pix == 4'b0010) || (ground14_pix == 4'b0010) || (ground15_pix == 4'b0010) || (ground16_pix == 4'b0010))
				begin
					Red = 8'd186;
					Green = 8'd172;
					Blue = 8'd102;
				end
					else if((ground0_pix == 4'b0011) || (ground1_pix == 4'b0011) || (ground2_pix == 4'b0011) || (ground3_pix == 4'b0011) || (ground4_pix == 4'b0011) || (ground5_pix == 4'b0011) || (ground6_pix == 4'b0011) || (ground7_pix == 4'b0011) || (ground8_pix == 4'b0011) || (ground9_pix == 4'b0011) || (ground10_pix == 4'b0011) || (ground11_pix == 4'b0011) || (ground12_pix == 4'b0011) || (ground13_pix == 4'b0011) || (ground14_pix == 4'b0011) || (ground15_pix == 4'b0011) || (ground16_pix == 4'b0011))
				begin
					Red = 8'd255;
					Green = 8'd255;
					Blue = 8'd255;
				end
					else if((ground0_pix == 4'b0100) || (ground1_pix == 4'b0100) || (ground2_pix == 4'b0100) || (ground3_pix == 4'b0100) || (ground4_pix == 4'b0100) || (ground5_pix == 4'b0100) || (ground6_pix == 4'b0100) || (ground7_pix == 4'b0100) || (ground8_pix == 4'b0100) || (ground9_pix == 4'b0100) || (ground10_pix == 4'b0100) || (ground11_pix == 4'b0100) || (ground12_pix == 4'b0100) || (ground13_pix == 4'b0100) || (ground14_pix == 4'b0100) || (ground15_pix == 4'b0100) || (ground16_pix == 4'b0100))
				begin
					Red = 8'd234;
					Green = 8'd129;
					Blue = 8'd72;
				end
					else if(ground17_pix == 4'b0001)
				begin
					Red = 8'd255;
					Green = 8'd236;
					Blue = 8'd142;
				end
					else if(ground17_pix == 4'b0010)
				begin
					Red = 8'd186;
					Green = 8'd172;
					Blue = 8'd102;
				end
					else if(ground17_pix == 4'b0011)
				begin
					Red = 8'd255;
					Green = 8'd255;
					Blue = 8'd255;
				end
					else if(ground17_pix == 4'b0100)
				begin
					Red = 8'd234;
					Green = 8'd129;
					Blue = 8'd72;
				end
				else if(UFO_pix == 4'b0001)
				begin
					Red = 8'd28;
					Green = 8'd247;
					Blue = 8'd255;
				end
				else if(UFO_pix == 4'b0010)
				begin
					Red = 8'd173;
					Green = 8'd173;
					Blue = 8'd173;
				end
				else if(UFO_pix == 4'b0011)
				begin
					Red = 8'd0;
					Green = 8'd0;
					Blue = 8'd0;
				end
				else if(UFO_pix == 4'b0100)
				begin
					Red = 8'd255;
					Green = 8'd255;
					Blue = 8'd255;
				end
			else if(cloud_pix == 4'b0110)
				begin
					Red = 8'hBD;
					Green = 8'hBD;
					Blue = 8'hBD;	
				end
			else if(cloud_pix == 4'b0100)
				begin
					Red = 8'hFF;
					Green = 8'hFF;
					Blue = 8'hFF;
				end
			else if(cloud_pix == 4'b0111)
				begin
					Red = 8'hE7;
					Green = 8'hE7;
					Blue = 8'hE7;
				end
			else
				begin
					Red = 8'd255;
					Green = 8'd220 - {1'b0, DrawY[9:3]}; //youve tried 220
					Blue = 8'd100 - {1'b0, DrawY[9:3]}; // youve tried 160
				end
			end
				
	endmodule
