// Code your design here
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
                           
                           
                           wire [2:0] mode_a;
                           wire [2:0] mode_b;
                           assign mode_a = mode[2:0];
                           assign mode_b = mode[5:3];
                           wire run_a;
                           wire run_b;
                           assign run_a = run[0];
                           assign run_b = run[1];
                             reg signed[31:0] inbetween;
                             reg signed [15:0] finall;
                              reg signed[31:0] inbetween_2;
                             reg signed [15:0] finall_2;
                            
                             
                         (* core_use_dsp = "yes" *) assign inbetween = (amp1 * 10) / 25000;
                          reg signed [31:0] inbet2;
                          reg signed [31:0] inbet2_2;
                         (* core_use_dsp = "yes" *) assign inbet2 = (inbetween * signed_input);
                          (* core_use_dsp = "yes" *) assign finall = inbet2 / 10 + $signed(off1);
                          
                          (* core_use_dsp = "yes" *) assign inbetween_2 = (amp2 * 10) / 25000;
                           (* core_use_dsp = "yes" *) assign inbet2_2 = (inbetween_2 * signed_input_2);
                          (* core_use_dsp = "yes" *) assign finall_2 = inbet2_2 / 10 + $signed(off2);
                          
                          
//mult_gen_0 your_instance_name (
//  .CLK(clk),  // input wire CLK
//  .A(amp1),      // input wire [15 : 0] A
//  .B(10),      // input wire [15 : 0] B
//  .P(P)      // output wire [31 : 0] P
//);
always @ (posedge clk) begin

if (en) begin

 unsigned_output = 16'sd2048 - signed_input;
 unsigned_output_2 = 16'sd2048 - signed_input_2;
 unsigned_output_2 = ~unsigned_output_2;
 
 if (mode_a == 3'b001 && run_a == 1) begin
  unsigned_output = 16'sd2048 - finall;
  end
  if (mode_b == 3'b001 && run_b == 1) begin

 unsigned_output_2 = 16'sd2048 - finall_2;
 unsigned_output_2 = ~unsigned_output_2;
end
 end
end

endmodule