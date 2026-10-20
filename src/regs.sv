`timescale 1ns / 1ps

module regs (
    input logic clk,
    input logic rst_n,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic we,
    input logic [4:0] rd,
    input logic signed [31:0] rdv,
    output logic signed [31:0] rs1v,
    output logic signed [31:0] rs2v
);

    logic signed [31:0] xi[31:0];

    assign rs1v = (rs1 == 0) ? 0 : xi[rs1];
    assign rs2v = (rs2 == 0) ? 0 : xi[rs2];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i <= 31; i++) begin
                xi[i] <= 0;
            end
        end else if (we && rd != 0) begin
            xi[rd] <= rdv;
        end
    end

endmodule
