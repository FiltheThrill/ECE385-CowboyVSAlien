//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

module lab8( input					CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk, GGC, GGA, GG,  ursick, enable, start, AVC, spawn, done;
	 logic [7:0] key0, key1, key2, key3, key4, key5, random;
	 logic [12:0] endgamec;
	 logic [15:0] score;
	 logic [1:0] hp;
    assign Clk = CLOCK_50;
	 assign GG = (GGC | GGA);
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    logic [9:0] 	DrawX, DrawY, 
						CowboyX, CowboyY, 
						PlatformX, PlatformY,
						Platform1X, Platform1Y,
						Platform2X, Platform2Y,
						Platform3X, Platform3Y,
						PowerupX, PowerupY,
						AlienX, AlienY,
						LaserX, LaserY,
						UFOX, UFOY,
						Start0X, Start0Y,
						Start1X, Start1Y,
						Start2X, Start2Y,
						End0X, End0Y,
						End1X, End1Y,
						CloudX, CloudY,
						SpikeX, SpikeY,
						Cactus0X, Cactus0Y,
						Cactus1X, Cactus1Y,
						Cactus2X, Cactus2Y,
						Cactus3X, Cactus3Y,
						SaloonX, SaloonY,
						GroundX0, GroundY0,
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
						GroundX17, GroundY17;
	 logic [0:42][0:26][0:3] cowboy;
	 logic [0:11][0:57][0:3] platform;
	 logic [0:12][0:57][0:3] ground;
	 logic [0:57][0:57][0:3] alien;
	 logic [0:7][0:3][0:3] laser;
	 logic [0:40][0:26][0:3] cactus;
	 logic [0:24][0:68][0:3] UFO;
	 logic [0:39][0:79][0:3] cloud;
	 logic [0:75][0:493][0:0] cowboy_txt;
	 logic [0:75][0:111][0:0] vs;
	 logic [0:75][0:285][0:0] alien_txt;
	 logic [0:75][0:266][0:0] win;
	 logic [0:151][0:106][0:2] saloons;
	 logic [0:24][0:24][0:1] power;
	 logic [0:34][0:34][0:3] spike;
	 
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(key0),
									  .keycode1_export(key1),
									  .keycode2_export(key2),
									  .keycode3_export(key3),
									  .keycode4_export(key4),
									  .keycode5_export(key5),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
														 .Clk(Clk),         // 50 MHz clock
                                           .Reset(Reset_h),       // Active-high reset signal
														 .VGA_HS(VGA_HS),      // Horizontal sync pulse.  Active low
                                           .VGA_VS(VGA_VS),      // Vertical sync pulse.  Active low
														 .VGA_CLK(VGA_CLK),     // 25 MHz VGA clock input
														 .VGA_BLANK_N(VGA_BLANK_N), // Blanking interval indicator.  Active low.
                                           .VGA_SYNC_N(VGA_SYNC_N),  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                                        // but the video DAC on the DE2 board requires an input for it.
														 .DrawX(DrawX),       
                                           .DrawY(DrawY) 
	);
    
    // Which signal should be frame_clk?
    Cowboy rootin_and_tootin(
									  .Clk(Clk),                
                             .Reset(Reset_h),              // Active-high reset signal
                             .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
									  .GG(GG),
									  .key0(key0),
									  .key1(key1),
								     .key2(key2),
								     .key3(key3),
									  .key4(key4),
									  .key5(key5),      
									  .CowboyX(CowboyX),
									  .CowboyY(CowboyY),
									  .PlatformX(PlatformX),
									  .PlatformY(PlatformY),
									  .Platform1X(Platform1X),
									  .Platform1Y(Platform1Y),
									  .Platform2X(Platform2X),
								     .Platform2Y(Platform2Y),
									  .Platform3X(Platform3X),
									  .Platform3Y(Platform3Y)
									  
								);
	
	platforms platform_instance(
											.Clk(Clk),
											.Reset(Reset_h),
											.frame_clk(VGA_VS),
											.GG(GG),
											.key0(key0),
											.key1(key1),
											.key2(key2),
											.key3(key3),
											.key4(key4),
											.key5(key5),
											.random(random),
											.PlatformX(PlatformX),
											.PlatformY(PlatformY),
											.Platform1X(Platform1X),
											.Platform1Y(Platform1Y),
											.Platform2X(Platform2X),
											.Platform2Y(Platform2Y),
											.Platform3X(Platform3X),
											.Platform3Y(Platform3Y)
										);
	Alien alien_instance(
									.Clk(Clk),
									.Reset(Reset_h),
									.frame_clk(VGA_VS),
									.GG(GG),
									.key0(key0),
									.key1(key1),
									.key2(key2),
									.key3(key3),
									.key4(key4),
									.key5(key5),
									.AlienX(AlienX),
									.AlienY(AlienY)
								);
	ground mostspedthing(
										.Clk(Clk),
										.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.GG(GG),
										.key0(key0),
										.key1(key1),
										.key2(key2),
										.key3(key3),
										.key4(key4),
										.key5(key5),
										.GroundX0(GroundX0),
										.GroundY0(GroundY0),
										.GroundX1(GroundX1),
										.GroundY1(GroundY1),
										.GroundX2(GroundX2),
										.GroundY2(GroundY2),
										.GroundX3(GroundX3),
										.GroundY3(GroundY3),
										.GroundX4(GroundX4),
										.GroundY4(GroundY4),
										.GroundX5(GroundX5),
										.GroundY5(GroundY5),
										.GroundX6(GroundX6),
										.GroundY6(GroundY6),
										.GroundX7(GroundX7),
										.GroundY7(GroundY7),
										.GroundX8(GroundX8),
										.GroundY8(GroundY8),
										.GroundX9(GroundX9),
										.GroundY9(GroundY9),
										.GroundX10(GroundX10),
										.GroundY10(GroundY10),
										.GroundX11(GroundX11),
										.GroundY11(GroundY11),
										.GroundX12(GroundX12),
										.GroundY12(GroundY12),
										.GroundX13(GroundX13),
										.GroundY13(GroundY13),
										.GroundX14(GroundX14),
										.GroundY14(GroundY14),
										.GroundX15(GroundX15),
										.GroundY15(GroundY15),
										.GroundX16(GroundX16),
										.GroundY16(GroundY16),
										.GroundX17(GroundX17),
										.GroundY17(GroundY17)
									);
	 ALaser PewPew(
										.Clk(Clk),
										.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.GG(GG),
										.key0(key0),
										.key1(key1),
										.key2(key2),
										.key3(key3),
										.key4(key4),
										.key5(key5),
										.AlienX(AlienX),
										.AlienY(AlienY),
										.LaserX(LaserX),
										.LaserY(LaserY)
									);
	
	 saloon Salty_Spitoon(
										.Clk(Clk),
										.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.GG(GG),
										.ursick(ursick),
										.key0(key0),
										.key1(key1),
										.key2(key2),
										.key3(key3),
										.key4(key4),
										.key5(key5),
										.SaloonX(SaloonX),
										.SaloonY(SaloonY)
										
									);
	 collision hitboxes(
									.Clk(Clk),
									.Reset(Reset_h),
									.frame_clk(VGA_VS),
									.GGC(GGC),
									.GGA(GGA),
									.key0(key0),
									.key1(key1),
									.key2(key2),
									.key3(key3),
									.key4(key4),
									.key5(key5),
									.AVC(AVC),
									.hp(hp),
									.done(done),
									.spawn(spawn),
									.CowboyY(CowboyY),
									.CowboyX(CowboyX),
									.SpikeX(SpikeX),
									.SpikeY(SpikeY),
									.LaserX(LaserX),
									.LaserY(LaserY),
									.Cactus0X(Cactus0X),
									.Cactus0Y(Cactus0Y),
									.Cactus1X(Cactus1X),
									.Cactus1Y(Cactus0Y),
									.Cactus2X(Cactus2X),
									.Cactus2Y(Cactus2Y),
									.Cactus3X(Cactus3X),
									.Cactus3Y(Cactus3Y),
									.SaloonX(SaloonX),
									.SaloonY(SaloonY),
									.PowerupX(PowerupX),
									.PowerupY(PowerupY)
								);	
	cactus pricklyboi(
								.Clk(Clk),
								.Reset(Reset_h),
								.frame_clk(VGA_VS),
								.GG(GG),
								.key0(key0),
								.key1(key1),
								.key2(key2),
								.key3(key3),
								.key4(key4),
								.key5(key5),
								.CactusX0(Cactus0X),
								.CactusY0(Cactus0Y),
								.CactusX1(Cactus1X),
								.CactusY1(Cactus1Y),
								.CactusX2(Cactus2X),
								.CactusY2(Cactus2Y),
								.CactusY3(Cactus3Y),
								.CactusX3(Cactus3X)
					);
	Spikeball Spigma(	
					.Reset(Reset_h),
					.frame_clk(VGA_VS),
					.*
				);
	Goal wereintheendgamenow(
						.Clk(Clk),
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
		    			.GG(GG),
						.key0(key0),
						.key1(key1),
						.key2(key2),
						.key3(key3),
						.key4(key4),
						.key5(key5),
						.ursick(ursick),
						.score(score),
						.endgamec(endgamec)
					);
	UFO spaceboi(
						.Clk(Clk),
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
		    			.GG(GG),
						.key0(key0),
						.key1(key1),
						.key2(key2),
						.key3(key3),
						.key4(key4),
						.key5(key5),
						.random(random),
						.UFOX(UFOX),
						.UFOY(UFOY)
					);
	Cloud Fluffyboi(
						.Clk(Clk),
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
		    			.GG(GG),
						.key0(key0),
						.key1(key1),
						.key2(key2),
						.key3(key3),
						.key4(key4),
						.key5(key5),
						.random(random),
						.CloudX(CloudX),
						.CloudY(CloudY)
					);
	
	Startscreen playthatfunkymusic(
									.Clk(Clk),
									.Reset(Reset_h),
									.frame_clk(VGA_VS),
									.key0(key0),
									.key1(key1),
									.key2(key2),
									.key3(key3),
									.key4(key4),
									.key5(key5),
									.start(start),
									.Start0X(Start0X),
									.Start0Y(Start0Y),
									.Start1X(Start1X),
									.Start1Y(Start1Y),
									.Start2X(Start2X),
									.Start2Y(Start2Y)
								);
	
	Endscreen stopthatfunkymusic(
									.Clk(Clk),
									.Reset(Reset_h),
									.frame_clk(VGA_VS),
									.End0X(End0X),
									.End0Y(End0Y),
									.End1X(End1X),
									.End1Y(End1Y)
								);
	
	powerup s3nd_nud3s(
								.Clk(Clk),
								.Reset(Reset_h),
								.frame_clk(VGA_VS),
								.PowerupX(PowerupX),
								.PowerupY(PowerupY),
								.AVC(AVC),
								.GG(GG),
								.key0(key0),
								.key1(key1),
								.key2(key2),
								.key3(key3),
								.key4(key4),
								.key5(key5),
								.random(random)
							);
								
								
    color_mapper its2019colorshouldntmatter(
											.hp(hp),
											.start(start),
											.GGC(GGC),
											.GGA(GGA),
											.AVC(AVC),
											.DrawX(DrawX),
											.DrawY(DrawY),
											.CowboyX(CowboyX),
											.CowboyY(CowboyY),
											.PlatformX(PlatformX),
											.PlatformY(PlatformY),
											.Platform1X(Platform1X),
											.Platform1Y(Platform1Y),
											.Platform2X(Platform2X),
											.Platform2Y(Platform2Y),
											.Platform3X(Platform3X),
											.Platform3Y(Platform3Y),
											.UFOX(UFOX),
											.UFOY(UFOY),
											.SpikeX(SpikeX),
											.SpikeY(SpikeY),
											.CloudX(CloudX),
											.CloudY(CloudY),
											.AlienX(AlienX),
											.AlienY(AlienY),
											.LaserX(LaserX),
											.LaserY(LaserY),
											.Start0X(Start0X),
											.Start0Y(Start0Y),
											.Start1X(Start1X),
											.Start1Y(Start1Y),
											.Start2X(Start2X),
											.Start2Y(Start2Y),
											.End0X(End0X),
											.End0Y(End0Y),
											.End1X(End1X),
											.End1Y(End1Y),
											.GroundX0(GroundX0),
											.GroundY0(GroundY0),
											.GroundX1(GroundX1),
											.GroundY1(GroundY1),
											.GroundX2(GroundX2),
											.GroundY2(GroundY2),
											.GroundX3(GroundX3),
											.GroundY3(GroundY3),
											.GroundX4(GroundX4),
											.GroundY4(GroundY4),
											.GroundX5(GroundX5),
											.GroundY5(GroundY5),
											.GroundX6(GroundX6),
											.GroundY6(GroundY6),
											.GroundX7(GroundX7),
											.GroundY7(GroundY7),
											.GroundX8(GroundX8),
											.GroundY8(GroundY8),
											.GroundX9(GroundX9),
											.GroundY9(GroundY9),
											.GroundX10(GroundX10),
											.GroundY10(GroundY10),
											.GroundX11(GroundX11),
											.GroundY11(GroundY11),
											.GroundX12(GroundX12),
											.GroundY12(GroundY12),
											.GroundX13(GroundX13),
											.GroundY13(GroundY13),
											.GroundX14(GroundX14),
											.GroundY14(GroundY14),
											.GroundX15(GroundX15),
											.GroundY15(GroundY15),
											.GroundX16(GroundX16),
											.GroundY16(GroundY16),
											.GroundX17(GroundX17),
											.GroundY17(GroundY17),
											.SaloonX(SaloonX),
											.SaloonY(SaloonY),
											.Cactus0X(Cactus0X),
											.Cactus0Y(Cactus0Y),
											.Cactus1X(Cactus1X),
											.Cactus1Y(Cactus1Y),
											.Cactus2X(Cactus2X),
											.Cactus2Y(Cactus2Y),
											.Cactus3Y(Cactus3Y),
											.Cactus3X(Cactus3X),
											.PowerupX(PowerupX),
											.PowerupY(PowerupY),
											.cowboy(cowboy),
											.platform(platform),
											.ground(ground),
											.alien(alien),
											.laser(laser),
											.cactus(cactus),
											.UFO(UFO),
											.spike(spike),
											.cloud(cloud),
											.cowboy_txt(cowboy_txt),
											.alien_txt(alien_txt),
											.vs(vs),
											.win(win),
											.power(power),
											.saloons(saloons),
											.VGA_R(VGA_R),
											.VGA_B(VGA_B),
											.VGA_G(VGA_G)
	 );
	 LFSR random_dancing(
										.Clk(Clk),
										.enable(1'b1),
										.Reset(Reset_h),
										.random(random)
								);
	 Sprite_Table Coke_is_Better(
									.CLK(VGA_VS),
									.cowboy(cowboy),
									.platform(platform),
									.ground(ground),
									.alien(alien),
									.laser(laser),
									.cactus(cactus),
									.UFO(UFO),
									.cloud(cloud),
									.cowboy_txt(cowboy_txt),
									.alien_txt(alien_txt),
									.vs(vs),
									.power(power),
									.win(win),
									.saloons(saloons),
									.spike(spike)
								);
	
    
   
    HexDriver hex_inst_0 (endgamec[3:0], HEX0);
    HexDriver hex_inst_1 (endgamec[7:4], HEX1);
	 HexDriver hex_inst_2 (endgamec[11:8], HEX2);
    HexDriver hex_inst_3 ({3'b0, ursick}, HEX3);
	 HexDriver hex_inst_4 (key2[3:0], HEX4);
    HexDriver hex_inst_5 (key2[7:4], HEX5);
    
    
endmodule
