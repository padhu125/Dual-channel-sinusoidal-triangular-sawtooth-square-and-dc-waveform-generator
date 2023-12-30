`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 16:29:45
// Design Name: 
// Module Name: final_clock_output
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


module final_clock_output(input clk,input pulse,
    output  out
    );
    
    reg clk_2mhz ;
    
    always @(posedge clk)
    begin
      if(pulse)
       clk_2mhz <= ~clk_2mhz ;
   end
   
   assign out = clk_2mhz;
    
endmodule
