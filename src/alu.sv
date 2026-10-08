`include "alu.svh"
`timescale 1ns / 1ps

module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input alu_op_t alu_op,
    output logic exception,
    output logic [31:0] c
);

    always_comb begin
        exception = 0;
        case (alu_op)
            ADD: c = a + b;
            SUB: c = a - b;
            XOR: c = a ^ b;
            OR: c = a | b;
            AND: c = a & b;
            SLL: c = a << b[4:0];
            SRL: c = a >> b[4:0];
            SRA: c = unsigned'(signed'(a) >>> b[4:0]);
            SLT: c = 32'(signed'(a) < signed'(b));
            SLTU: c = 32'(a < b);
            default: begin
                c = 0;
                exception = 1;
            end
        endcase
    end

endmodule
