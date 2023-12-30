// Code your design here
module DemuxModule(
  input [31:0] mode,
  input [31:0] run,
  input wire clk,
  input en,
  input signed[15:0] dc_1 ,
  input signed [15:0] dc_2 ,
  input signed [15:0] sine_1 ,
  input signed  [15:0] sine_2 ,
  input signed [15:0] saw_1 ,
  input signed [15:0] saw_2 ,
  input signed [15:0]tri_1 ,
  input signed [15:0] tri_2 ,
  input signed [15:0] square_1 ,
  input signed [15:0] square_2 ,
  output reg signed [15:0] out_one ,
  output reg signed [15:0] out_two 
);

  reg [2:0] mode_a;
  reg [2:0] mode_b;
  
  reg run_a;
  reg run_b;
  
   assign   mode_a = mode[2:0];
   assign  mode_b = mode[5:3];
   assign  run_a = run[0];
   assign  run_b = run[1];
  
 always @ (posedge clk) begin
   if(en) begin
 

     if (mode_a == 3'b000 && run_a == 1'b1) begin
       out_one <= dc_1;
     end
      if (mode_b == 3'b000 && run_b == 1'b1) begin
         out_two <= dc_2;
     end 
      if (mode_a == 3'b001 && run_a == 1'b1) begin
       out_one <= sine_1;
     end
      if (mode_b == 3'b001 && run_b == 1'b1) begin
       out_two <= sine_2;
     end
      if (mode_a == 3'b010 && run_a == 1'b1) begin
       out_one <= saw_1;
     end
      if (mode_b == 3'b010 && run_b == 1'b1) begin
       out_two <= saw_2;
     end
      if (mode_a == 3'b011 && run_a == 1'b1) begin
       out_one <= tri_1;
     end
      if (mode_b == 3'b011 && run_b == 1'b1) begin
       out_two <= tri_2;
     end
      if (mode_a == 3'b100 && run_a == 1'b1) begin
       out_one <= square_1;
     end
      if (mode_b == 3'b100 && run_b == 1'b1) begin
       out_two <= square_2;
     end
   end
 end
endmodule
