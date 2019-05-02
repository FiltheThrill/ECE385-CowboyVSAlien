module UFO(	 	input		  			Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5, random,
					output [9:0]  UFOX, UFOY
					);
					
					
			
    parameter [9:0] UFO_Y_Center=10'd160;  
	 parameter [9:0] UFO_X_Center=10'd500;  
	 parameter [9:0] UFO_New = 10'd940; 
	 parameter [9:0] UFO_X_Step = 10'd3;
	 parameter [9:0] Cowboy_X_Step = 10'd2;     // Step size on the X axis
	 parameter [7:0] A = 8'h04;
	 parameter [7:0] D = 8'd7;
    logic [9:0] UFO_X_Pos, UFO_X_Motion, UFO_Y_Pos, UFO_Y_Motion;
    logic [9:0] UFO_X_Pos_in, UFO_X_Motion_in, UFO_Y_Pos_in, UFO_Y_Motion_in; 
					
    
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
            UFO_X_Pos <= UFO_X_Center;
            UFO_Y_Pos <= UFO_Y_Center;
            UFO_X_Motion <= 10'd0;
				
  		  end
		  else
			begin
				if((UFO_X_Pos >= 10'd825) && (UFO_X_Pos <= 10'd850))
					begin
						if(UFO_Y_Pos >= UFO_Y_Center)
							begin
								//UFO_X_Pos <= (UFO_X_Pos - {3'b0, random[5:0]});
								UFO_X_Pos <= UFO_X_Pos_in;
								UFO_Y_Pos <= (UFO_Y_Pos_in - {2'b0, random[6:0]});
								UFO_X_Motion <= UFO_X_Motion_in;
								UFO_Y_Motion <= UFO_Y_Motion_in;
							end
						else
							begin
								UFO_X_Pos <= UFO_X_Pos_in;
								UFO_Y_Pos <= (UFO_Y_Pos_in + {2'b0, random[6:0]});
								UFO_X_Motion <= UFO_X_Motion_in;
								UFO_Y_Motion <= UFO_Y_Motion_in;
							end
					end
				else
					begin		
						UFO_X_Pos <= UFO_X_Pos_in;
						UFO_Y_Pos <= UFO_Y_Pos_in;
						UFO_X_Motion <= UFO_X_Motion_in;
						UFO_Y_Motion <= UFO_Y_Motion_in;
					end
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        UFO_X_Pos_in = UFO_X_Pos;
        UFO_Y_Pos_in = UFO_Y_Pos;
        UFO_X_Motion_in = UFO_X_Motion;
        UFO_Y_Motion_in = UFO_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
       if (frame_clk_rising_edge)
				begin
					if(GG == 1'b1)
						begin
							UFO_X_Motion_in = (~(UFO_X_Step) + 1'b1);
						end
					else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
								begin
									UFO_X_Motion_in = (~(UFO_X_Step) + 1'b1) + Cowboy_X_Step;
								end
					else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
								begin
									UFO_X_Motion_in = (~(UFO_X_Step)+1'b1) + (~(Cowboy_X_Step) + 1'b1);
								end
					
					else
								begin
									UFO_X_Motion_in = (~(UFO_X_Step) + 1'b1);
								end
				 
           
        
            // Update the UFO's position with its motion
            UFO_X_Pos_in = UFO_X_Pos + UFO_X_Motion;
            UFO_Y_Pos_in = UFO_Y_Pos + UFO_Y_Motion;
				
        end
        
      
    end
    
 
   
    assign UFOX = UFO_X_Pos;
    assign UFOY = UFO_Y_Pos;

    
endmodule 	
				