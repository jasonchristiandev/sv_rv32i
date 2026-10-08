`timescale 1ns / 1ps

module master_tb;

    int cur_tb = 0;

    bit alu_tb_enable = 0;
    bit alu_tb_finish;
    alu_tb alu_tb_m (
        .enable(alu_tb_enable),
        .finish(alu_tb_finish)
    );

    bit rv32i_tb_enable = 0;
    bit rv32i_tb_finish;
    rv32i_tb rv32i_tb_m (
        .enable(rv32i_tb_enable),
        .finish(rv32i_tb_finish)
    );

    initial begin

        $dumpfile("build/wave.vcd");
        $dumpvars(0, master_tb);

        #10 cur_tb++;
        alu_tb_enable = 1;
        wait (alu_tb_finish == 1);

        #10 cur_tb++;
        rv32i_tb_enable = 1;
        wait (rv32i_tb_finish == 1);

        $finish();

    end

endmodule
