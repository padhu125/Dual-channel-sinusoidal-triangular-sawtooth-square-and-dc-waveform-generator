// Top level file for GPIO example for Xilinx XUP Blackboard rev D 
// (gpio_system_top.sv)
// Jason Losh
//
// 32-bit GPIO port:
//   GPIO port for IP module tied to GPIO [23:0]
//   INTR debug output for IP module tied to RGB0[1]
//   AXI4-lite aperature memory offset is 0x00000000

module gpio_system_top (
    input CLK100,
    output [9:0] LED,       // RGB1, RGB0, LED 9..0 placed from left to right
    output [2:0] RGB0,      
    output [2:0] RGB1,
    output [3:0] SS_ANODE,   // Anodes 3..0 placed from left to right
    output [7:0] SS_CATHODE, // Bit order: DP, G, F, E, D, C, B, A
    input [11:0] SW,         // SWs 11..0 placed from left to right
    input [3:0] PB,          // PBs 3..0 placed from left to right
    //inout [23:0] GPIO,       // PMODA-C 1P, 1N, ... 3P, 3N order
    inout [23:0] GPIO,       // PMODA-C 1P, 1N, ... 3P, 3N order
    output [3:0] SERVO,      // Servo outputs
    output PDM_SPEAKER,      // PDM signals for mic and speaker
    input PDM_MIC_DATA,      
    output PDM_MIC_CLK,
    output ESP32_UART1_TXD,  // WiFi/Bluetooth serial interface 1
    input ESP32_UART1_RXD,
    output IMU_SCLK,         // IMU spi clk
    output IMU_SDI,          // IMU spi data input
    input IMU_SDO_AG,        // IMU spi data output (accel/gyro)
    input IMU_SDO_M,         // IMU spi data output (mag)
    output IMU_CS_AG,        // IMU cs (accel/gyro) 
    output IMU_CS_M,         // IMU cs (mag)
    input IMU_DRDY_M,        // IMU data ready (mag)
    input IMU_INT1_AG,       // IMU interrupt (accel/gyro)
    input IMU_INT_M,         // IMU interrupt (mag)
    output IMU_DEN_AG,       // IMU data enable (accel/gyro)
    inout [14:0]DDR_addr,
    inout [2:0]DDR_ba,
    inout DDR_cas_n,
    inout DDR_ck_n,
    inout DDR_ck_p,
    inout DDR_cke,
    inout DDR_cs_n,
    inout [3:0]DDR_dm,
    inout [31:0]DDR_dq,
    inout [3:0]DDR_dqs_n,
    inout [3:0]DDR_dqs_p,
    inout DDR_odt,
    inout DDR_ras_n,
    inout DDR_reset_n,
    inout DDR_we_n,
    inout FIXED_IO_ddr_vrn,
    inout FIXED_IO_ddr_vrp,
    inout [53:0]FIXED_IO_mio,
    inout FIXED_IO_ps_clk,
    inout FIXED_IO_ps_porb,
    inout FIXED_IO_ps_srstb
    );
     
    // Terminate all of the unused outputs or i/o's
    // assign LED = 10'b0000000000;
    //assign RGB0 = 3'b000;
    assign RGB1 = 3'b000;
    // assign SS_ANODE = 4'b0000;
    // assign SS_CATHODE = 8'b11111111;
    // assign GPIO = 24'bzzzzzzzzzzzzzzzzzzzzzzzz;
    assign SERVO = 4'b0000;
    assign PDM_SPEAKER = 1'b0;
    assign PDM_MIC_CLK = 1'b0;
    assign ESP32_UART1_TXD = 1'b0;
    assign IMU_SCLK = 1'b0;
    assign IMU_SDI = 1'b0;
    assign IMU_CS_AG = 1'b1;
    assign IMU_CS_M = 1'b1;
    assign IMU_DEN_AG = 1'b0;

    // display g (gpio) on left seven segment display
    assign SS_ANODE = 4'b0111;
    assign SS_CATHODE = 8'b10010000;

    // Tie gpio to PMOD connectors
    wire [31:0] gpio_data_in;
    wire [31:0] gpio_data_out;
    wire [31:0] gpio_data_oe;
    
    wire AXI_AWREADY;
    wire M00_AXI_AWVALID;
    wire [4:0]M00_AXI_AWDDR; 
    
    /*
    
  
    wire    clk_8M_Hz;
    reg    clk_4MHz;
    reg       CS_tmp;
    wire     LDAC_tmp;
    reg     [11:0] data_tmp;
    reg  clk_out_tmp;
    
    */
    
    // Lab 6 signals
    
    wire  CS_tmp_0;
    wire LDAC_tmp_0;
    wire  [11:0] data_tmp_0;
    wire  clk_out_tmp_0;
    
    /*
    
  wire [31:0] mode_reg;
  wire [31:0] run_reg;
  wire [31:0] freq_aa_0;
  wire [31:0] freq_bb_0;
  wire signed [15:0] offset_a_0;
  wire signed [15:0] offset_b_0;
  wire [15:0] amplitude_a_0;
  wire [15:0] amplitude_b_0;
  wire [15:0] dtycyc_a_0;
  wire [15:0] dtycyc_b_0;
  wire [15:0] cycles_a_0;
  wire [15:0] cycles_b_0;
  
  wire [11:0] MSBs_out_1_inst;
  wire [11:0] MSBs_out_2_inst;
  
  wire en_inst;
    
    wire [11:0]addra;
    wire [11:0]addrb;
    wire signed [15:0] douta_inst;
    wire signed [15:0] doutb_inst;
    wire ena;
    wire enb;
    
    wire signed [15:0] output_after_calib_inst;
    wire signed [15:0] output_after_calib_inst_2;
    wire  [11:0] unsigned_output_inst;
    wire  [11:0] unsigned_output_inst_2;
    
    wire [11:0]waveforms_data_DACA_out_0;
    wire [11:0]waveforms_data_DACB_out_0;
    wire waveforms_enable_0;
    
    
  reg LDAC_tmp_del        ;
  reg LDAC_tmp_fall       ;
  
  wire [11:0] output_data_1_inst;
   wire [11:0] output_data_1_inst_2;
   
   wire signed [15:0] triangle_output_1;
   wire signed [15:0] triangle_output_2;
   
   wire signed [15:0] sawtooth_output_1;
   wire signed [15:0] sawtooth_output_2;
   
    wire signed [15:0] square_output_1;
    wire signed [15:0] square_output_2;
    
    wire signed [15:0] dc_out_1;
     wire signed [15:0] dc_out_2;
     
     wire signed [15:0] mux_out_1;
      wire signed [15:0] mux_out_2;
    
    wire [31:0] mode;
    wire [31:0] run;
    
   // Lab 6 Instantiations
   
// Virt virto(
//.clk(CLK100),
//.probe_out0(freq_aa_0),
//.probe_out1(amplitude_a_0),
//. probe_out2(offset_a_0),
//.probe_out3(freq_bb_0),
//.probe_out4(amplitude_b_0),
//.probe_out5(offset_b_0),
//.probe_out6(dtycyc_a_0),
//.probe_out7(dtycyc_b_0),
//.probe_out8(cycles_a_0),
//.probe_out9(cycles_b_0),
//.probe_out10(mode_reg),
//.probe_out11(run_reg)
//);

  
  always @(posedge CLK100)
  begin
    LDAC_tmp_del <= LDAC_tmp     ;
  end 
  
  assign LDAC_tmp_fall = LDAC_tmp_del & ~LDAC_tmp ;

 (* core_use_dsp = "yes" *)  phase_accumulator pa_inst( .mode(mode_reg),
                           .run(run_reg),
                           .clk            (CLK100),
                           .en                (LDAC_tmp_fall), // 32 bits
                           .frequency_in_1    (freq_aa_0), // 32 bits
                           .frequency_in_2    (freq_bb_0), // 32 bits
                           .cycles_a (cycles_a_0),
                           .cycles_b (cycles_b_0),
                           .MSBs_out_1        (MSBs_out_1_inst), // 12 bits reg goes to bram addra
                           .MSBs_out_2        (MSBs_out_2_inst)  // 12 bits goes to bram addrb
                            );

   blk_mem_gen_0 bram (.clka(CLK100),    // input wire clka
                       
                       .addra(MSBs_out_1_inst),  // input wire [11 : 0] addra
                       .douta(douta_inst),  // output wire [15 : 0] douta
                       .clkb(CLK100),    // input wire clkb
                       
                       .addrb(MSBs_out_2_inst),  // input wire [11 : 0] addrb
                       .doutb(doutb_inst)   // output wire [15 : 0] doutb
                      );
                      
              
   
                     
triangle triangle_inst (.mode(mode_reg),
                        .run(run_reg),
                        .clk              (CLK100),                   // Clock input
                        .en               (LDAC_tmp_fall),
                        .countt           (triangle_output_1), // 15 bit signed output
                        .countt_2         (triangle_output_2), // 15 bit signed output
                        .input_frequency_A(freq_aa_0),
                        .input_frequency_B(freq_bb_0),
                        .Cycle_A          (cycles_a_0),
                        .Cycle_B          (cycles_b_0),
                        .Amplitude_A      (amplitude_a_0),
                        .Amplitude_B      (amplitude_b_0),
                        .Offset_A         (offset_a_0),
                        .Offset_B         (offset_b_0)
                       );
                      
                   
                       
               
                       
   sawtooth  sawtooth(.mode(mode_reg),
                        .run(run_reg),
              .clk               (CLK100),                   // Clock input
              .en                (LDAC_tmp_fall),
              .countt            (sawtooth_output_1), // N-bit signed counter output
              .countt_2          (sawtooth_output_2),
              .input_frequency_A (freq_aa_0),
              .input_frequency_B (freq_bb_0),
              .Cycle_A           (cycles_a_0),
              .Cycle_B           (cycles_b_0),
              .Amplitude_A       (amplitude_a_0),
              .Amplitude_B       (amplitude_b_0),
              .Offset_A          (offset_a_0),
              .Offset_B          (offset_b_0)
);         

   dc_wavegen  dc_wavegen(.mode(mode_reg),
                        .run(run_reg),
              .clk               (CLK100),                   // Clock input
              .en                (LDAC_tmp_fall),
              .countt            (dc_out_1), // N-bit signed counter output
              .countt_2          (dc_out_2),
              .Offset_A          (offset_a_0),
              .Offset_B          (offset_b_0),
              .Cycle_A           (cycles_a_0),
              .Cycle_B           (cycles_b_0)

);     






 square sq_inst(.mode(mode_reg),
                .run(run_reg),
                .clk                     (CLK100),                   // Clock input4
                .en               (LDAC_tmp_fall),
                .countt         (square_output_1), // N-bit signed counter output
                .countt_2       (square_output_2),
                .input_frequency_A    (freq_aa_0),
                .input_frequency_B    (freq_bb_0),
                .Cycle_A             (cycles_a_0),
                .Cycle_B             (cycles_b_0),
                .Amplitude_A      (amplitude_a_0),
                .Amplitude_B      (amplitude_b_0),
                .Offset_A            (offset_a_0),
                .Offset_B            (offset_b_0),
                .Duty_A              (dtycyc_a_0),
                .Duty_B              (dtycyc_b_0)
);        


(* core_use_dsp = "yes" *)DemuxModule DemuxModule_in(
                .mode(mode_reg),
                .run(run_reg),
                .clk                     (CLK100),                   // Clock input4
                .en               (LDAC_tmp_fall),
                .dc_1             (dc_out_1),
                .dc_2               (dc_out_2),
                .sine_1             (douta_inst >>> 1),
                .sine_2             (doutb_inst >>> 1),
                .saw_1              (sawtooth_output_1),
                .saw_2              (sawtooth_output_2),
                .tri_1              (triangle_output_1),
                .tri_2              (triangle_output_2),
                .square_1           (square_output_1),
                .square_2           (square_output_2),
                .out_one            (mux_out_1),
                .out_two            (mux_out_2)
                );
                
calibration calibration_inst ( .clk                (CLK100),
                               .en(LDAC_tmp_fall),
                               .bit_input_sixteen  (mux_out_1),   // douta from bram goes here
                               .bit_input_sixteen_2(mux_out_2),
							   .output_after_calib (output_after_calib_inst), // [15:0] reg
							   .output_after_calib_2(output_after_calib_inst_2)
							  );  // 
							  
							  module signed_to_unsigned( input clk,
                           input en,
                           input [31:0] run,
                           input [31:0] mode,
                           input [15:0] amp1,
                           input [15:0] amp2,
                           input signed [15:0] off1,
                           input signed [15:0] off2,
                           input signed [15:0] signed_input,
                           input signed [15:0] signed_input_2,
                           output reg [11:0] unsigned_output,
                           output reg [11:0] unsigned_output_2); 
							  
signed_to_unsigned s_to_uinst (.clk                (CLK100),
                               .en(LDAC_tmp_fall),
                               .run(run_reg),
                               .mode(mode_reg),
                               .amp1(amplitude_a_0),
                               .amp2(amplitude_b_0),
                               .off1(offset_a_0),
                               .off2(offset_b_0),
                               .signed_input       (output_after_calib_inst),  // [15:0] output_after_calib 
                               .signed_input_2      (output_after_calib_inst_2),
							   .unsigned_output    (unsigned_output_inst),   // [11:0] reg
							   .unsigned_output_2   (unsigned_output_inst_2)
							  );
							  
							  
							  
Amp_Offset_Cycles Amp_Offset_Cycles_ins( .clk(CLK100),
                                         .en(LDAC_tmp_fall),
                                         .main_data(unsigned_output_inst),
                                         .main_data_2(unsigned_output_inst_2),
                                         .amplitude1(amplitude_a_0),
                                         .amplitude2(amplitude_b_0),
                                         .offset1(offset_a_0),
                                         .offset2(offset_b_0),
                                         .cycles1(),
                                         .cycles2(),
                                         .output_data_1(output_data_1_inst),
                                         .output_data_2(output_data_1_inst_2)	
                                        );	
                                        
                                        			  
   
    //divide_the_clk divide_the_clk (CLK100,clk_4MHz);
  
   (* core_use_dsp = "yes" *) Lab_5_1 Lab_5_1(.clk      (CLK100),
                    .reset    (PB[0])   ,
                    .SW_DATA  (unsigned_output_inst) ,
                    .SW_DATA_2 (unsigned_output_inst_2), // unsigned_output_inst
                    .PB1      (PB[1])   , 
                    .PB2      (PB[2])   ,
                    .CS       (CS_tmp)  ,      
                    .LDAC     (LDAC_tmp),   // 1 bit
                    .data     (data_tmp),   
                    .clk_out  (clk_out_tmp)
                    );
                    
                    */



    // pin control
    genvar j;
    
    //for (j = 0; j < 24; j = j + 1)
  for (j = 4; j < 23; j = j + 1)
        assign GPIO[j] = gpio_data_oe[j] ? gpio_data_out[j] : 1'bz;
        
    assign gpio_data_in = {8'b0, GPIO[23:0]};
    
    assign GPIO[0] = CS_tmp_0;
    assign GPIO[1] = clk_out_tmp_0;
    assign GPIO[2] = data_tmp_0;
    assign GPIO[3] = LDAC_tmp_0;
    
    // Tie intr output to RGB0 green LED
    wire intr;
    assign RGB0 = {1'b0, intr, 1'b0};


    // Instantiate system wrapper
    system_wrapper system (.AXI_AWREADY(AXI_AWREADY),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .M00_AXI_AWDDR(M00_AXI_AWDDR),
        .M00_AXI_AWVALID(M00_AXI_AWVALID),
        .CS_tmp_0(CS_tmp_0),
        .LDAC_tmp_0(LDAC_tmp_0),
        .clk_out_tmp_0(clk_out_tmp_0),
        .data_tmp_0(data_tmp_0)
      );
endmodule

