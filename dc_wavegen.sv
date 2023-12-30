module  dc_wavegen #(parameter N=16)(
  input [31:0] mode,
  input [31:0] run,
  input wire clk,   
  input en,// Clock input
  output reg signed [N-1:0] countt, // N-bit signed counter output
  output reg signed [N-1:0] countt_2,
  input signed [15:0] Offset_A,
  input signed [15:0] Offset_B,
  input [15:0] Cycle_A,
  input [15:0] Cycle_B
);
  
  wire [2:0] mode_a;
  wire [2:0] mode_b;
  
  wire run_a;
  wire run_b;
  
  assign mode_a = mode[2:0];
  assign mode_b = mode[5:3];
  
  assign run_a = run[0];
  assign run_b = run[1];
  
//  reg [15:0] counter_A_dc = 0;
//  reg [15:0] counter_B_dc = 0;
//  reg signed [27:0] inter_a;
//  reg signed [27:0] inter_b;
  
//  assign inter_a = 2045 * Offset_A;
//  assign inter_b = 2045 * Offset_B;
  
  always @ (posedge clk) begin
  
  if (en) begin
     
    if (mode_a == 3'b000 && run_a == 1'b1) begin
      
   
     countt <= Offset_A ;
   
        
      end
  
  
    if (mode_b == 3'b000 && run_b == 1'b1) begin
      
   
      countt_2 <= Offset_B ;

   end
    
 
    
 end
  end
endmodule
