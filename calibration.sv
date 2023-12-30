`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2023 20:32:10
// Design Name: 
// Module Name: calibration
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


// Code your design here

module calibration( input clk,
                    input en,
                    input signed [15:0] bit_input_sixteen,
                    input signed [15:0] bit_input_sixteen_2,
                    output reg signed [15:0] output_after_calib,
                    output reg signed [15:0] output_after_calib_2); 
                    
  reg signed [31:0] intermediate;
  reg signed [31:0] intermediate_2;  
  
  reg en1  ;
  reg en2  ;
  reg en3  ;
  
  always @(posedge clk)
  begin
    en1 <= en ;
    en2 <= en1 ;
    en3 <= en2 ;
  end 
  
   always @ (posedge clk) 
   begin
    if (en)
    begin
        intermediate       <= bit_input_sixteen * 16'sd250    ;
        intermediate_2     <= bit_input_sixteen_2 * 16'sd250  ;
    end 
    else if(en1)
    begin
        output_after_calib <= intermediate / 256          ; // 2^8 = 256
        output_after_calib_2 <= intermediate_2 / 256          ; // 2^8 = 256
    end 
    else if(en2)
    begin
     if (output_after_calib < 0) 
     begin
            output_after_calib = output_after_calib + 3;
     end
     else 
     begin
       output_after_calib = output_after_calib - 3;
     end
    end 
   end
   

   
endmodule