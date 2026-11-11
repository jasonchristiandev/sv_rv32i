`timescale 1ns / 1ps

module rv32i_tb;

    reg clk;
    reg rst_n;

    rv32i dut (
        .clk  (clk),
        .rst_n(rst_n)
    );

    int errors = 0;
    int tests = 0;

    always #5 clk = ~clk;

    initial begin

        $dumpfile("build/wave.vcd");
        $dumpvars(0, rv32i_tb);

        clk   = 0;
        rst_n = 0;

        #10 rst_n = 1;
        #10;

        $display("[RV32I_TB] %0d / %0d tests failed", errors, tests);
        $finish;

    end

endmodule
