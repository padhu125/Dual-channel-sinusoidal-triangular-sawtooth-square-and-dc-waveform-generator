`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2023 16:02:06
// Design Name: 
// Module Name: divide_the_clk
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



module divide_the_clk(
    input clk,
    output reg out);

    reg [26:0] count;

    always @ (posedge(clk))
    begin
        if (count < 27'd50) // 100,000,000 MHz / 50 = 2,000,000 MHz (2MHz)
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
