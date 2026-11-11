`include "alu.svh"
`timescale 1ns / 1ps

module instd_tb;

    reg [31:0] inst;
    reg exception;
    alu_op_t alu_op;
    reg [4:0] rd;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg signed [31:0] imm;
    reg useimm;

    instd dut (.*);

    int errors = 0;
    int tests = 0;

    task automatic check(input logic [31:0] in_inst, input logic exp_ex, input alu_op_t exp_aluop,
                         input logic [4:0] exp_rd, input logic [4:0] exp_rs1,
                         input logic [4:0] exp_rs2, input logic signed [31:0] exp_imm,
                         input logic exp_useimm);
        alu_op_t l_alu_op;

        inst = in_inst;
        #10;
        tests++;

        l_alu_op = alu_op;

        $write("[INSTD_TB] ");
        if (exception !== exp_ex || alu_op !== exp_aluop ||
            rd !== exp_rd || rs1 !== exp_rs1 || rs2 !== exp_rs2 ||
            (imm !== exp_imm && useimm) || useimm !== exp_useimm) begin
            $write("FAIL");
            errors++;
        end else begin
            $write("OK");
        end
        $display(
            " %0d: inst=%08H | Expected: ex=%0b aluop=%s rd=%0d rs1=%0d rs2=%0d imm=%0d useimm=%0b | Got: ex=%0b aluop=%s rd=%0d rs1=%0d rs2=%0d imm=%0d useimm=%0b",
            tests, in_inst, exp_ex, exp_aluop.name(), exp_rd, exp_rs1, exp_rs2, exp_imm,
            exp_useimm, exception, l_alu_op.name(), rd, rs1, rs2, imm, useimm);
    endtask

    initial begin

        check(32'b0000000_00011_00010_000_00001_0110011, 0, ADD, 1, 2, 3, 0, 0);

        $display("[INSTD_TB] %0d / %0d tests failed", errors, tests);
        $finish;

    end

endmodule
