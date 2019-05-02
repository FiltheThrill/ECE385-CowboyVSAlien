module  Cowboy ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5,
               input [9:0]   PlatformX, PlatformY,
									  Platform1X, Platform1Y,
									  Platform2X, Platform2Y,
									  Platform3X, Platform3Y,
					output[9:0]	  CowboyX, CowboyY
					
              );
				  
				 
    
    parameter [9:0] Cowboy_X_Center = 10'd207;  // Center position on the X axis
    parameter [9:0] Cowboy_Y_Center = 10'd412;  // Center position on the Y axis
    parameter [9:0] Cowboy_X_Min = 10'd25;       // Leftmost point on the X axis
    parameter [9:0] Cowboy_X_Max = 10'd646;     // Rightmost point on the X axis
    parameter [9:0] Cowboy_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Cowboy_Y_Max = 10'd470;     // Bottommost point on the Y axis
    parameter [9:0] Cowboy_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Cowboy_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Cowboy_X_Size = 10'd27;        // Cowboy size
	 parameter [9:0] Cowboy_Y_Size = 10'd43;
	 parameter [9:0] PlatformW = 10'd58;
	 parameter [9:0] PlatformH = 10'd5;
	 parameter [7:0] W = 8'd26;
	 parameter [7:0] A = 8'd4;
	 parameter [7:0] S = 8'd34;
	 parameter [7:0] D = 8'd7;
	 
    logic [9:0] Cowboy_X_Pos, Cowboy_X_Motion, Cowboy_Y_Pos, Cowboy_Y_Motion;
    logic [9:0] Cowboy_X_Pos_in, Cowboy_X_Motion_in, Cowboy_Y_Pos_in, Cowboy_Y_Motion_in;
	 logic [46:0] jcounter, jcounter_in;
	 enum logic [4:0] {Idle, Jump1, Jump2, Jump3, Jump4, Jump5, Jump6, Jump7, Jump8,Jump22, Jump77, Land, Gameover} State, Next_State;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Cowboy_X_Pos <= Cowboy_X_Center;
            Cowboy_Y_Pos <= Cowboy_Y_Center;
            Cowboy_X_Motion <= 10'd0;
            Cowboy_Y_Motion <= Cowboy_Y_Step;
				jcounter <= 46'd0;
				State <= Idle;
				
        end
        else
        begin
            Cowboy_X_Pos <= Cowboy_X_Pos_in;
            Cowboy_Y_Pos <= Cowboy_Y_Pos_in;
            Cowboy_X_Motion <= Cowboy_X_Motion_in;
            Cowboy_Y_Motion <= Cowboy_Y_Motion_in;
				jcounter <= jcounter_in +1'b1;
				State <= Next_State;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Cowboy_X_Pos_in = Cowboy_X_Pos;
        Cowboy_Y_Pos_in = Cowboy_Y_Pos;
        Cowboy_X_Motion_in = Cowboy_X_Motion;
        Cowboy_Y_Motion_in = Cowboy_Y_Motion;
        jcounter_in = jcounter;
		  Next_State = State;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
				begin
					unique case (State)
						Idle:
							begin
								Cowboy_Y_Motion_in = 10'd0;
								if(GG === 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max)
									begin
										Cowboy_Y_Motion_in = 10'd0;
									end
								else if(~((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))))) 
									begin
										Cowboy_Y_Motion_in = Cowboy_Y_Step;
										Next_State = Jump5;
									end
								if((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))
									begin
										jcounter_in = 46'd0;
										Next_State = Jump1;
									end
							end
						Jump1:
							begin
								if(GG === 1'b1)
									begin
										Next_State = Gameover;
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter <= 10000000))
									begin
										Cowboy_Y_Motion_in = 4*(~(Cowboy_Y_Step)+1'b1);
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter >= 10000000))
									begin
										jcounter_in = 46'd0;
										Next_State = Jump2;
									end
								else 
									begin
										jcounter_in = 46'd0;
										Next_State = Jump5;
									end
							end
						
						Jump2:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter <= 10000000))
									begin
										Cowboy_Y_Motion_in = 3*(~(Cowboy_Y_Step)+1'b1);
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter >= 10000000))
									begin
										jcounter_in = 46'd0;
										Next_State = Jump22;
									end
								else 
									begin
										jcounter_in = 46'd0;
										Next_State = Jump5;
									end
							end
						Jump22:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter <= 10000000))
									begin
										Cowboy_Y_Motion_in = 3*(~(Cowboy_Y_Step)+1'b1);
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter >= 10000000))
									begin
										jcounter_in = 46'd0;
										Next_State = Jump3;
									end
								else 
									begin
										jcounter_in = 46'd0;
										Next_State = Jump5;
									end
							end
						Jump3:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter <= 10000000))
									begin
										Cowboy_Y_Motion_in = 2*(~(Cowboy_Y_Step)+1'b1);
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter >= 10000000))
									begin
										jcounter_in = 46'd0;
										Next_State = Jump4;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Jump5;
									end
							end
							
						Jump4:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter <= 10000000))
									begin
										Cowboy_Y_Motion_in = (~(Cowboy_Y_Step)+1'b1);
									end
								else if(((key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W))  && (jcounter >= 10000000))
									begin
										jcounter_in = 46'd0;
										Next_State = Jump5;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Jump5;
									end
							end
						Jump5:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))) 
										|| ((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max))
									begin
										Cowboy_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if(jcounter <= 10000000)
									begin
										Cowboy_Y_Motion_in = Cowboy_Y_Step;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Jump6;
									end

							end
						Jump6:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))) 
										|| ((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max))
									begin
										Cowboy_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if(jcounter <= 10000000)
									begin
										Cowboy_Y_Motion_in = 2*Cowboy_Y_Step;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Jump7;
									end

							end
						
						Jump7:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))) 
										|| ((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max))
									begin
										Cowboy_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if(jcounter <= 10000000)
									begin
										Cowboy_Y_Motion_in = 3*Cowboy_Y_Step;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Jump77;
									end

							end
						Jump77:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))) 
										|| ((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max))
									begin
										Cowboy_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if(jcounter <= 10000000)
									begin
										Cowboy_Y_Motion_in = 3*Cowboy_Y_Step;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Jump8;
									end

							end
						Jump8:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))) 
										|| ((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max))
									begin
										Cowboy_Y_Motion_in = 10'd0;
										Next_State = Land;
									end
								else if(jcounter <= 10000000)
									begin
										Cowboy_Y_Motion_in = 4*Cowboy_Y_Step;
									end
								else
									begin
										jcounter_in = 46'd0;
										Next_State = Idle;
									end

							end
						
						Land:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((((Cowboy_Y_Pos + Cowboy_Y_Size) >= PlatformY) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (PlatformY + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= PlatformX) && (Cowboy_X_Pos <= (PlatformX + PlatformW))))
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform1Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform1Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform1X) && (Cowboy_X_Pos <= (Platform1X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform2Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform2Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform2X) && (Cowboy_X_Pos <= (Platform2X + PlatformW)))) 
										|| (((Cowboy_Y_Pos + Cowboy_Y_Size) >= Platform3Y) && ((Cowboy_Y_Pos + Cowboy_Y_Size) <= (Platform3Y + PlatformH)) && (((Cowboy_X_Pos + Cowboy_X_Size) >= Platform3X) && (Cowboy_X_Pos <= (Platform3X + PlatformW)))) 
										|| ((Cowboy_Y_Pos + Cowboy_Y_Size) >= Cowboy_Y_Max))
									begin
										
										Cowboy_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else
									begin
										Next_State = Idle;
									end
							end
						Gameover:
							begin
								Cowboy_Y_Motion_in = 10'd0;
							end
						default:;
					endcase

            // Update the Cowboy's position with its motion
            Cowboy_X_Pos_in = Cowboy_X_Pos + Cowboy_X_Motion;
            Cowboy_Y_Pos_in = Cowboy_Y_Pos + Cowboy_Y_Motion;
        end
        
        
    end
    assign CowboyX = Cowboy_X_Pos;
	 assign CowboyY = Cowboy_Y_Pos;
endmodule


