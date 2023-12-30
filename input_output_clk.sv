`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2023 18:48:15
// Design Name: 
// Module Name: input_output_clk
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


module input_output_clk(
    input clk,
    output reg out);

    reg [26:0] count;

    always @ (posedge(clk))
    begin
        if (count < 27'd25) // 100,000,000 Hz / 25 = 4,000,000 Hz 4(MHz)
        begin
            count <= count + 1;
            out <= 0;
        end
        else
        begin
            count <= 0;
            out <= 1;
        end
    end
endmodule
