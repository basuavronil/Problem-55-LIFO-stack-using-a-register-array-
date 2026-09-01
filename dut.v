module lifo(
  input clk, rst, push, pop,
  input [7:0] data_in,
  output empty, full,
  output [7:0] data_out
);
  reg [7:0] stack_mem [0:15];
  reg [4:0] sp;
  integer i;
  
  always@(posedge clk or negedge rst)
    begin
      if (!rst) begin
        sp <= 5'd0;
        data_out <= 1'd0;
        for (i=0; i<16; i=i+1)
          begin
            stack_mem[i] <= 8'd0;
          end
      end
      else 
        begin
          case({push, pop})
            2'b00: ;
            2'b01: begin
              sp <= sp -1;
              data_out <= stack_mem[sp-1];
            end
            2'b01: begin
              sp <= sp + 1;
              stack_mem[sp+1] <= data_in;
            end
            2'b11: begin
              data_out <= stack_mem[sp-1];
              stack_mem[sp+1] <= data_in;
            end
            default: ;
          endcase
        end
    end
  assign full == 8'd8;
  assign empty == 8'd0;
endmodule
    
  
            
              
              
              
