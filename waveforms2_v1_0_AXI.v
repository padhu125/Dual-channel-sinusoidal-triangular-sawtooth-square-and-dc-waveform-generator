
`timescale 1 ns / 1 ps

	module waveforms2_v1_0_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here. Only the 4 SPI signals should be here
		
		output wire  CS_tmp,
        output wire LDAC_tmp,
        output wire  [11:0] data_tmp,
        output wire  clk_out_tmp,
		
		/// AXI clock and reset        
        input wire S_AXI_ACLK,
        input wire S_AXI_ARESETN,

        // AXI write channel
        // address:  add, protection, valid, ready
        // data:     data, byte enable strobes, valid, ready
        // response: response, valid, ready 
        input wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
        input wire [2:0] S_AXI_AWPROT,
        input wire S_AXI_AWVALID,
        output wire S_AXI_AWREADY,
        
        input wire [31:0] S_AXI_WDATA,
        input wire [3:0] S_AXI_WSTRB,
        input wire S_AXI_WVALID,
        output wire  S_AXI_WREADY,
        
        output wire [1:0] S_AXI_BRESP,
        output wire S_AXI_BVALID,
        input wire S_AXI_BREADY,
        
        // AXI read channel
        // address: add, protection, valid, ready
        // data:    data, resp, valid, ready
        input wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
        input wire [2:0] S_AXI_ARPROT,
        input wire S_AXI_ARVALID,
        output wire S_AXI_ARREADY,
        
        output wire [31:0] S_AXI_RDATA,
        output wire [1:0] S_AXI_RRESP,
        output wire S_AXI_RVALID,
        input wire S_AXI_RREADY
    );


	// Register numbers
 
    localparam integer MODE_REG             = 3'b000;
    localparam integer RUN_REG              = 3'b001;
    localparam integer FREQ_A_REG           = 3'b010;
    localparam integer FREQ_B_REG           = 3'b011;
    localparam integer OFFSET_REG           = 3'b100;
    localparam integer AMPLITUDE_REG        = 3'b101;
    localparam integer DTYCYC_REG           = 3'b110;
    localparam integer CYCLES_REG           = 3'b111;
	
	// Internals
	//reg [31:0] latch_data;
	reg [31:0] mode;
    reg [31:0] run;
    reg [31:0] freq_a;
    reg [31:0] freq_b;
    reg [31:0] offset;
    reg [31:0] amplitude;
    reg [31:0] dtycyc;
    reg [31:0] cycles;
	
	wire [31:0]  mode_reg;
	wire [31:0]  run_reg;
    wire [31:0] freq_aa;
    wire [31:0] freq_bb;
	wire [15:0] offset_a;
	wire [15:0] offset_b;
	wire [15:0] amplitude_a;
	wire [15:0] amplitude_b;
	wire [15:0] dtycyc_a;
	wire [15:0] dtycyc_b;
	wire [15:0] cycles_a;
    wire [15:0] cycles_b;
	
	assign mode_reg     = mode;
    assign run_reg      = run;
	assign freq_aa      = freq_a;
	assign freq_bb      = freq_b;
	assign offset_a     = offset[15:0];
	assign offset_b     = offset[31:16];
	assign amplitude_a  = amplitude[15:0];
	assign amplitude_b  = amplitude[31:16];
	assign dtycyc_a     = dtycyc[15:0];
	assign dtycyc_b     = dtycyc[31:16];
	assign cycles_a     = cycles[15:0];
	assign cycles_b     = cycles[31:16];
	
    // Register map
    // ofs  fn
    //   0  data (r/w)
    //   4  out (r/w)
    //   8  od (r/w)
    //  12  int_enable (r/w)
    //  16  int_positive (r/w)
    //  20  int_negative (r/w)
    //  24  int_edge_mode (r/w)
    //  28  int_status_clear (r/w1c)
    

    
    // AXI4-lite signals
    reg axi_awready;
    reg axi_wready;
    reg [1:0] axi_bresp;
    reg axi_bvalid;
    reg axi_arready;
    reg [31:0] axi_rdata;
    reg [1:0] axi_rresp;
    reg axi_rvalid;
    
    // friendly clock, reset, and bus signals from master
    wire axi_clk           = S_AXI_ACLK;
    wire axi_resetn        = S_AXI_ARESETN;
    wire [31:0] axi_awaddr = S_AXI_AWADDR;
    wire axi_awvalid       = S_AXI_AWVALID;
    wire axi_wvalid        = S_AXI_WVALID;
    wire [3:0] axi_wstrb   = S_AXI_WSTRB;
    wire axi_bready        = S_AXI_BREADY;
    wire [31:0] axi_araddr = S_AXI_ARADDR;
    wire axi_arvalid       = S_AXI_ARVALID;
    wire axi_rready        = S_AXI_RREADY;    
    
    // assign bus signals to master to internal reg names
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;
    
    // Handle gpio input metastability safely
    reg [31:0] read_port_data;
    reg [31:0] pre_read_port_data;
	
    //always_ff @ (posedge(axi_clk))
    //begin
    //    pre_read_port_data <= gpio_data_in;
    //    read_port_data <= pre_read_port_data;
    //end

    // Assert address ready handshake (axi_awready) 
    // - after address is valid (axi_awvalid)
    // - after data is valid (axi_wvalid)
    // - while configured to receive a write (aw_en)
    // De-assert ready (axi_awready)
    // - after write response channel ready handshake received (axi_bready)
    // - after this module sends write response channel valid (axi_bvalid) 
    wire wr_add_data_valid = axi_awvalid && axi_wvalid;
    reg aw_en;
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
        begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
        end
        else
        begin
            if (wr_add_data_valid && ~axi_awready && aw_en)
            begin
                axi_awready <= 1'b1;
                aw_en <= 1'b0;
            end
            else if (axi_bready && axi_bvalid)
                begin
                    aw_en <= 1'b1;
                    axi_awready <= 1'b0;
                end
            else           
                axi_awready <= 1'b0;
        end 
    end

    // Capture the write address (axi_awaddr) in the first clock (~axi_awready)
    // - after write address is valid (axi_awvalid)
    // - after write data is valid (axi_wvalid)
    // - while configured to receive a write (aw_en)
    reg [C_S_AXI_ADDR_WIDTH-1:0] waddr;
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
            waddr <= 0;
        else if (wr_add_data_valid && ~axi_awready && aw_en)
            waddr <= axi_awaddr;
    end

    // Output write data ready handshake (axi_wready) generation for one clock
    // - after address is valid (axi_awvalid)
    // - after data is valid (axi_wvalid)
    // - while configured to receive a write (aw_en)
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
            axi_wready <= 1'b0;
        else
            axi_wready <= (wr_add_data_valid && ~axi_wready && aw_en);
    end       

    // Write data to internal registers
    // - after address is valid (axi_awvalid)
    // - after write data is valid (axi_wvalid)
    // - after this module asserts ready for address handshake (axi_awready)
    // - after this module asserts ready for data handshake (axi_wready)
    // write correct bytes in 32-bit word based on byte enables (axi_wstrb)
    // int_clear_request write is only active for one clock
    wire wr = wr_add_data_valid && axi_awready && axi_wready;
    integer byte_index;
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
        begin
            mode[31:0] <= 32'b0;
            run        <= 32'b0;
            freq_a     <= 32'b0;
            freq_b     <= 32'b0;
            offset     <= 32'b0;
            amplitude  <= 32'b0;
            dtycyc     <= 32'b0;
            cycles     <= 32'b0;
        end 
        else 
        begin
            if (wr)
            begin
                case (axi_awaddr[4:2])
                    MODE_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if ( axi_wstrb[byte_index] == 1) 
                                mode[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    RUN_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1)
                                run[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    FREQ_A_REG: 
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1)
                                freq_a[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    FREQ_B_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1)
                                freq_b[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    OFFSET_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1) 
                                offset[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    AMPLITUDE_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1)
                                amplitude[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    DTYCYC_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1)
                                dtycyc[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    CYCLES_REG:
                        for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                            if (axi_wstrb[byte_index] == 1)
                                cycles[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                endcase
            end
        //    else
        //        int_clear_request <= 32'b0;
        end
    end    

    // Send write response (axi_bvalid, axi_bresp)
    // - after address is valid (axi_awvalid)
    // - after write data is valid (axi_wvalid)
    // - after this module asserts ready for address handshake (axi_awready)
    // - after this module asserts ready for data handshake (axi_wready)
    // Clear write response valid (axi_bvalid) after one clock
    wire wr_add_data_ready = axi_awready && axi_wready;
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
        begin
            axi_bvalid  <= 0;
            axi_bresp   <= 2'b0;
        end 
        else
        begin    
            if (wr_add_data_valid && wr_add_data_ready && ~axi_bvalid)
            begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0;
            end
            else if (S_AXI_BREADY && axi_bvalid) 
                axi_bvalid <= 1'b0; 
        end
    end   

    // In the first clock (~axi_arready) that the read address is valid
    // - capture the address (axi_araddr)
    // - output ready (axi_arready) for one clock
    reg [C_S_AXI_ADDR_WIDTH-1:0] raddr;
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
        begin
            axi_arready <= 1'b0;
            raddr <= 32'b0;
        end 
        else
        begin    
            // if valid, pulse ready (axi_rready) for one clock and save address
            if (axi_arvalid && ~axi_arready)
            begin
                axi_arready <= 1'b1;
                raddr  <= axi_araddr;
            end
            else
                axi_arready <= 1'b0;
        end 
    end       
        
    // Update register read data
    // - after this module receives a valid address (axi_arvalid)
    // - after this module asserts ready for address handshake (axi_arready)
    // - before the module asserts the data is valid (~axi_rvalid)
    //   (don't change the data while asserting read data is valid)
    wire rd = axi_arvalid && axi_arready && ~axi_rvalid;
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
        begin
            axi_rdata <= 32'b0;
        end 
        else
        begin    
            if (rd)
            begin
		// Address decoding for reading registers
		case (raddr[4:2])
		    MODE_REG: 
		        axi_rdata <= mode; //mode
		    RUN_REG:
		        axi_rdata <= run;
		    FREQ_A_REG: 
		        axi_rdata <= freq_a;
		    FREQ_B_REG: 
			    axi_rdata <= freq_b;
		    OFFSET_REG:
			    axi_rdata <= offset;
		    AMPLITUDE_REG:
			    axi_rdata <= amplitude;
		    DTYCYC_REG:
			    axi_rdata <= dtycyc;
		    CYCLES_REG:
		        axi_rdata <= cycles;
		endcase
            end   
        end
    end    

    // Assert data is valid for reading (axi_rvalid)
    // - after address is valid (axi_arvalid)
    // - after this module asserts ready for address handshake (axi_arready)
    // De-assert data valid (axi_rvalid) 
    // - after master ready handshake is received (axi_rready)
    always_ff @ (posedge axi_clk)
    begin
        if (axi_resetn == 1'b0)
            axi_rvalid <= 1'b0;
        else
        begin
            if (axi_arvalid && axi_arready && ~axi_rvalid)
            begin
                axi_rvalid <= 1'b1;
                axi_rresp <= 2'b0;
            end   
            else if (axi_rvalid && axi_rready)
                axi_rvalid <= 1'b0;
        end
    end 
    
    
    // Lab 6 intermediate wires and regs
    
    reg LDAC_tmp_del ;
    reg LDAC_tmp_fall;
   
    wire [11:0] MSBs_out_1_inst;
    wire [11:0] MSBs_out_2_inst;
    
    wire signed [15:0] triangle_output_1;
    wire signed [15:0] triangle_output_2;
    
    wire signed [15:0] sawtooth_output_1;
    wire signed [15:0] sawtooth_output_2;
    
    wire signed [15:0] square_output_1;
    wire signed [15:0] square_output_2;
    
    wire signed [15:0] douta_inst;
    wire signed [15:0] doutb_inst;
    
    wire signed [15:0] mux_out_1;
    wire signed [15:0] mux_out_2;
    
    wire signed [15:0] dc_out_1;
    wire signed [15:0] dc_out_2;
    
    wire signed [15:0] output_after_calib_inst;
    wire signed [15:0] output_after_calib_inst_2;
    
    wire  [11:0] unsigned_output_inst;
    wire  [11:0] unsigned_output_inst_2;
    
    
    //  Lab 6 Instantiation starts here
    
    always @(posedge axi_clk) begin
    
     LDAC_tmp_del <= LDAC_tmp;
    
    end 
  
  assign LDAC_tmp_fall = LDAC_tmp_del & ~LDAC_tmp ;
  
  (* core_use_dsp = "yes" *)  phase_accumulator pa_inst( .mode(mode_reg),
                           .run(run_reg),
                           .clk            (axi_clk),
                           .en                (LDAC_tmp_fall), // 32 bits
                           .frequency_in_1    (freq_aa), // 32 bits
                           .frequency_in_2    (freq_bb), // 32 bits
                           .cycles_a (cycles_a),
                           .cycles_b (cycles_b),
                           .MSBs_out_1        (MSBs_out_1_inst), // 12 bits reg goes to bram addra
                           .MSBs_out_2        (MSBs_out_2_inst)  // 12 bits goes to bram addrb
                            );
    
    
    
   blk_mem_gen_0 blk_mem_gen_0 ( .clka(axi_clk),    // input wire clka
                    //   .ena(LDAC_tmp_fall),      // input wire ena
                       .addra(MSBs_out_1_inst),  // input wire [11 : 0] addra
                       .douta(douta_inst),  // output wire [15 : 0] douta
                       .clkb(axi_clk),    // input wire clkb
                     //  .enb(LDAC_tmp_fall),      // input wire enb
                       .addrb(MSBs_out_2_inst),  // input wire [11 : 0] addrb
                       .doutb(doutb_inst)  // output wire [15 : 0] doutb
                      ); 

triangle triangle_inst (.mode(mode_reg),
                        .run(run_reg),
                        .clk              (axi_clk),                   // Clock input
                        .en               (LDAC_tmp_fall),
                        .countt           (triangle_output_1), // 15 bit signed output
                        .countt_2         (triangle_output_2), // 15 bit signed output
                        .input_frequency_A(freq_aa),
                        .input_frequency_B(freq_bb),
                        .Cycle_A          (cycles_a),
                        .Cycle_B          (cycles_b),
                        .Amplitude_A      (amplitude_a),
                        .Amplitude_B      (amplitude_b),
                        .Offset_A         (offset_a),
                        .Offset_B         (offset_b)
                       );
  
sawtooth  sawtooth(.mode(mode_reg),
                        .run(run_reg),
              .clk               (axi_clk),                   // Clock input
              .en                (LDAC_tmp_fall),
              .countt            (sawtooth_output_1), // N-bit signed counter output
              .countt_2          (sawtooth_output_2),
              .input_frequency_A (freq_aa),
              .input_frequency_B (freq_bb),
              .Cycle_A           (cycles_a),
              .Cycle_B           (cycles_b),
              .Amplitude_A       (amplitude_a),
              .Amplitude_B       (amplitude_b),
              .Offset_A          (offset_a),
              .Offset_B          (offset_b)
);

dc_wavegen  dc_wavegen(.mode(mode_reg),
                        .run(run_reg),
              .clk               (axi_clk),                   // Clock input
              .en                (LDAC_tmp_fall),
              .countt            (dc_out_1), // N-bit signed counter output
              .countt_2          (dc_out_2),
              .Offset_A          (offset_a),
              .Offset_B          (offset_b),
              .Cycle_A           (cycles_a),
              .Cycle_B           (cycles_b)

);   


 square sq_inst(.mode(mode_reg),
                .run(run_reg),
                .clk                     (axi_clk),                   // Clock input4
                .en               (LDAC_tmp_fall),
                .countt         (square_output_1), // N-bit signed counter output
                .countt_2       (square_output_2),
                .input_frequency_A    (freq_aa),
                .input_frequency_B    (freq_bb),
                .Cycle_A             (cycles_a),
                .Cycle_B             (cycles_b),
                .Amplitude_A      (amplitude_a),
                .Amplitude_B      (amplitude_b),
                .Offset_A            (offset_a),
                .Offset_B            (offset_b),
                .Duty_A              (dtycyc_a),
                .Duty_B              (dtycyc_b)
);   

DemuxModule DemuxModule_in(
                .mode(mode_reg),
                .run(run_reg),
                .clk                     (axi_clk),                   // Clock input4
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

calibration calibration_inst ( .clk                (axi_clk),
                               .en(LDAC_tmp_fall),
                               .bit_input_sixteen  (mux_out_1),   // douta from bram goes here
                               .bit_input_sixteen_2(mux_out_2),
							   .output_after_calib (output_after_calib_inst), // [15:0] reg
							   .output_after_calib_2(output_after_calib_inst_2)
							  );
							  
signed_to_unsigned s_to_uinst (.clk                (axi_clk),
                               .en(LDAC_tmp_fall),
                               .run(run_reg),
                               .mode(mode_reg),
                               .amp1(amplitude_a),
                               .amp2(amplitude_b),
                               .off1(offset_a),
                               .off2(offset_b),
                               .signed_input       (output_after_calib_inst),  // [15:0] output_after_calib 
                               .signed_input_2      (output_after_calib_inst_2),
							   .unsigned_output    (unsigned_output_inst),   // [11:0] reg
							   .unsigned_output_2   (unsigned_output_inst_2)
							  );
							  
 (* core_use_dsp = "yes" *) Lab_5_1 Lab_5_1(.clk      (axi_clk),
                    .reset    ()   ,
                    .SW_DATA  (unsigned_output_inst) ,
                    .SW_DATA_2 (unsigned_output_inst_2), // unsigned_output_inst
                    .PB1      ()   , 
                    .PB2      ()   ,
                    .CS       (CS_tmp)  ,      
                    .LDAC     (LDAC_tmp),   // 1 bit
                    .data     (data_tmp),   
                    .clk_out  (clk_out_tmp)
                    );
                    
	endmodule
