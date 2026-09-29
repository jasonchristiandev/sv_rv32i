`include "alu.svh"

module inst_decoder (
    input logic [31:0] inst,
    output alu_op_t alu_op
);

    always_comb begin : decode_block
        logic [6:0] opcode;
        logic [4:0] rd;
        logic [2:0] funct3;
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [6:0] funct7;

        opcode = inst[6:0];
        rd = inst[11:7];
        funct3 = inst[14:12];
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        funct7 = inst[31:25];

        case (opcode)
            7'b0110011: begin  // R

            end
            7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011: begin  // I

            end
            7'b0100011: begin  // S

            end
            7'b1100011: begin  // B

            end
            7'b0110111, 7'b0010111: begin  // U

            end
            7'b1101111: begin  // J

            end
            default: begin

            end
        endcase
    end

endmodule
