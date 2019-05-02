module collision(
						input					Clk,                // 50 MHz clock
												Reset,              // Active-high reset signal
												frame_clk, AVC, done,         // The clock indicating a new frame (~60Hz)
						input [7:0]	  		key0, key1, key2, key3, key4, key5,
						input[9:0]	  		CowboyX, CowboyY, LaserX, LaserY, Cactus0X, Cactus0Y, 
												Cactus1X, Cactus1Y, Cactus2X, Cactus2Y, Cactus3X, Cactus3Y, 
												SaloonX, SaloonY, PowerupX, PowerupY, SpikeX, SpikeY,
						output 				GGA, GGC, spawn,
						output [1:0]      hp
					);

					

			parameter [9:0] CowboyH = 10'd43;
			parameter [9:0] CowboyW = 10'd27;
			parameter [9:0] CowboyW2 = 10'd13;
			parameter [9:0] CowboyH2 = 10'd21;
			parameter [9:0] LaserH = 10'd8;
			parameter [9:0] LaserW = 10'd4;
			parameter [9:0] CactusH = 10'd41;
			parameter [9:0] CactusW = 10'd27;
			parameter [9:0] SaloonH = 10'd152;
			parameter [9:0] SaloonW = 10'd107;
			parameter [9:0] PowerupW = 10'd25;
			parameter [9:0] PowerupH =  10'd25;
			parameter [9:0] SpikeW = 10'd35;
			parameter [9:0] SpikeH = 10'd35;
			
			logic gameover, gameover_in, spike, spike_in;
			logic [1:0] health, health_in;
			logic gamewin, gamewin_in;
			logic frame_clk_delayed, frame_clk_rising_edge;
			always_ff @ (posedge Clk) begin
				frame_clk_delayed <= frame_clk;
				frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
			end
			
			always_ff @ (posedge Clk)
				begin
					if(Reset)
						begin
							gameover <= 1'b0;
							gamewin <= 1'b0;
							health <= 2'b1;
							spike <= 1'b0;
						end
					else if(health == 2'b0)
						begin
							spike <= spike_in;
							gameover <= 1'b1;
							health <= health_in;
							gamewin <= gamewin_in;
						end
					else if(health > 2'b10)
						begin
							spike <= spike_in;
							health <= 2'b10;
							gamewin <= gamewin_in;
							gameover <= gameover_in;
						end
					else
						begin
							spike <= spike_in;
							health <= health_in;
							gamewin <= gamewin_in;
							gameover <= gameover_in;
						end
				end
				
			always_comb
				begin
					gameover_in = gameover;
					gamewin_in = gamewin;
					health_in = health;
					spike_in = spike;
					if (frame_clk_rising_edge)
						begin	
							if((SaloonX <= (CowboyX + CowboyW2)) && (SaloonX + SaloonW) >= (CowboyX + CowboyW2) && (SaloonY + SaloonH) >= (CowboyY + CowboyH2) && ((SaloonY) <= (CowboyY + CowboyH2)))
								begin
									gamewin_in = 1'b1;
								end
							else if(((LaserX <= (CowboyX + CowboyW)) && (LaserX >= CowboyX) && ((LaserY + LaserH) >= CowboyY) && ((LaserY + LaserH) <= (CowboyY + CowboyH)))
								|| (((LaserX + LaserW) <= (CowboyX + CowboyW)) && ((LaserX + LaserW) >= CowboyX) && ((LaserY + LaserH) >= CowboyY) && ((LaserY+ LaserH) <= (CowboyY + CowboyH)))
								|| (((LaserX + LaserW) <= (CowboyX + CowboyW)) && ((LaserX + LaserW) >= CowboyX) && (LaserY >= CowboyY) && (LaserY <= (CowboyY + CowboyH)))
								|| ((LaserX <= (CowboyX + CowboyW)) && (LaserX >= CowboyX) && (LaserY >= CowboyY) && (LaserY <= (CowboyY + CowboyH))))
								begin
									gameover_in = 1'b1;
								end
								else if(((SpikeX <= (CowboyX + CowboyW)) && (SpikeX >= CowboyX) && ((SpikeY + SpikeH) >= CowboyY) && ((SpikeY + SpikeH) <= (CowboyY + CowboyH)))
								|| (((SpikeX + SpikeW) <= (CowboyX + CowboyW)) && ((SpikeX + SpikeW) >= CowboyX) && ((SpikeY + SpikeH) >= CowboyY) && ((SpikeY+ SpikeH) <= (CowboyY + CowboyH)))
								|| (((SpikeX + SpikeW) <= (CowboyX + CowboyW)) && ((SpikeX + SpikeW) >= CowboyX) && (SpikeY >= CowboyY) && (SpikeY <= (CowboyY + CowboyH)))
								|| ((SpikeX <= (CowboyX + CowboyW)) && (SpikeX >= CowboyX) && (SpikeY >= CowboyY) && (SpikeY <= (CowboyY + CowboyH))))
								begin
									gameover_in = 1'b1;
								end
							else if (((Cactus0X <= (CowboyX + CowboyW)) && (Cactus0X >= CowboyX) && ((Cactus0Y + CactusH) >= CowboyY) && ((Cactus0Y + CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus0X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus0X + CactusW) >= CowboyX) && ((Cactus0Y + CactusH) >= CowboyY) && ((Cactus0Y+ CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus0X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus0X + CactusW) >= CowboyX) && (Cactus0Y >= CowboyY) && (Cactus0Y <= (CowboyY + CowboyH)))
								|| ((Cactus0X <= (CowboyX + CowboyW)) && (Cactus0X >= CowboyX) && (Cactus0Y >= CowboyY) && (Cactus0Y <= (CowboyY + CowboyH))))
								begin
									gameover_in = 1'b1;
								end
							else if (((Cactus1X <= (CowboyX + CowboyW)) && (Cactus1X >= CowboyX) && ((Cactus1Y + CactusH) >= CowboyY) && ((Cactus1Y + CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus1X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus1X + CactusW) >= CowboyX) && ((Cactus1Y + CactusH) >= CowboyY) && ((Cactus1Y+ CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus1X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus1X + CactusW) >= CowboyX) && (Cactus1Y >= CowboyY) && (Cactus1Y <= (CowboyY + CowboyH)))
								|| ((Cactus1X <= (CowboyX + CowboyW)) && (Cactus1X >= CowboyX) && (Cactus1Y >= CowboyY) && (Cactus1Y <= (CowboyY + CowboyH))))
								begin
									gameover_in = 1'b1;
								end
							else if (((Cactus2X <= (CowboyX + CowboyW)) && (Cactus2X >= CowboyX) && ((Cactus2Y + CactusH) >= CowboyY) && ((Cactus2Y + CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus2X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus2X + CactusW) >= CowboyX) && ((Cactus2Y + CactusH) >= CowboyY) && ((Cactus2Y+ CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus2X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus2X + CactusW) >= CowboyX) && (Cactus2Y >= CowboyY) && (Cactus2Y <= (CowboyY + CowboyH)))
								|| ((Cactus2X <= (CowboyX + CowboyW)) && (Cactus2X >= CowboyX) && (Cactus2Y >= CowboyY) && (Cactus2Y <= (CowboyY + CowboyH))))
								begin
									gameover_in = 1'b1;
								end
							else if (((Cactus3X <= (CowboyX + CowboyW)) && (Cactus3X >= CowboyX) && ((Cactus3Y + CactusH) >= CowboyY) && ((Cactus3Y + CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus3X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus3X + CactusW) >= CowboyX) && ((Cactus3Y + CactusH) >= CowboyY) && ((Cactus3Y+ CactusH) <= (CowboyY + CowboyH)))
								|| (((Cactus3X + CactusW) <= (CowboyX + CowboyW)) && ((Cactus3X + CactusW) >= CowboyX) && (Cactus3Y >= CowboyY) && (Cactus3Y <= (CowboyY + CowboyH)))
								|| ((Cactus3X <= (CowboyX + CowboyW)) && (Cactus3X >= CowboyX) && (Cactus3Y >= CowboyY) && (Cactus3Y <= (CowboyY + CowboyH))))
								begin
									gameover_in = 1'b1;
								end
							else if ((AVC == 1'b0) && ((PowerupX <= (LaserX + LaserW)) && (PowerupX >= LaserX) && ((PowerupY + PowerupH) >= LaserY) && ((PowerupY + PowerupH) <= (LaserY + LaserH)))
								|| (((PowerupX + PowerupW) <= (LaserX + LaserW)) && ((PowerupX + PowerupW) >= LaserX) && ((PowerupY + PowerupH) >= LaserY) && ((PowerupY+ PowerupH) <= (LaserY + LaserH)))
								|| (((PowerupX + PowerupW) <= (LaserX + LaserW)) && ((PowerupX + PowerupW) >= LaserX) && (PowerupY >= LaserY) && (PowerupY <= (LaserY + LaserH)))
								|| ((PowerupX <= (LaserX + LaserW)) && (PowerupX >= LaserX) && (PowerupY >= LaserY) && (PowerupY <= (LaserY + LaserH))))
									begin
										spike_in = 1'b1;
									end
							else if(done == 1'b1)
								begin
									spike_in = 1'b0;
								end
							else
								begin
									gameover_in = gameover;
									gamewin_in = gamewin;
									health_in = health;
									spike_in = spike;
								end
						end
				end
			
			assign GGA = gameover;
			assign GGC = gamewin;
			assign hp = health;
			assign spawn = spike;
			
	endmodule
						
			
	