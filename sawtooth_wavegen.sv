module  sawtooth #(parameter N=16)(
  input [31:0] mode,
  input [31:0] run,
  input wire clk,   
  input en,// Clock input
  output reg signed [N-1:0] countt, // N-bit signed counter output
  output reg signed [N-1:0] countt_2,
  input [31:0] input_frequency_A,
  input [31:0] input_frequency_B,
  input [15:0] Cycle_A,
  input [15:0] Cycle_B,
  input [15:0] Amplitude_A,
  input [15:0] Amplitude_B,
  input [15:0] Offset_A,
  input [15:0] Offset_B
);
  
  wire [2:0] mode_a;
  wire [2:0] mode_b;
  
  wire run_a;
  wire run_b;
  
  assign mode_a = mode[2:0];
  assign mode_b = mode[5:3];
  
  assign run_a = run[0];
  assign run_b = run[1];

  reg [31:0] on_time_A;
  reg [31:0] on_time_B;
  reg [31:0] duty;
  reg [N-1:0] samples_A;
  reg [N-1:0] samples_B;
  reg [N-1:0] down_A = 0;
  reg [N-1:0] down_B = 0;
  
  reg signed [N-1:0] amp_a;
  reg signed [N-1:0] amp_b;
  
  assign amp_a = ((Amplitude_A * 10 ) / 25000);
  assign amp_b = ((Amplitude_B * 10) / 25000);


  reg signed [N-1:0] count_A = -2047;
  reg signed [N-1:0] count_B = -2047;
  reg signed [32-1:0] step_A;
  reg signed [32-1:0] step_B;
  
  reg [32-1:0] inter_A;
  reg [32-1:0] inter_B;;
  reg signed [N-1:0] increment_count_A = 0; 
  reg signed [N-1:0] increment_count_B = 0;
  reg down = 0;                          
  
  reg [15:0] counter_A = 0;
  reg [15:0] counter_B = 0;
  
  reg [15:0] counter_A_CY = 0;
  reg [15:0] counter_B_CY = 0;
  
  assign inter_A = (50000 / input_frequency_A);
  assign inter_B = (50000 / input_frequency_B);
  assign step_A = ((4095 / (25000 / Amplitude_A)  / (50000 / input_frequency_A)));
  
  assign step_B = (4095 / (25000 / Amplitude_B)  / (50000 / input_frequency_B));
 
  always @(posedge clk) begin
    
    if(en) begin
      
     if (mode_a == 3'b010 && run_a == 1'b1) begin 
      
    if (counter_A == 0) begin
    count_A = (-2047 * amp_a) / 10;
      counter_A = counter_A + 1;
    end

    if (counter_A_CY != Cycle_A) begin
    countt <= ((count_A) + $signed(Offset_A));
    end 
    else begin
      countt <=0;
      counter_A_CY <= Cycle_A;
    end
    
    count_A = count_A + step_A;
    
        increment_count_A++;
    if (increment_count_A == inter_A + 1) begin
      count_A = (-2047 * amp_a) / 10;
      increment_count_A = 0;
      counter_A_CY = counter_A_CY + 1;
    end
      
    end
    
   if (mode_b == 3'b010 && run_b == 1'b1) begin 
    
    if (counter_B == 0) begin
    count_B = (-2047 * amp_b) / 10;
      counter_B = counter_B + 1;
    end
    
    if (counter_B_CY != Cycle_B) begin
    countt_2 <= ((count_B) + $signed(Offset_B));
    end
    else begin 
      countt_2 <= 0;
      counter_B_CY <= Cycle_B;
    end
	
    count_B = count_B + step_B;
    

    increment_count_B++;
    if (increment_count_B == inter_B + 1) begin
      count_B = (-2047 * amp_b) / 10;
      increment_count_B = 0;
      counter_B_CY = counter_B_CY + 1;
    end
      
  end
    
  end // en
    
  end // always


endmodule