`timescale 1ns / 1ps

module lifo (
    input  wire       clk,
    input  wire       rst,       // Active-low reset (0 = reset)
    input  wire       push,
    input  wire       pop,
    input  wire [7:0] data_in,
    output wire       empty,
    output wire       full,
    output reg  [7:0] data_out
);

    reg [7:0] stack_mem [0:15];
    reg [4:0] sp;
    integer i;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            sp <= 5'd0;
            data_out <= 8'd0;
            for (i = 0; i < 16; i = i + 1) begin
                stack_mem[i] <= 8'd0;
            end
        end else begin
            case ({push, pop})
                2'b00: ; // No operation

                // Pop Operation
                2'b01: begin
                    if (!empty) begin
                        sp <= sp - 1'b1;
                        data_out <= stack_mem[sp - 1'b1];
                    end
                end

                // Push Operation
                2'b10: begin
                    if (!full) begin
                        stack_mem[sp] <= data_in;
                        sp <= sp + 1'b1;
                    end
                end

                // Simultaneous Push & Pop (Replace top of stack)
                2'b11: begin
                    if (!empty) begin
                        stack_mem[sp - 1'b1] <= data_in;
                        data_out <= stack_mem[sp - 1'b1];
                    end
                end

                default: ;
            endcase
        end
    end

    // Status Flags
    assign empty = (sp == 5'd0);
    assign full  = (sp == 5'd16);

endmodule
