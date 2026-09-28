`timescale 1ns / 1ps

module rv32i (
    input  logic x,
    output logic y
);

    assign y = !x;

endmodule
