`include "alu.svh"
`timescale 1ns / 1ps

module alu_tb (
    input  bit enable,
    output bit finish
);

    reg [31:0] a;
    reg [31:0] b;
    alu_op_t alu_op;
    reg exception;
    reg [31:0] c;

    alu dut (.*);

    int errors = 0;
    int tests = 0;

    task automatic check(input logic [31:0] in_a, input logic [31:0] in_b, input alu_op_t op,
                         input logic [31:0] expected_c, input logic expected_ex);
        a = in_a;
        b = in_b;
        alu_op = op;
        #1;
        tests++;

        if (c !== expected_c || exception !== expected_ex) begin
            $display(
                "[ALU_TB] %0d: op=%s, a=0x%0h, b=0x%0h | Expected: c=0x%0h ex=%0b | Got: c=0x%0h ex=%0b",
                tests, op.name(), in_a, in_b, expected_c, expected_ex, c, exception);
            errors++;
        end
    endtask

    initial begin

        finish = 0;
        wait (enable == 1);

        $display("[ALU_TB] Testbench start");

        // ADD / SUB
        #10 check(32'd15, 32'd25, ADD, 32'd40, 0);
        #10 check(32'd100, 32'd40, SUB, 32'd60, 0);
        #10 check(32'd10, 32'd20, SUB, 32'hFFFFFFF6, 0);

        // logical
        #10 check(32'hFF001234, 32'h00FF5678, XOR, 32'hFFFF444C, 0);
        #10 check(32'hF0F01111, 32'h0F0F2222, OR, 32'hFFFF3333, 0);
        #10 check(32'hFF00FFFF, 32'h00FF1234, AND, 32'h00001234, 0);

        // shifts
        #10 check(32'h00000001, 32'd4, SLL, 32'h00000010, 0);
        #10 check(32'h80000000, 32'd4, SRL, 32'h08000000, 0);
        #10 check(32'h80000000, 32'd4, SRA, 32'hF8000000, 0);
        #10 check(32'h00000001, 32'h24, SLL, 32'h00000010, 0);

        // comps
        #10 check(-32'sd10, 32'sd5, SLT, 32'd1, 0);
        #10 check(-32'sd10, 32'sd5, SLTU, 32'd0, 0);
        #10 check(32'd5, 32'd10, SLT, 32'd1, 0);
        #10 check(32'd10, 32'd5, SLT, 32'd0, 0);

        // illegal opcode
        #10 check(32'd10, 32'd20, alu_op_t'(5'd31), 32'd0, 1);

        #10 $display("[ALU_TB] %0d / %0d tests failed", errors, tests);
        $display("[ALU_TB] Testbench end");
        finish = 1;

    end

endmodule
