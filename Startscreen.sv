module Startscreen(input	  Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									 
					input [7:0]	  key0, key1, key2, key3, key4, key5, 
					output start,
					output [9:0]  Start0X, Start0Y, Start1X, Start1Y, Start2X, Start2Y
				);
			
			logic [9:0] Start_X_Pos, Start0_Y_Pos, Start1_X_Pos, Start1_Y_Pos, Start2_X_Pos, Start2_Y_Pos;
			logic first, first_in;
			
			parameter [9:0] Start_X_Center = 10'd65;
			parameter [9:0] Start0_Y_Center = 10'd120;
			parameter [9:0] Start1_Y_Center = 10'd199;
			parameter [9:0] Start2_Y_Center = 10'd278;
			parameter [7:0] A = 8'h04;
			parameter [7:0] W = 8'd26;
			parameter [7:0] D = 8'd7;
			parameter [7:0] left = 8'h36;
			parameter [7:0] right = 8'h37;
			parameter [7:0] Space = 8'h2c;
			
			always_ff @(posedge Clk)
				begin
					if(Reset)
						begin
							Start_X_Pos <= Start_X_Center;
							Start0_Y_Pos <= Start0_Y_Center;
							Start1_Y_Pos <= Start1_Y_Center;
							Start2_Y_Pos <= Start2_Y_Center;
							first <= 1'b1;
						end
					else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A) || (key0 == W) || (key1 == W) || (key2 == W) || (key3 == W) || (key4 == W) || (key5 == W)|| (key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D) || (key0 == left) || (key1 == left) || (key2 == left) || (key3 == left) || (key4 == left) || (key5 == left) || (key0 == right) || (key1 == right) || (key2 == right) || (key3 == right) || (key4 == right) || (key5 == right) || (key0 == Space) || (key1 == Space) || (key2 == Space) || (key3 == Space) || (key4 == Space) || (key5 == Space))
						begin
							first <= 1'b0;
						end
				end
				
			assign Start0X = Start_X_Pos;
			assign Start0Y = Start0_Y_Pos;
			assign Start1X = Start_X_Pos;
			assign Start1Y = Start1_Y_Pos;
			assign Start2X = Start_X_Pos;
			assign Start2Y = Start2_Y_Pos;
			assign start = first;
endmodule 