module Alien ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5,
              
					output[9:0]	  AlienX, AlienY 
				 );
					
	 parameter [9:0] Alien_X_Center = 10'd310;  // Center position on the X axis
    parameter [9:0] Alien_Y_Center = 10'd25;  // Center position on the Y axis
    parameter [9:0] Alien_X_Min = 10'd10;       // Leftmost point on the X axis
    parameter [9:0] Alien_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Cowboy_X_Step = 10'd2;      // Step size on the X axis
	 parameter [9:0] Alien_X_Step = 10'd3;
	 parameter [9:0] AlienH = 10'd58;
	 parameter [9:0] AlienW = 10'd58;
	 parameter [9:0] CowboyW = 10'd27;
	 parameter [9:0] CowboyH = 10'd43;
	 parameter [7:0] left = 8'h36;
	 parameter [7:0] right = 8'h37;
	 parameter [7:0] Space = 8'h2c;
	 parameter [7:0] W = 8'd26;
	 parameter [7:0] A = 8'd4;
	 parameter [7:0] S = 8'd34;
	 parameter [7:0] D = 8'd7;
				logic [9:0] Alien_X_Pos, Alien_Y_Pos, Alien_X_Motion;
				logic [9:0] Alien_X_Pos_in, Alien_X_Motion_in, Alien_Y_Pos_in;
				
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
            Alien_X_Pos <= Alien_X_Center;
				Alien_Y_Pos <= Alien_Y_Center;
            Alien_X_Motion <= 10'd0;	
        end
        else
        begin
            Alien_X_Pos <= Alien_X_Pos_in;
            Alien_X_Motion <= Alien_X_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
		  //jump_next = jump;
        Alien_X_Pos_in = Alien_X_Pos;
        Alien_X_Motion_in = Alien_X_Motion;
			if (frame_clk_rising_edge)
				begin	
					if(GG == 1'b1)
						begin
							Alien_X_Motion_in = 10'd0;
						end
					else if((key0 == left) || (key1 == left) || (key2 == left) || (key3 == left) || (key4 == left) || (key5 == left))
							begin
								if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
									begin
										if(Alien_X_Pos <= Alien_X_Min)
											begin
												Alien_X_Motion_in = 10'd0;
											end
									else
										begin
											Alien_X_Motion_in = (~(Alien_X_Step - Cowboy_X_Step) + 1'b1);
										end
									end
								else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
									begin
										if(Alien_X_Pos <= Alien_X_Min)
											begin
												Alien_X_Motion_in = 10'd0;
											end
										else
											begin
												Alien_X_Motion_in = (~(Alien_X_Step + Cowboy_X_Step)  + 1'b1);
											end
									end
								else if(Alien_X_Pos <= Alien_X_Min)
										begin
											Alien_X_Motion_in = 10'd0;
										end
								else
									begin
										Alien_X_Motion_in = (~(Alien_X_Step) + 1'b1);
									end
							end
						else if((key0 == right) || (key1 == right) || (key2 == right) || (key3 == right) || (key4 == right) || (key5 == right))
							begin
								if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
									begin
										if((Alien_X_Pos + AlienW) >= Alien_X_Max)
											begin
												Alien_X_Motion_in = 10'd0;
											end
										else
											begin
												Alien_X_Motion_in = (Alien_X_Step + Cowboy_X_Step);
											end
									end
								else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
									begin
										if((Alien_X_Pos + AlienW) >= Alien_X_Max)
											begin
												Alien_X_Motion_in = 10'd0;
											end
										else
											begin
												Alien_X_Motion_in = (Alien_X_Step - Cowboy_X_Step);
											end
									end
								else if((Alien_X_Pos + AlienW) >= Alien_X_Max)
									begin
										Alien_X_Motion_in = 10'd0;
									end
								else
									begin
										Alien_X_Motion_in = Alien_X_Step;
									end
							end
						else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
								begin
									if((Alien_X_Pos + AlienW) >= Alien_X_Max)
										begin
											Alien_X_Motion_in = 10'd0;
										end
									else
										begin
											Alien_X_Motion_in = Cowboy_X_Step;
										end
								end
						else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
							begin
								if(Alien_X_Pos <= Alien_X_Min)
										begin
											Alien_X_Motion_in = 10'd0;
										end
								else
									begin
										Alien_X_Motion_in = (~(Cowboy_X_Step)+1'b1);
									end
							end
						else
							begin
								Alien_X_Motion_in = 10'd0;
							end
						
						Alien_X_Pos_in = Alien_X_Pos + Alien_X_Motion;
						//Alien_Y_Pos_in = Alien_Y_Pos + Alien_Y_Motion;
				end
		
	end
	  
		assign AlienX = Alien_X_Pos;
		assign AlienY = Alien_Y_Pos;
endmodule

									
							