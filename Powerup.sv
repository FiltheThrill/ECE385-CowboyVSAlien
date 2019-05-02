module powerup( input	 			  Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5, random,
					output [9:0]  PowerupX, PowerupY,
					output        AVC
					);
					
					
			
    parameter [9:0] Powerup_X_Center = 10'd800;  // Center position on the X axis
    parameter [9:0] Powerup_Y_Center = 10'd250;  // Center position on the Y axis
    parameter [9:0] Powerup_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Powerup_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Powerup_X_Step = 10'd2;      // Step size on the X axis
	 parameter [7:0] A = 8'h04;
	 parameter [7:0] D = 8'd7;
    logic [9:0] Powerup_X_Pos, Powerup_X_Motion, Powerup_Y_Pos, Powerup_Y_Motion;
    logic [9:0] Powerup_X_Pos_in, Powerup_X_Motion_in, Powerup_Y_Pos_in, Powerup_Y_Motion_in; 
					
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
	 logic avc;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Powerup_X_Pos <= Powerup_X_Center;
            Powerup_Y_Pos <= Powerup_Y_Center;
            Powerup_X_Motion <= 10'd0;
				
  		  end
		  else
			begin
				if((Powerup_X_Pos >= 10'd825) && (Powerup_X_Pos <= 10'd850))
					begin
						if(Powerup_Y_Pos >= Powerup_Y_Center)
							begin
								//Powerup_X_Pos <= (Powerup_X_Pos - {3'b0, random[5:0]});
								avc = random[0:0];
								Powerup_X_Pos <= Powerup_X_Pos_in;
								Powerup_Y_Pos <= (Powerup_Y_Pos_in - {3'b0, random[5:0]});
								Powerup_X_Motion <= Powerup_X_Motion_in;
								Powerup_Y_Motion <= Powerup_Y_Motion_in;
							end
						else
							begin
								avc = random[0:0];
								Powerup_X_Pos <= Powerup_X_Pos_in;
								Powerup_Y_Pos <= (Powerup_Y_Pos_in + {3'b0, random[5:0]});
								Powerup_X_Motion <= Powerup_X_Motion_in;
								Powerup_Y_Motion <= Powerup_Y_Motion_in;
							end
					end
				else
					begin		
						Powerup_X_Pos <= Powerup_X_Pos_in;
						Powerup_Y_Pos <= Powerup_Y_Pos_in;
						Powerup_X_Motion <= Powerup_X_Motion_in;
						Powerup_Y_Motion <= Powerup_Y_Motion_in;
					end
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Powerup_X_Pos_in = Powerup_X_Pos;
        Powerup_Y_Pos_in = Powerup_Y_Pos;
        Powerup_X_Motion_in = Powerup_X_Motion;
        Powerup_Y_Motion_in = Powerup_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
       if (frame_clk_rising_edge)
				begin
					if(GG == 1'b1)
						begin
							Powerup_X_Motion_in = 10'd0;
						end
					else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
								begin
									Powerup_X_Motion_in = Powerup_X_Step;
								end
					else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
								begin
									Powerup_X_Motion_in = (~(Powerup_X_Step)+1'b1);
								end
					
					else
								begin
									Powerup_X_Motion_in = 10'd0;
								end
				 
           
        
            // Update the Powerup's position with its motion
            Powerup_X_Pos_in = Powerup_X_Pos + Powerup_X_Motion;
            Powerup_Y_Pos_in = Powerup_Y_Pos + Powerup_Y_Motion;
				
        end
        
      
    end
    
 
   
    assign PowerupX = Powerup_X_Pos;
    assign PowerupY = Powerup_Y_Pos;
	 assign AVC = avc;
    
endmodule 	
				