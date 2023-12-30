module square #(parameter N=16)(
  input [31:0] mode,
  input [31:0] run,
  input wire clk,                   // Clock input
  input en,
  output reg signed [15:0] countt, // N-bit signed counter output
  output reg signed [15:0] countt_2,
  input [31:0] input_frequency_A,
  input [31:0] input_frequency_B,
  input [15:0] Cycle_A,
  input [15:0] Cycle_B,
  input [15:0] Amplitude_A,
  input [15:0] Amplitude_B,
  input [15:0] Offset_A,
  input [15:0] Offset_B,
  input [15:0] Duty_A,
  input [15:0] Duty_B
);

  wire [2:0] mode_a;
  wire [2:0] mode_b;
  
  wire run_a;
  wire run_b;
  
  assign mode_a = mode[2:0];
  assign mode_b = mode[5:3];
  
  assign run_a = run[0];
  assign run_b = run[1];
  
  reg [31:0] inter_A;
  reg [31:0] inter_B;
  reg [31:0] on_time_A;
  reg [31:0] on_time_B;
  reg [31:0] duty;
  reg [N-1:0] samples_A;
  reg [N-1:0] samples_B;
  reg [N-1:0] down_A = 0;
  reg [N-1:0] down_B = 0;
  
  reg signed [N-1:0] amp_a;
  reg signed [N-1:0] amp_b;
  reg [15:0] counter_A = 0;
  reg [15:0] counter_B = 0;

  // Direct initialization
  
  assign amp_a = ((Amplitude_A * 10 ) / 25000);
  assign amp_b = ((Amplitude_B * 10) / 25000);
  
  assign inter_A = (50000 / input_frequency_A);
  assign inter_B = (50000 / input_frequency_B);
  assign samples_A = (4095 / (50000 / input_frequency_A));
  assign samples_B = (4095 / (50000 / input_frequency_B));

  assign on_time_A = ((Duty_A * inter_A) / 100);
  assign on_time_B = ((Duty_B * inter_B) / 100);
  

  always @(posedge clk) begin
    
    if (en) begin
      
      if (mode_a == 3'b100 && run_a == 1'b1) begin
        
        if (counter_A != Cycle_A) begin
          
          if (down_A <= on_time_A) begin
            
            countt <= ((2047 * amp_a) / 10) + $signed(Offset_A);
            
          end
          
          else begin
            
            countt <= ((-2047 * amp_a) / 10) + $signed(Offset_A);
            
          end
          
          if (down_A == inter_A - 1) begin
            
            down_A <= 0;
            counter_A <= counter_A + 1;  
            
          end
          
          else begin
            
            down_A <= down_A + 1;
            
          end
          
        end
        
        else begin 
          
          countt <= 0;
          
        end
        
      end
    
    // channel b is selected 
   
    if (mode_b == 3'b100 && run_b == 1'b1) begin
      
      if (counter_B != Cycle_B) begin
        
        if (down_B <= on_time_B) begin
          
          countt_2 <= (((2047 * amp_b) / 10) + $signed(Offset_B));
          
        end
        
        else begin
          
          countt_2 <= (((-2047 * amp_b) / 10) + $signed(Offset_B));
          
        end
        
        if (down_B == inter_B - 1) begin
          
          down_B <= 0;
          counter_B = counter_B + 1;
          
        end
        
        else begin
          
          down_B <= down_B + 1;
          
        end
        
      end
      
      else begin 
        
        countt_2 <= 0;
        
      end
      
    end
      
    end // enable
    
  end // always block
  
endmodule
