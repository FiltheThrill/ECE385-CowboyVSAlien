module saloon( input	 	  	  Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  ursick,
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5, 
					output [9:0]  SaloonX, SaloonY
				);
		
		
		parameter [9:0] Saloon_X_Center = 10'd700;
		parameter [9:0] Saloon_Y_Center = 10'd324;
		parameter [9:0] Saloon_X_Step = 10'd2;
		parameter [7:0] A = 8'h04;
		parameter [7:0] D = 8'd7;
				
				
		  logic [9:0] Saloon_X_Pos, Saloon_X_Motion, Saloon_Y_Pos, 
					Saloon_Y_Motion;
    logic [9:0] Saloon_X_Pos_in,  
					Saloon_X_Motion_in, Saloon_Y_Pos_in, Saloon_Y_Motion_in;
    
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
            Saloon_X_Pos <= Saloon_X_Center;
            Saloon_Y_Pos <= Saloon_Y_Center;
            Saloon_X_Motion <= 10'd0;
				Saloon_Y_Motion <= 10'd0;
  		  end
        else
        begin
            Saloon_X_Pos <= Saloon_X_Pos_in;
            Saloon_Y_Pos <= Saloon_Y_Pos_in;
            Saloon_X_Motion <= Saloon_X_Motion_in;
            Saloon_Y_Motion <= Saloon_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Saloon_X_Pos_in = Saloon_X_Pos;
        Saloon_Y_Pos_in = Saloon_Y_Pos;
        Saloon_X_Motion_in = Saloon_X_Motion;
        Saloon_Y_Motion_in = Saloon_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
       if (frame_clk_rising_edge)
				begin
				if(GG == 1'b1)
					begin
						Saloon_X_Motion_in = 10'd0;
					end
				else if(ursick == 1'b1)
				begin
					if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
						begin
							Saloon_X_Motion_in = Saloon_X_Step;
						end
					else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
						begin
							Saloon_X_Motion_in = (~(Saloon_X_Step)+1'b1);
						end
					else
						begin
							Saloon_X_Motion_in = 10'd0;
						end
				end
				else
						begin
								Saloon_X_Motion_in = 10'd0;
						end
					
            // Be careful when using comparators with "logic" datatype because compiler treats 
           
        
            // Update the ball's position with its motion
            Saloon_X_Pos_in = Saloon_X_Pos + Saloon_X_Motion;
				
            
        end
        
       
    end
    
    
   
    assign SaloonX = Saloon_X_Pos;
    assign SaloonY = Saloon_Y_Pos;
	
    
endmodule 
						
					
					