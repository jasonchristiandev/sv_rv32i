`timescale 1ns / 1ps

module rv32i_tb;

    reg x;
    reg y;

    rv32i dut (
        .x(x),
        .y(y)
    );

    initial begin

        $dumpfile("build/wave.vcd");
        $dumpvars(0, rv32i_tb);

        x = 0;
        #200 x = 1;
        #200 $finish;

    end

endmodule
