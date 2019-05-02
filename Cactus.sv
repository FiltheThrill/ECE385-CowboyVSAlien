module cactus(input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5,
					output [9:0] CactusX0, CactusY0, 
									 CactusX1, CactusY1, 
									 CactusX2, CactusY2,  
									 CactusX3, CactusY3  								
				);
				
	parameter [9:0] Cactus_X_Step = 10'd2;

	parameter [9:0] Cactus0_X_Center = 10'd500;
	parameter [9:0] Cactus1_X_Center = 10'd700;
	parameter [9:0] Cactus2_X_Center = 10'd900;
	parameter [9:0] Cactus3_X_Center = 10'd300;
	parameter [9:0] Cactus_Y_Center = 10'd429;     // Rightmost point on the X axis
	 parameter [7:0] A = 8'd4;
	 parameter [7:0] D = 8'd7;
    logic [9:0] Cactus0_X_Pos, Cactus1_X_Pos, Cactus2_X_Pos, Cactus3_X_Pos, Cactus_X_Motion, Cactus_Y_Pos, 
					Cactus_Y_Motion;
    logic [9:0] Cactus0_X_Pos_in, Cactus1_X_Pos_in, Cactus2_X_Pos_in, Cactus3_X_Pos_in, 
					Cactus_X_Motion_in, Cactus_Y_Pos_in, Cactus_Y_Motion_in;
    
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
            Cactus0_X_Pos <= Cactus0_X_Center;
				Cactus1_X_Pos <= Cactus1_X_Center;
				Cactus2_X_Pos <= Cactus2_X_Center;
				Cactus3_X_Pos <= Cactus3_X_Center;
            Cactus_Y_Pos <= Cactus_Y_Center;
            Cactus_X_Motion <= 10'd0;
  		  end
        else
        begin
            Cactus0_X_Pos <= Cactus0_X_Pos_in;
				Cactus1_X_Pos <= Cactus1_X_Pos_in;
				Cactus2_X_Pos <= Cactus2_X_Pos_in;
				Cactus3_X_Pos <= Cactus3_X_Pos_in;
            Cactus_Y_Pos <= Cactus_Y_Pos_in;
            Cactus_X_Motion <= Cactus_X_Motion_in;
            Cactus_Y_Motion <= Cactus_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Cactus0_X_Pos_in = Cactus0_X_Pos;
		  Cactus1_X_Pos_in = Cactus1_X_Pos;
		  Cactus2_X_Pos_in = Cactus2_X_Pos;
		  Cactus3_X_Pos_in = Cactus3_X_Pos;
        Cactus_Y_Pos_in = Cactus_Y_Pos;
        Cactus_X_Motion_in = Cactus_X_Motion;
        Cactus_Y_Motion_in = Cactus_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
       if (frame_clk_rising_edge)
				begin
				if(GG == 1'b1)
					begin
						Cactus_X_Motion_in = 10'd0;
					end
				else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
					begin
							Cactus_X_Motion_in = Cactus_X_Step;
					end
				else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
						begin
							Cactus_X_Motion_in = (~(Cactus_X_Step)+1'b1);
						end 
					
				else
						begin
								Cactus_X_Motion_in = 10'd0;
						end
					
            // Be careful when using comparators with "logic" datatype because compiler treats 
           
        
            // Update the ball's position with its motion
            Cactus0_X_Pos_in = Cactus0_X_Pos + Cactus_X_Motion;
				Cactus1_X_Pos_in = Cactus1_X_Pos + Cactus_X_Motion;
				Cactus2_X_Pos_in = Cactus2_X_Pos + Cactus_X_Motion;
				Cactus3_X_Pos_in = Cactus3_X_Pos + Cactus_X_Motion;
            
        end
        
       
    end
    
    
   
    assign CactusX0 = Cactus0_X_Pos;
    assign CactusY0 = Cactus_Y_Pos;
	 assign CactusX1 = Cactus1_X_Pos;
    assign CactusY1 = Cactus_Y_Pos;
	 assign CactusX2 = Cactus2_X_Pos;
    assign CactusY2 = Cactus_Y_Pos;
	 assign CactusX3 = Cactus3_X_Pos;
	 assign CactusY3 = Cactus_Y_Pos;
    
endmodule 