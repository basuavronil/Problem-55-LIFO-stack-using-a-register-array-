`timescale 1ns / 1ps

module lifo_tb;

    reg        clk;
    reg        rst;
    reg        push;
    reg        pop;
    reg  [7:0] data_in;
    wire       empty;
    wire       full;
    wire [7:0] data_out;

    // Instantiate Unit Under Test (UUT)
    lifo uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .empty(empty),
        .full(full),
        .data_out(data_out)
    );

    // Waveform configuration for EPWave / GTKWave
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, lifo_tb);
    end

    // Signal Monitor for Simulator Terminal Output
    initial begin
        $monitor("[%0t ns] rst=%b | push=%b pop=%b | in=%h | out=%h | empty=%b full=%b",
                 $time, rst, push, pop, data_in, data_out, empty, full);
    end

    // 100MHz Clock (10ns Period)
    always #5 clk = ~clk;

    initial begin
        // 1. Initialize Signals & Assert Active-Low Reset
        clk     = 0;
        rst     = 0; // Assert Active-Low Reset
        push    = 0;
        pop     = 0;
        data_in = 0;

        #12;
        rst = 1; // Release Reset

        // 2. Push Values into LIFO Stack
        @(posedge clk); push = 1; pop = 0; data_in = 8'h11; // Push 0x11
        @(posedge clk); push = 1; pop = 0; data_in = 8'h22; // Push 0x22
        @(posedge clk); push = 1; pop = 0; data_in = 8'h33; // Push 0x33

        // Disable Push
        @(posedge clk); push = 0;

        // 3. Pop Values from LIFO Stack (Last In, First Out Order)
        @(posedge clk); push = 0; pop = 1; // Should output 0x33
        @(posedge clk); push = 0; pop = 1; // Should output 0x22
        @(posedge clk); push = 0; pop = 1; // Should output 0x11

        // Disable Pop
        @(posedge clk); pop = 0;

        #20;
        $finish;
    end

endmodule
