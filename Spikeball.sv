module Spikeball(	input 	Clk,
									frame_clk,
									Reset, 
									spawn,
									GG,
						input [7:0] key0, key1, key2, key3, key4, key5, 
						output done,
						output [9:0] SpikeX, SpikeY
					);
					
			parameter [9:0] Spike_X_Center = 10'd800;
			parameter [9:0] Spike_Y_Center = 10'd200;
			parameter [9:0] Spike_X_Spawn = 10'd700;
			parameter [9:0] Spike_Y_Spawn = 10'd5;
			parameter [9:0] Spike_X_Step = 10'd3;
			parameter [9:0] Spike_Y_Step = 10'd3;
			parameter [9:0] Spike_X_Max = 10'd639;
			parameter [9:0] Spike_X_Min = 10'd1;
			parameter [9:0] Spike_Y_Max = 10'd479;
			parameter [9:0] Spike_Y_Min = 10'd1;
			parameter [9:0] Cowboy_X_Step = 10'd2;
			parameter [9:0] Time = 10'h384;
			parameter [9:0] SpikeW = 10'd35;
			parameter [9:0] SpikeH = 10'd35;
			parameter [7:0] A = 8'h04;
			parameter [7:0] D = 8'd7;
			
			logic finito, finito_in;
			logic [9:0] Spike_X_Pos, Spike_X_Pos_in, Spike_Y_Pos, Spike_Y_Pos_in, Spike_X_Motion, Spike_X_Motion_in, Spike_Y_Motion, Spike_Y_Motion_in;
			enum logic [4:0] {Idle, Move, Stop} State, Next_State;
			logic frame_clk_delayed, frame_clk_rising_edge;
			logic	[9:0] counter, counter_in;
			always_ff @ (posedge Clk) begin
				frame_clk_delayed <= frame_clk;
				frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
			end
			always_ff @(posedge frame_clk or posedge Reset)
				begin
					if(Reset)
						begin
							counter<= 10'd0;
						end
					else
						begin
							counter <= counter_in + 1'b1;
						end
				end
							
			always_ff @(posedge Clk)
				begin
					if(GG)
						begin
							Spike_X_Motion <= 10'd0;
							Spike_Y_Motion <= 10'd0;
						end
					if(Reset)
						begin
							Spike_X_Pos <= Spike_X_Center;
							Spike_Y_Pos <= Spike_Y_Center;
							Spike_X_Motion <= 10'd0;
							Spike_Y_Motion <= 10'd0;
							finito <= 1'b0;
							State <= Idle;
						end
					else if(spawn)
						begin
							Spike_X_Pos <= Spike_X_Spawn;
							Spike_Y_Pos <= Spike_Y_Spawn;
							State <= Move;
							finito <= 1'b0;
						end
					else
						begin
							Spike_X_Pos <= Spike_X_Pos_in;
							Spike_Y_Pos <= Spike_Y_Pos_in;
							Spike_X_Motion <= Spike_X_Motion_in;
							Spike_Y_Motion <= Spike_Y_Motion_in;
							finito <= finito_in;
							State <= Next_State;
						end
			end
  always_comb
    begin
        // By default, keep motion and position unchanged
        Spike_X_Pos_in = Spike_X_Pos;
        Spike_Y_Pos_in = Spike_Y_Pos;
        Spike_X_Motion_in = Spike_X_Motion;
        Spike_Y_Motion_in = Spike_Y_Motion;
        counter_in = counter;
		  finito_in = finito;
		  Next_State = State;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
				begin
					unique case (State)
						Idle:
							begin
								
								Spike_X_Motion_in = 10'd0;
								Spike_Y_Motion_in = 10'd0;
								finito_in = 1'b0;
								if(spawn)
									begin
										counter_in = 10'd0;
										Next_State = Move;
									end
							end
						Move:
							begin
								if(counter <= Time)
									begin
										 if( Spike_Y_Pos + SpikeH >= Spike_Y_Max )
											begin
												Spike_Y_Motion_in = (~(Spike_Y_Step) + 1'b1); 
											end	
										 else if (Spike_Y_Pos <= Spike_Y_Min)
											begin
												Spike_Y_Motion_in = Spike_Y_Step;
											end
										else if( Spike_X_Pos + SpikeW >= Spike_X_Max )
											begin
												Spike_X_Motion_in = (~(Spike_X_Step) + 1'b1); 
											end	
										 else if (Spike_X_Pos <= Spike_X_Min)
											begin
												Spike_Y_Motion_in = Spike_Y_Step;
											end
										else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
											begin
												Spike_X_Motion_in = (~(Spike_X_Step) + 1'b1) + Cowboy_X_Step;
											end
										else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
											begin
												Spike_X_Motion_in = (~(Spike_X_Step)+1'b1) + (~(Cowboy_X_Step) + 1'b1);
											end
									end
									else if(counter >= Time)
										begin
											Next_State = Stop;
										end
								end
							Stop:
								begin
									finito_in = 1'b1;
									Next_State = Idle;
								end
							default:;
						endcase
					Spike_X_Pos_in = Spike_X_Pos + Spike_X_Motion;
					Spike_Y_Pos_in = Spike_Y_Pos + Spike_Y_Motion;
        end
        
        
    end
    assign SpikeX = Spike_X_Pos;
	 assign SpikeY = Spike_Y_Pos;
	 assign done = finito;
endmodule
	