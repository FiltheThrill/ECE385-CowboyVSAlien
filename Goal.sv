module Goal( input           Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk, 
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5,
					//output [9:0]  GoalX, GoalY,
               output ursick,
					output [12:0] endgamec,
					output [15:0] score
				);

	 parameter [7:0] A = 8'h04;
	 parameter [7:0] D = 8'd7;
	 logic goal, goal_in;
	 logic [12:0] endgame, endgame_in;
	 logic [15:0] score_in;
	 //1110000100000 this is 2 minutes
	 always_ff @(posedge frame_clk or posedge Reset)
		begin
			if(Reset)
				begin
					endgamec <= 13'h000;
					score <= 16'h2A30;
					goal <= 1'b0;
				end
			else if(GG)
				begin
					endgamec <= endgame_in;
					score <= score_in;
					goal <= goal_in;
				end
			else if(endgamec >= 13'h0FFF) //100101100 is 5 seconds 1c20 is ~2 minutes
				begin
					score <= score_in;
					goal <= 1'b1;
				end
			else if(((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A)) && (endgamec != 0))
				begin
					score <= score_in - 1'b1;
					endgamec <= endgame_in - 1'b1;
				end
			else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
				begin
					score <= score_in - 1'b1;
					endgamec <= endgame_in + 1'b1;
				end
			
			else
				begin
					score <= score_in - 1'b1;
					endgamec <= endgame_in;
					goal <= goal_in;
				end
		end
	always_comb
		begin
			endgame_in = endgamec;
			goal_in = goal;
			score_in = score;
		end
	assign ursick = goal;
	//assign endgamec = endgame;
endmodule
				