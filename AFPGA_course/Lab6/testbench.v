`timescale 1ns/1ns

module testbench_main;
    reg rst_n, clk;
    reg [7:0] din;
    wire [7:0] buswires, R0, R1;

    simple_processor simple_processor_uut(rst_n, clk, din, buswires, R0, R1);

    initial begin
        clk = 0;
        rst_n = 1;
        #2;
        rst_n = 0;
        #2;
        rst_n = 1;
        #2;
        din = 8'b01_000_000; // 0
        #20;
        din = 8'b00_000_101; // 1
        #20;
        din = 8'b01_001_000; // 2
        #20;
        din = 8'b00_000_111; // 3
        #20;
        din = 8'b10_000_001; // 4
        #20;
        din = 8'b01_010_000; // 5
        #20;
        din = 8'b00_000_011; // 6
        #20;
        din = 8'b00_001_010; // 7
        #20;
        din = 8'b11_000_001; // 8
        #50;
        $stop;
    end

    always #10 clk = ~clk;
endmodule