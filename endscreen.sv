module Endscreen(input	     Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									 
					output [9:0]  End0X, End0Y, End1X, End1Y
				);
			
			logic [9:0] End_X_Pos, End0_Y_Pos, End1_X_Pos, End1_Y_Pos;
			logic first, first_in;
			
			parameter [9:0] End_X_Center = 10'd65;
			parameter [9:0] End0_Y_Center = 10'd120;
			parameter [9:0] End1_Y_Center = 10'd199;

			
			always_ff @(posedge Clk)
				begin
					if(Reset)
						begin
							End_X_Pos <= End_X_Center;
							End0_Y_Pos <= End0_Y_Center;
							End1_Y_Pos <= End1_Y_Center;
						end
					else 
						begin
							//yugma
						end
				end
	
		assign End0X = End_X_Pos;
		assign End0Y = End0_Y_Pos;
		assign End1X = End_X_Pos;
		assign End1Y = End1_Y_Pos;
endmodule 
		