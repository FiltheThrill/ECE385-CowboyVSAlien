//-------------------------------------------------------------------------
//    Platform.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  platforms( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk, 
									  GG,
					input [7:0]	  key0, key1, key2, key3, key4, key5, random,
               output [9:0]  PlatformX, PlatformY,             // Whether current pixel belongs to Platform or background
									  Platform1X, Platform1Y,
									  Platform2X, Platform2Y,
									  Platform3X, Platform3Y 
              );
    
    parameter [9:0] Platform_X_Center = 10'd300;  // Center position on the X axis
    parameter [9:0] Platform_Y_Center = 10'd400;  // Center position on the Y axis
	 parameter [9:0] Platform1_X_Center = 10'd500;  // Center position on the X axis
    parameter [9:0] Platform1_Y_Center = 10'd370;
	 parameter [9:0] Platform2_X_Center = 10'd105;  // Center position on the X axis
    parameter [9:0] Platform2_Y_Center = 10'd300;
	 parameter [9:0] Platform3_X_Center = 10'd400;  // Center position on the X axis
    parameter [9:0] Platform3_Y_Center = 10'd275;
    parameter [9:0] Platform_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Platform_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Platform_X_Step = 10'd2;      // Step size on the X axis
	 parameter [7:0] A = 8'h04;
	 parameter [7:0] D = 8'd7;
    logic [9:0] Platform_X_Pos, Platform_X_Motion, Platform_Y_Pos, Platform_Y_Motion, Platform1_X_Pos, 
					 Platform1_Y_Pos, Platform2_X_Pos, Platform2_Y_Pos, Platform3_X_Pos, Platform3_Y_Pos;
    logic [9:0] Platform_X_Pos_in, Platform_X_Motion_in, Platform_Y_Pos_in, Platform_Y_Motion_in, 
					 Platform1_X_Pos_in, Platform1_Y_Pos_in, Platform2_X_Pos_in, Platform2_Y_Pos_in,
					 Platform3_X_Pos_in, Platform3_Y_Pos_in;
    
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
            Platform_X_Pos <= Platform_X_Center;
            Platform_Y_Pos <= Platform_Y_Center;
				Platform1_X_Pos <= Platform1_X_Center;
            Platform1_Y_Pos <= Platform1_Y_Center;
				Platform2_X_Pos <= Platform2_X_Center;
            Platform2_Y_Pos <= Platform2_Y_Center;
				Platform3_X_Pos <= Platform3_X_Center;
            Platform3_Y_Pos <= Platform3_Y_Center;
            Platform_X_Motion <= 10'd0;
				
  		  end
		  else
			begin
				if((Platform_X_Pos >= 10'd845) && (Platform_X_Pos <= 10'd850))
					begin
						if(Platform_Y_Pos >= Platform_Y_Center)
							begin
								Platform_Y_Pos <= (Platform_Y_Pos - {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								//Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
						else
							begin
								Platform_Y_Pos <= (Platform_Y_Pos + {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								//Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
					end
				else if((Platform1_X_Pos >= 10'd845) && (Platform1_X_Pos <= 10'd850))
					begin
						if(Platform1_Y_Pos >= Platform1_Y_Center)
							begin
								Platform1_Y_Pos <= (Platform1_Y_Pos - {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								//Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
						else
							begin
								Platform1_Y_Pos <= (Platform1_Y_Pos + {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								//Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
					end
				else if((Platform2_X_Pos >= 10'd845) && (Platform2_X_Pos <= 10'd850))
					begin
						if(Platform2_Y_Pos >= Platform2_Y_Center)
							begin
								Platform2_Y_Pos <= (Platform2_Y_Pos - {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								//Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
						else
							begin
								Platform2_Y_Pos <= (Platform2_Y_Pos + {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								//Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
					end
				else if((Platform3_X_Pos >= 10'd825) && (Platform3_X_Pos <= 10'd850))
					begin
						if(Platform3_Y_Pos >= Platform3_Y_Center)
							begin
								Platform3_Y_Pos <= (Platform3_Y_Center - {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								//Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
						else
							begin
								Platform3_Y_Pos <= (Platform3_Y_Center + {3'b0, random[5:0]});
								Platform_X_Pos <= Platform_X_Pos_in;
								Platform_Y_Pos <= Platform_Y_Pos_in;
								Platform1_X_Pos <= Platform1_X_Pos_in;
								Platform1_Y_Pos <= Platform1_Y_Pos_in;
								Platform2_X_Pos <= Platform2_X_Pos_in;
								Platform2_Y_Pos <= Platform2_Y_Pos_in;
								Platform3_X_Pos <= Platform3_X_Pos_in;
								//Platform3_Y_Pos <= Platform3_Y_Pos_in;
								Platform_X_Motion <= Platform_X_Motion_in;
								Platform_Y_Motion <= Platform_Y_Motion_in;
							end
					end
				else
					begin		
						Platform_X_Pos <= Platform_X_Pos_in;
						Platform_Y_Pos <= Platform_Y_Pos_in;
						Platform1_X_Pos <= Platform1_X_Pos_in;
						Platform1_Y_Pos <= Platform1_Y_Pos_in;
						Platform2_X_Pos <= Platform2_X_Pos_in;
						Platform2_Y_Pos <= Platform2_Y_Pos_in;
						Platform3_X_Pos <= Platform3_X_Pos_in;
						Platform3_Y_Pos <= Platform3_Y_Pos_in;
						Platform_X_Motion <= Platform_X_Motion_in;
						Platform_Y_Motion <= Platform_Y_Motion_in;
					end
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Platform_X_Pos_in = Platform_X_Pos;
        Platform_Y_Pos_in = Platform_Y_Pos;
		  Platform1_X_Pos_in = Platform1_X_Pos;
        Platform1_Y_Pos_in = Platform1_Y_Pos;
		  Platform2_X_Pos_in = Platform2_X_Pos;
        Platform2_Y_Pos_in = Platform2_Y_Pos;
		  Platform3_X_Pos_in = Platform3_X_Pos;
        Platform3_Y_Pos_in = Platform3_Y_Pos;
        Platform_X_Motion_in = Platform_X_Motion;
        Platform_Y_Motion_in = Platform_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
       if (frame_clk_rising_edge)
				begin
					if(GG == 1'b1)
						begin
							Platform_X_Motion_in = 10'd0;
						end
					else if((key0 == A) || (key1 == A) || (key2 == A) || (key3 == A) || (key4 == A) || (key5 == A))
								begin
									Platform_X_Motion_in = Platform_X_Step;
								end
					else if((key0 == D) || (key1 == D) || (key2 == D) || (key3 == D) || (key4 == D) || (key5 == D))
								begin
									Platform_X_Motion_in = (~(Platform_X_Step)+1'b1);
								end
					
					else
								begin
									Platform_X_Motion_in = 10'd0;
								end
				 
           
        
            // Update the Platform's position with its motion
            Platform_X_Pos_in = Platform_X_Pos + Platform_X_Motion;
            Platform_Y_Pos_in = Platform_Y_Pos + Platform_Y_Motion;
				Platform1_X_Pos_in = Platform1_X_Pos + Platform_X_Motion;
            Platform1_Y_Pos_in = Platform1_Y_Pos + Platform_Y_Motion;
				Platform2_X_Pos_in = Platform2_X_Pos + Platform_X_Motion;
            Platform2_Y_Pos_in = Platform2_Y_Pos + Platform_Y_Motion;
				Platform3_X_Pos_in = Platform3_X_Pos + Platform_X_Motion;
            Platform3_Y_Pos_in = Platform3_Y_Pos + Platform_Y_Motion;
				
        end
        
      
    end
    
 
   
    assign PlatformX = Platform_X_Pos;
    assign PlatformY = Platform_Y_Pos;
	 assign Platform1X = Platform1_X_Pos;
    assign Platform1Y = Platform1_Y_Pos;
	 assign Platform2X = Platform2_X_Pos;
    assign Platform2Y = Platform2_Y_Pos;
	 assign Platform3X = Platform3_X_Pos;
    assign Platform3Y = Platform3_Y_Pos;
    
    
endmodule 