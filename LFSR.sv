module LFSR(
					input		Clk,
								enable,
								Reset,
					output [7:0] random
				);
			logic linear_feedback;
			
			
		assign linear_feedback = ~(random[7] ^ random[2]);
			
		always_ff @(posedge Clk)
			begin
				if(Reset)
					begin
						random <= 8'b0;
					end
				else if(enable)
					begin
						random <= {random[6], random[5], random[4], random[3], random[2], random[1], random[0], linear_feedback};
					end
			end
endmodule 
		
			