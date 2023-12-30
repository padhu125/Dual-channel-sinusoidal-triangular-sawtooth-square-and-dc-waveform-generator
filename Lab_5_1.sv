`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2023 15:58:07
// Design Name: 
// Module Name: Lab_5_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab_5_1 (input clk,
                input reset,
                input [11:0] SW_DATA, // 10 bits
                input [11:0] SW_DATA_2,
                input PB1, // 2 bits
                input PB2,
                output reg CS,      
                output reg LDAC,
                output reg data,
                output clk_out   // 2MHz
                );
  
  reg [5:0] states; 
  integer i;
  
  parameter  bit_15_to_12_A = 4'b0011;
  parameter  bit_15_to_12_B = 4'b1011;
  
  reg [15:0] full_data;
  reg [15:0] full_data_B;
  reg [15:0] not_used;
 
  reg clk_2MHz;
  reg sclk_enable;
  reg clk_2MHz_del;
  wire pulse_2MHz;
  reg pulse_4Mhz;
  
  parameter STATE_RESET     = 6'b000000; 
  parameter STATE_CS_LOW    = 6'b000001; 
  
  parameter STATE_DAC_A_1   = 6'b000010;
  parameter STATE_DAC_A_2   = 6'b000011;
  parameter STATE_DAC_A_3   = 6'b000100;
  parameter STATE_DAC_A_4   = 6'b000101;
  parameter STATE_DAC_A_5   = 6'b000110;
  parameter STATE_DAC_A_6   = 6'b000111;
  parameter STATE_DAC_A_7   = 6'b001000;
  parameter STATE_DAC_A_8   = 6'b001001;
  parameter STATE_DAC_A_9   = 6'b001010;
  parameter STATE_DAC_A_10  = 6'b001011;
  parameter STATE_DAC_A_11  = 6'b001100;
  parameter STATE_DAC_A_12  = 6'b001101;
  parameter STATE_DAC_A_13  = 6'b001110;
  parameter STATE_DAC_A_14  = 6'b001111;
  parameter STATE_DAC_A_15  = 6'b010000;
  parameter STATE_DAC_A_16  = 6'b010001;
  
  parameter STATE_CS_HIGH_1 = 6'b010010; // CS high just this
  parameter STATE_CS_LOW_2  = 6'b010011; // CS low just this
  
  parameter STATE_DAC_B_1     = 6'b010100;
  parameter STATE_DAC_B_2     = 6'b010101;
  parameter STATE_DAC_B_3     = 6'b010110;
  parameter STATE_DAC_B_4     = 6'b010111;
  parameter STATE_DAC_B_5     = 6'b011000;
  parameter STATE_DAC_B_6     = 6'b011001;
  parameter STATE_DAC_B_7     = 6'b011010;
  parameter STATE_DAC_B_8     = 6'b011011;
  parameter STATE_DAC_B_9     = 6'b011100;
  parameter STATE_DAC_B_10    = 6'b011101;
  parameter STATE_DAC_B_11    = 6'b011110;
  parameter STATE_DAC_B_12    = 6'b011111;
  parameter STATE_DAC_B_13    = 6'b100000;
  parameter STATE_DAC_B_14    = 6'b100001;
  parameter STATE_DAC_B_15    = 6'b100010;
  parameter STATE_DAC_B_16    = 6'b100011;
  parameter STATE_JUST_CLK = 6'b111000;
  parameter STATE_CS_HIGH_2 = 6'b101000; // CS' goes HIGH
  parameter STATE_LDAC_LOW  = 6'b101001; // LDAC goes LOW
  parameter STATE_CLOCK_HIGH = 6'b111100;
  wire [11:0] dac_dc_value  ;  // SW_DATA ??
  
  
  

  always @(posedge clk_2MHz)
  begin
   
        full_data       <= {bit_15_to_12_A, SW_DATA};   // 4 + 12= 16 bits
  end 
  
  always @(posedge clk_2MHz)
  begin
  
        full_data_B     <= {bit_15_to_12_B, SW_DATA_2};  // 4 + 12 = 16 bits
  end 
  
  always @(posedge clk)
  begin
	clk_2MHz_del <= clk_2MHz	;
  end 
  
  assign pulse_2MHz = ~clk_2MHz & clk_2MHz_del;
  
  assign clk_out = (sclk_enable) ? clk_2MHz : 1'b1	;
  
  
  
  always @ (posedge clk) begin // pulse
    
    if (reset == 1) begin
  
      CS     <= 1'b1;
      LDAC   <= 1'b1;
      
    end
    
    else if(pulse_2MHz)
	begin
    
     case(states)
      
        STATE_RESET: begin
           LDAC   <= 1'b1;
           CS     <= 1'b1;
           sclk_enable <= 1'b0;
           states <= STATE_CS_LOW;

        end
      
        STATE_CS_LOW: begin
          CS     <= 1'b0;
          sclk_enable <= 1'b1;
          data <= full_data[15];
          states <= STATE_DAC_A_2;
          
        end
        
//        STATE_JUST_CLK: begin 
        
//      states <=STATE_DAC_A_1;
//      end
      
//          STATE_DAC_A_1: begin
//          data <= full_data[15];
 //         states <= STATE_DAC_A_2;
            
 //         end
          
          
          
          STATE_DAC_A_2: begin
          
            data <= full_data[14];
            states <= STATE_DAC_A_3;
            
          end
          
          STATE_DAC_A_3: begin
          
            data <= full_data[13];
            states <= STATE_DAC_A_4;
            
          end
          
          STATE_DAC_A_4: begin
          
            data <= full_data[12];
            states <= STATE_DAC_A_5;
            
          end
          
          STATE_DAC_A_5: begin
          
            data <= full_data[11];
            states <= STATE_DAC_A_6;
            
          end
          
          STATE_DAC_A_6: begin
          
            data <= full_data[10];
            states <= STATE_DAC_A_7;
            
          end
          
          STATE_DAC_A_7: begin
          
            data <= full_data[9];
            states <= STATE_DAC_A_8;
            
          end
          
          STATE_DAC_A_8: begin
          
            data <= full_data[8];
            states <= STATE_DAC_A_9;
            
          end
          
          STATE_DAC_A_9: begin
          
            data <= full_data[7];
            states <= STATE_DAC_A_10;
            
          end
          
          STATE_DAC_A_10: begin
          
            data <= full_data[6];
            states <= STATE_DAC_A_11;
            
          end
          
          STATE_DAC_A_11: begin
          
            data <= full_data[5];
            states <= STATE_DAC_A_12;
            
          end
          
          STATE_DAC_A_12: begin
          
            data <= full_data[4];
            states <= STATE_DAC_A_13;
            
          end
          
          STATE_DAC_A_13: begin
          
            data <= full_data[3];
            states <= STATE_DAC_A_14;
            
          end
          
          STATE_DAC_A_14: begin
          
            data <= full_data[2];
            states <= STATE_DAC_A_15;
            
          end
          
          STATE_DAC_A_15: begin
          
            data <= full_data[1];
            //sclk_enable <= 1'b0	;

            states <= STATE_DAC_A_16;           
          end
          
          STATE_DAC_A_16: begin
            data <= full_data[0];
            
            states <= STATE_CLOCK_HIGH; 
          end
          
          STATE_CLOCK_HIGH: begin
           sclk_enable <= 1'b0	;
           states <=STATE_CS_HIGH_1;
           end
          
          STATE_CS_HIGH_1: begin
            CS     <= 1'b1;
            states <= STATE_CS_LOW_2;
            end
          
          
             
          STATE_CS_LOW_2: begin
          
          CS     <= 1'b0;
          sclk_enable <= 1'b1;
          data <= full_data_B[15];

          states <= STATE_DAC_B_2;
          
      end
      
    //      STATE_DAC_B_1: begin
          
    //      states <= STATE_DAC_B_2;
          
     //     end
          
          STATE_DAC_B_2: begin
          
            data <= full_data_B[14];
            states <= STATE_DAC_B_3;
            
          end
          
          STATE_DAC_B_3: begin
          
            data <= full_data_B[13];
            states <= STATE_DAC_B_4;
            
          end
          
          STATE_DAC_B_4: begin
          
            data <= full_data_B[12];
            states <= STATE_DAC_B_5;
            
          end
          
          STATE_DAC_B_5: begin
          
            data <= full_data_B[11];
            states <= STATE_DAC_B_6;
            
          end
          
          STATE_DAC_B_6: begin
          
            data <= full_data_B[10];
            states <= STATE_DAC_B_7;
            
          end
          
          STATE_DAC_B_7: begin
          
            data <= full_data_B[9];
            states <= STATE_DAC_B_8;
            
          end
          
          STATE_DAC_B_8: begin
          
            data <= full_data_B[8];
            states <= STATE_DAC_B_9;
            
          end
          
          STATE_DAC_B_9: begin
          
            data <= full_data_B[7];
            states <= STATE_DAC_B_10;
            
          end
          
          STATE_DAC_B_10: begin
          
            data <= full_data_B[6];
            states <= STATE_DAC_B_11;
            
          end
          
          STATE_DAC_B_11: begin
          
            data <= full_data_B[5];
            states <= STATE_DAC_B_12;
            
          end
          
          STATE_DAC_B_12: begin
          
            data <= full_data_B[4];
            states <= STATE_DAC_B_13;
            
          end
          
          STATE_DAC_B_13: begin
          
            data <= full_data_B[3];
            states <= STATE_DAC_B_14;
            
          end
          
          STATE_DAC_B_14: begin
          
            data <= full_data_B[2];
            states <= STATE_DAC_B_15;
            
          end
          
          STATE_DAC_B_15: begin
          
            data <= full_data_B[1];
            states <= STATE_DAC_B_16;
            
          end
          
          STATE_DAC_B_16: begin
          
            data <= full_data_B[0];
           
            states <= STATE_CS_HIGH_2; 
  
            
          end
          
          STATE_CS_HIGH_2: begin
                    CS     <= 1'b1; 
             sclk_enable <= 1'b0;
             states <= STATE_LDAC_LOW; 
             end
          

      
        STATE_LDAC_LOW: begin
          
          LDAC <= 1'b0; //
   
          states <= STATE_RESET;
          
        end
      
        default: states <= STATE_RESET;
      
    endcase
    
    end
    
  end
  
input_output_clk input_output_clk (clk,pulse_4Mhz);
final_clock_output(clk, pulse_4Mhz, clk_2MHz); 



endmodule
