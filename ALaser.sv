module ALaser ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5,
               input [9:0]   AlienX, AlienY,
					output[9:0]	  LaserX, LaserY 
				 );
	 
	 parameter [9:0] Laser_X_Center = 0;
	 parameter [9:0] Laser_Y_Center = 500;
	 parameter [9:0] Laser_Y_Gun = 10'd83;
	 parameter [9:0] Laser_X_Gun = 10'd14;
	 parameter [9:0] Laser_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Laser_Y_Max = 10'd462;     // Bottommost point on the Y axis
	 parameter [9:0] Cowboy_X_Step = 10'd2;
    parameter [9:0] Laser_Y_Step = 10'd6;
	 parameter [9:0] LaserH = 10'd8;
	 parameter [9:0] LaserW = 10'd4;
	 parameter [7:0] A = 8'd4;
	 parameter [7:0] D = 8'd7;
	 parameter [7:0] Space = 8'h2c;
	 
	 logic [9:0] Laser_AlienG;
	 logic [9:0] Laser_X_Pos, Laser_Y_Pos, Laser_Y_Motion, Laser_X_Motion;
	 logic [9:0] Laser_X_Pos_in, Laser_Y_Pos_in, Laser_Y_Motion_in, Laser_X_Motion_in;
	 
	 assign Laser_AlienG = Laser_X_Gun + AlienX;
	 
	 logic [46:0] Lcounter, Lcounter_in;
	 
	 enum logic [4:0] {Idle, Spawn, Wait1, Wait2, Wait3, Wait4, Wait5, Land, Gameover} State, Next_State;
	 
	 logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				Laser_X_Pos <= Laser_X_Center;
            Laser_Y_Pos <= Laser_Y_Center;
				Laser_X_Motion <= 10'd0;
            Laser_Y_Motion <= 10'd0;
				Lcounter <= 46'd0;
				State <= Idle;
        end
        else if(((State == Idle) || (State == Spawn)) && (key0 == Space) || (key1 == Space) || (key2 == Space) || (key3 == Space) || (key4 == Space) || (key5 == Space))
			begin
				Laser_X_Pos <= Laser_AlienG;
				Laser_Y_Pos <= Laser_Y_Gun;
				Laser_Y_Motion <= Laser_Y_Step;
				Lcounter <= 46'd0;
				State <= Wait1;
			end
		  else if(State == Idle)
			begin
				Laser_X_Pos <= Laser_X_Center;
				Laser_Y_Pos <= Laser_Y_Center;
			end
		  else
			begin
            Laser_Y_Pos <= Laser_Y_Pos_in;
				Laser_X_Pos <= Laser_X_Pos_in;
            Laser_Y_Motion <= Laser_Y_Motion_in;
				Laser_X_Motion <= Laser_X_Motion_in;
				Lcounter <= Lcounter_in + 1'b1;
				State <= Next_State;
			end
    end
	 
	 always_comb
    begin
        // By default, keep motion and position unchanged
        Laser_Y_Pos_in = Laser_Y_Pos;
        Laser_Y_Motion_in = Laser_Y_Motion;
		  Laser_X_Motion_in = Laser_X_Motion;
		  Laser_X_Pos_in = Laser_X_Pos;
		  Lcounter_in = Lcounter;
		  Next_State = State;
		  
			if (frame_clk_rising_edge)
				begin	
					unique case(State)
						Idle:
							begin
								Laser_Y_Motion_in = 10'd0;
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((key0 == Space) || (key1 == Space) || (key2 == Space) || (key3 == Space) || (key4 == Space) || (key5 == Space))
									begin
										Lcounter_in = 46'd0;
										Next_State = Spawn;
									end
							end
						Spawn:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else
									begin
										//Laser_Y_Pos_in = Laser_Y_Gun;
										//Laser_X_Pos_in = (Laser_X_Gun + AlienX);
										Lcounter_in = 46'd0;
										Next_State = Wait1;
									end
							end
						Wait1:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Laser_Y_Pos + LaserH) >= Laser_Y_Max)
									begin
										Laser_Y_Pos_in = Laser_Y_Center;
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if((Lcounter <= 10000000) && ((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A)))
									begin
										Laser_X_Motion_in = Cowboy_X_Step;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else if((Lcounter <= 10000000) && ((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D)))
									begin
										Laser_Y_Motion_in = Laser_Y_Step;
										Laser_X_Motion_in = (~(Cowboy_X_Step) + 1'b1);
									end
								else if(Lcounter <= 10000000)
									begin
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else
									begin
										Lcounter_in = 46'd0;
										Next_State = Wait2;
									end
							end
					Wait2:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Laser_Y_Pos + LaserH) >= Laser_Y_Max)
									begin
										Laser_Y_Pos_in = Laser_Y_Center;
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if((Lcounter <= 10000000) && ((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A)))
									begin
										Laser_X_Motion_in = Cowboy_X_Step;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else if((Lcounter <= 10000000) && ((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D)))
									begin
										Laser_Y_Motion_in = Laser_Y_Step;
										Laser_X_Motion_in = (~(Cowboy_X_Step) + 1'b1);
									end
								else if(Lcounter <= 10000000)
									begin
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else
									begin
										Lcounter_in = 46'd0;
										Next_State = Wait3;
									end
							end
						Wait3:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Laser_Y_Pos + LaserH) >= Laser_Y_Max)
									begin
										Laser_Y_Pos_in = Laser_Y_Center;
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if((Lcounter <= 10000000) && ((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A)))
									begin
										Laser_X_Motion_in = Cowboy_X_Step;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else if((Lcounter <= 10000000) && ((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D)))
									begin
										Laser_Y_Motion_in = Laser_Y_Step;
										Laser_X_Motion_in = (~(Cowboy_X_Step) + 1'b1);
									end
								else if(Lcounter <= 10000000)
									begin
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else
									begin
										Lcounter_in = 46'd0;
										Next_State = Wait4;
									end
							end
						Wait4:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Laser_Y_Pos + LaserH) >= Laser_Y_Max)
									begin
										Laser_Y_Pos_in = Laser_Y_Center;
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if((Lcounter <= 10000000) && ((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A)))
									begin
										Laser_X_Motion_in = Cowboy_X_Step;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else if((Lcounter <= 10000000) && ((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D)))
									begin
										Laser_Y_Motion_in = Laser_Y_Step;
										Laser_X_Motion_in = (~(Cowboy_X_Step) + 1'b1);
									end
								else if(Lcounter <= 10000000)
									begin
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else
									begin
										Lcounter_in = 46'd0;
										Next_State = Wait5;
									end
							end
						Wait5:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Laser_Y_Pos + LaserH) >= Laser_Y_Max)
									begin
										Laser_Y_Pos_in = Laser_Y_Center;
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if((Lcounter <= 10000000) && ((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A)))
									begin
										Laser_X_Motion_in = Cowboy_X_Step;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else if((Lcounter <= 10000000) && ((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D)))
									begin
										Laser_Y_Motion_in = Laser_Y_Step;
										Laser_X_Motion_in = (~(Cowboy_X_Step) + 1'b1);
									end
								else if(Lcounter <= 10000000)
									begin
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else
									begin
										Lcounter_in = 46'd0;
										Next_State = Land;
									end
							end
						Land:
							begin
								if(GG == 1'b1)
									begin
										Next_State = Gameover;
									end
								else if((Laser_Y_Pos + LaserH) >= Laser_Y_Max)
									begin
										Laser_Y_Pos_in = Laser_Y_Center;
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = 10'd0;
										Next_State = Idle;
									end
								else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
									begin
										Laser_X_Motion_in = Cowboy_X_Step;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
									begin
										Laser_X_Motion_in = (~(Cowboy_X_Step) + 1'b1);
										Laser_Y_Motion_in = Laser_Y_Step;
									end
								else 
									begin
										Laser_X_Motion_in = 10'd0;
										Laser_Y_Motion_in = Laser_Y_Step;
									end
							end
						Gameover:
							begin
								Laser_X_Motion_in = 10'd0;
								Laser_Y_Motion_in = 10'd0;
							end
						default:;
					endcase
					
				Laser_X_Pos_in = Laser_X_Motion + Laser_X_Pos;
				Laser_Y_Pos_in = Laser_Y_Motion + Laser_Y_Pos;
			end
		end
	assign LaserX = Laser_X_Pos;
	assign LaserY = Laser_Y_Pos;
endmodule
									