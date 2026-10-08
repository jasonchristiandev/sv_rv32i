`timescale 1ns / 1ps

module rv32i_tb (
    input  bit enable,
    output bit finish
);

    reg clk;
    reg rst_n;

    rv32i dut (
        .clk  (clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin

        finish = 0;
        wait (enable == 1);

        $display("[RV32I_TB] Testbench start");

        clk   = 0;
        rst_n = 0;

        #10 rst_n = 1;

        #10 $display("[RV32I_TB] Testbench end");
        finish = 1;

    end

endmodule
