module ground(input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5,
					output [9:0] GroundX0, GroundY0, 
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
									 GroundX17, GroundY17 
				);
				
	 parameter [9:0] Ground0_X_Center = 10'd1;  // Center position on the X axis
	 parameter [9:0] Ground1_X_Center = 10'd59;
	 parameter [9:0] Ground2_X_Center = 10'd117;
	 parameter [9:0] Ground3_X_Center = 10'd175;
	 parameter [9:0] Ground4_X_Center = 10'd233;
	 parameter [9:0] Ground5_X_Center = 10'd291;
	 parameter [9:0] Ground6_X_Center = 10'd349;
	 parameter [9:0] Ground7_X_Center = 10'd407;
	 parameter [9:0] Ground8_X_Center = 10'd465;
	 parameter [9:0] Ground9_X_Center = 10'd523;
	 parameter [9:0] Ground10_X_Center = 10'd581;
	 parameter [9:0] Ground11_X_Center = 10'd639;
	 parameter [9:0] Ground12_X_Center = 10'd697;
	 parameter [9:0] Ground13_X_Center = 10'd755;
	 parameter [9:0] Ground14_X_Center = 10'd813;
	 parameter [9:0] Ground15_X_Center = 10'd871;
	 parameter [9:0] Ground16_X_Center = 10'd929;
	 parameter [9:0] Ground17_X_Center = 10'd987;
	 parameter [9:0] Ground_X_New = 10'd637;
	 parameter [9:0] Ground_X_Old = 10'd1;
    parameter [9:0] Ground_Y_Center = 10'd466;  // Center position on the Y axis
    parameter [9:0] Ground_X_Min = 10'd5;       // Leftmost point on the X axis
    parameter [9:0] Ground_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ground_X_Step = 10'd2;      // Step size on the X axis
	 parameter [7:0] A = 8'd4;
	 parameter [7:0] D = 8'd7;
    logic [9:0] Ground0_X_Pos, Ground1_X_Pos, Ground2_X_Pos, Ground3_X_Pos, Ground4_X_Pos, 
					Ground5_X_Pos, Ground6_X_Pos, Ground7_X_Pos, Ground8_X_Pos, Ground9_X_Pos, 
					Ground10_X_Pos, Ground11_X_Pos, Ground12_X_Pos, Ground13_X_Pos, Ground14_X_Pos, 
					Ground15_X_Pos, Ground16_X_Pos, Ground17_X_Pos, Ground_X_Motion, Ground_Y_Pos, 
					Ground_Y_Motion;
    logic [9:0] Ground0_X_Pos_in, Ground1_X_Pos_in, Ground2_X_Pos_in, Ground3_X_Pos_in, 
					Ground4_X_Pos_in, Ground5_X_Pos_in, Ground6_X_Pos_in, Ground7_X_Pos_in, Ground8_X_Pos_in, 
					Ground9_X_Pos_in, Ground10_X_Pos_in, Ground11_X_Pos_in, Ground12_X_Pos_in, Ground13_X_Pos_in, 
					Ground14_X_Pos_in, Ground15_X_Pos_in, Ground16_X_Pos_in, Ground17_X_Pos_in,Ground_X_Motion_in, Ground_Y_Pos_in, Ground_Y_Motion_in;
    
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
            Ground0_X_Pos <= Ground0_X_Center;
				Ground1_X_Pos <= Ground1_X_Center;
				Ground2_X_Pos <= Ground2_X_Center;
				Ground3_X_Pos <= Ground3_X_Center;
				Ground4_X_Pos <= Ground4_X_Center;
				Ground5_X_Pos <= Ground5_X_Center;
				Ground6_X_Pos <= Ground6_X_Center;
				Ground7_X_Pos <= Ground7_X_Center;
				Ground8_X_Pos <= Ground8_X_Center;
				Ground9_X_Pos <= Ground9_X_Center;
				Ground10_X_Pos <= Ground10_X_Center;
				Ground11_X_Pos <= Ground11_X_Center;
				Ground12_X_Pos <= Ground12_X_Center;
				Ground13_X_Pos <= Ground13_X_Center;
				Ground14_X_Pos <= Ground14_X_Center;
				Ground15_X_Pos <= Ground15_X_Center;
				Ground16_X_Pos <= Ground16_X_Center;
				Ground17_X_Pos <= Ground17_X_Center;
            Ground_Y_Pos <= Ground_Y_Center;
            Ground_X_Motion <= 10'd0;
  		  end
        else
        begin
            Ground0_X_Pos <= Ground0_X_Pos_in;
				Ground1_X_Pos <= Ground1_X_Pos_in;
				Ground2_X_Pos <= Ground2_X_Pos_in;
				Ground3_X_Pos <= Ground3_X_Pos_in;
				Ground4_X_Pos <= Ground4_X_Pos_in;
				Ground5_X_Pos <= Ground5_X_Pos_in;
				Ground6_X_Pos <= Ground6_X_Pos_in;
				Ground7_X_Pos <= Ground7_X_Pos_in;
				Ground8_X_Pos <= Ground8_X_Pos_in;
				Ground9_X_Pos <= Ground9_X_Pos_in;
				Ground10_X_Pos <= Ground10_X_Pos_in;
				Ground11_X_Pos <= Ground11_X_Pos_in;
				Ground12_X_Pos <= Ground12_X_Pos_in;
				Ground13_X_Pos <= Ground13_X_Pos_in;
				Ground14_X_Pos <= Ground14_X_Pos_in;
				Ground15_X_Pos <= Ground15_X_Pos_in;
				Ground16_X_Pos <= Ground16_X_Pos_in;
				Ground17_X_Pos <= Ground17_X_Pos_in;
            Ground_Y_Pos <= Ground_Y_Pos_in;
            Ground_X_Motion <= Ground_X_Motion_in;
            Ground_Y_Motion <= Ground_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ground0_X_Pos_in = Ground0_X_Pos;
		  Ground1_X_Pos_in = Ground1_X_Pos;
		  Ground2_X_Pos_in = Ground2_X_Pos;
		  Ground3_X_Pos_in = Ground3_X_Pos;
		  Ground4_X_Pos_in = Ground4_X_Pos;
		  Ground5_X_Pos_in = Ground5_X_Pos;
		  Ground6_X_Pos_in = Ground6_X_Pos;
		  Ground7_X_Pos_in = Ground7_X_Pos;
		  Ground8_X_Pos_in = Ground8_X_Pos;
		  Ground9_X_Pos_in = Ground9_X_Pos;
		  Ground10_X_Pos_in = Ground10_X_Pos;
		  Ground11_X_Pos_in = Ground11_X_Pos;
		  Ground12_X_Pos_in = Ground12_X_Pos;
		  Ground13_X_Pos_in = Ground13_X_Pos;
		  Ground14_X_Pos_in = Ground14_X_Pos;
		  Ground15_X_Pos_in = Ground15_X_Pos;
		  Ground16_X_Pos_in = Ground16_X_Pos;
		  Ground17_X_Pos_in = Ground17_X_Pos;
        Ground_Y_Pos_in = Ground_Y_Pos;
        Ground_X_Motion_in = Ground_X_Motion;
        Ground_Y_Motion_in = Ground_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
       if (frame_clk_rising_edge)
				begin
				if(GG == 1'b1)
					begin
						Ground_X_Motion_in = 10'd0;
					end
				else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
					begin
							Ground_X_Motion_in = Ground_X_Step;
					end
				else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
						begin
							Ground_X_Motion_in = (~(Ground_X_Step)+1'b1);
						end 
					
				else
						begin
								Ground_X_Motion_in = 10'd0;
						end
					
            // Be careful when using comparators with "logic" datatype because compiler treats 
           
        
            // Update the ball's position with its motion
            Ground0_X_Pos_in = Ground0_X_Pos + Ground_X_Motion;
				Ground1_X_Pos_in = Ground1_X_Pos + Ground_X_Motion;
				Ground2_X_Pos_in = Ground2_X_Pos + Ground_X_Motion;
				Ground3_X_Pos_in = Ground3_X_Pos + Ground_X_Motion;
				Ground4_X_Pos_in = Ground4_X_Pos + Ground_X_Motion;
				Ground5_X_Pos_in = Ground5_X_Pos + Ground_X_Motion;
				Ground6_X_Pos_in = Ground6_X_Pos + Ground_X_Motion;
				Ground7_X_Pos_in = Ground7_X_Pos + Ground_X_Motion;
				Ground8_X_Pos_in = Ground8_X_Pos + Ground_X_Motion;
				Ground9_X_Pos_in = Ground9_X_Pos + Ground_X_Motion;
				Ground10_X_Pos_in = Ground10_X_Pos + Ground_X_Motion;
				Ground11_X_Pos_in = Ground11_X_Pos + Ground_X_Motion;
				Ground12_X_Pos_in = Ground12_X_Pos + Ground_X_Motion;
				Ground13_X_Pos_in = Ground13_X_Pos + Ground_X_Motion;
				Ground14_X_Pos_in = Ground14_X_Pos + Ground_X_Motion;
				Ground15_X_Pos_in = Ground15_X_Pos + Ground_X_Motion;
				Ground16_X_Pos_in = Ground16_X_Pos + Ground_X_Motion;
				Ground17_X_Pos_in = Ground17_X_Pos + Ground_X_Motion;
            
        end
        
       
    end
    
    
   
    assign GroundX0 = Ground0_X_Pos;
    assign GroundY0 = Ground_Y_Pos;
	 assign GroundX1 = Ground1_X_Pos;
    assign GroundY1 = Ground_Y_Pos;
	 assign GroundX2 = Ground2_X_Pos;
    assign GroundY2 = Ground_Y_Pos;
	 assign GroundX3 = Ground3_X_Pos;
    assign GroundY3 = Ground_Y_Pos;
	 assign GroundX4 = Ground4_X_Pos;
    assign GroundY4 = Ground_Y_Pos;
	 assign GroundX5 = Ground5_X_Pos;
    assign GroundY5 = Ground_Y_Pos;
	 assign GroundX6 = Ground6_X_Pos;
    assign GroundY6 = Ground_Y_Pos;
	 assign GroundX7 = Ground7_X_Pos;
    assign GroundY7 = Ground_Y_Pos;
	 assign GroundX8 = Ground8_X_Pos;
    assign GroundY8 = Ground_Y_Pos;
	 assign GroundX9 = Ground9_X_Pos;
    assign GroundY9 = Ground_Y_Pos;
	 assign GroundX10 = Ground10_X_Pos;
    assign GroundY10 = Ground_Y_Pos;
    assign GroundX11 = Ground11_X_Pos;
    assign GroundY11 = Ground_Y_Pos;
	 assign GroundX12 = Ground12_X_Pos;
    assign GroundY12 = Ground_Y_Pos;
	 assign GroundX13 = Ground13_X_Pos;
    assign GroundY13 = Ground_Y_Pos;
	 assign GroundX14 = Ground14_X_Pos;
    assign GroundY14 = Ground_Y_Pos;
	 assign GroundX15 = Ground15_X_Pos;
    assign GroundY15 = Ground_Y_Pos;
	 assign GroundX16 = Ground16_X_Pos;
    assign GroundY16 = Ground_Y_Pos;
	 assign GroundX17 = Ground17_X_Pos;
    assign GroundY17 = Ground_Y_Pos;
    
endmodule 