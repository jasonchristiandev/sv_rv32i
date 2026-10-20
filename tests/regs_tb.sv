`timescale 1ns / 1ps

module regs_tb;

    logic clk;
    logic rst_n;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic we;
    logic [4:0] rd;
    logic signed [31:0] rdv;
    logic signed [31:0] rs1v;
    logic signed [31:0] rs2v;

    regs dut (.*);

    int errors = 0;
    int tests = 0;

    always #5 clk = ~clk;

    task automatic write_reg(input logic [4:0] dest, input logic signed [31:0] val);
        @(posedge clk);
        #10;
        we  = 1;
        rd  = dest;
        rdv = val;
        @(posedge clk);
        #10;
        we = 0;
    endtask

    task automatic check_read(input logic [4:0] r1, input logic [4:0] r2,
                              input logic signed [31:0] exp1, input logic signed [31:0] exp2);
        rs1 = r1;
        rs2 = r2;
        #10;
        tests++;
        if (rs1v != exp1 || rs2v != exp2) begin
            $display(
                "[REGS_TB] %0d: r1=%0d, r2=%0d | Expected: rs1v=0x%0h rs2v=0x%0h | Got: rs1v=0x%0h rs2v=0x%0h",
                tests, r1, r2, exp1, exp2, rs1v, rs2v);
            errors++;
        end
    endtask

    initial begin

        $display("[REGS_TB] Testbench start");
        $dumpfile("build/wave.vcd");
        $dumpvars(0, regs_tb);

        clk = 0;
        rst_n = 0;
        we = 0;
        rd = 0;
        rdv = 0;
        rs1 = 0;
        rs2 = 0;

        #10;
        rst_n = 1;
        #10;

        check_read(0, 1, 0, 0);

        write_reg(5'd1, 32'sh12345678);
        check_read(1, 0, 32'sh12345678, 0);

        write_reg(5'd0, 32'shDEADBEEF);
        check_read(0, 1, 0, 32'sh12345678);

        write_reg(5'd5, -32'sd50);
        check_read(1, 5, 32'h12345678, -32'sd50);

        #10 $display("[REGS_TB] %0d / %0d tests failed", errors, tests);
        $display("[REGS_TB] Testbench end");
        $finish;

    end

endmodule
