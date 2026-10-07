`include "alu.svh"

module inst_decoder (
    input logic [31:0] inst,
    output logic exception,
    output alu_op_t alu_op,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic signed [31:0] imm,
    output logic useimm
);

    always_comb begin
        logic [6:0] opcode;
        logic [2:0] funct3;
        logic [6:0] funct7;

        exception = 0;
        alu_op = ADD;
        opcode = inst[6:0];
        rd = inst[11:7];
        funct3 = inst[14:12];
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        funct7 = inst[31:25];
        imm = 32'(signed'(inst[31:20]));
        useimm = 0;

        case (opcode)
            7'b0110011: begin  // R
                case (funct3)
                    3'h0: begin
                        alu_op = funct7 == 7'h20 ? SUB : ADD;
                        exception = funct7 != 7'h00 && funct7 != 7'h20;
                    end
                    3'h4: begin
                        alu_op = XOR;
                        exception = funct7 != 7'h00;
                    end
                    3'h6: begin
                        alu_op = OR;
                        exception = funct7 != 7'h00;
                    end
                    3'h7: begin
                        alu_op = AND;
                        exception = funct7 != 7'h00;
                    end
                    3'h1: begin
                        alu_op = SLL;
                        exception = funct7 != 7'h00;
                    end
                    3'h5: begin
                        alu_op = funct7 == 7'h20 ? SRA : SRL;
                        exception = funct7 != 7'h00 && funct7 != 7'h20;
                    end
                    3'h2: begin
                        alu_op = SLT;
                        exception = funct7 != 7'h00;
                    end
                    3'h3: begin
                        alu_op = SLTU;
                        exception = funct7 != 7'h00;
                    end
                    default: exception = 1;
                endcase
            end
            7'b0010011: begin  // IR
                useimm = 1;
                case (funct3)
                    3'h0: alu_op = ADD;
                    3'h4: alu_op = XOR;
                    3'h6: alu_op = OR;
                    3'h7: alu_op = AND;
                    3'h1: begin
                        alu_op = SLL;
                        exception = funct7 != 7'h00;
                    end
                    3'h5: begin
                        alu_op = funct7 == 7'h20 ? SRA : SRL;
                        exception = funct7 != 7'h00 && funct7 != 7'h20;
                    end
                    3'h2: alu_op = SLT;
                    3'h3: alu_op = SLTU;
                    default: exception = 1;
                endcase
            end
            7'b0000011: begin  // IL

            end
            7'b1100111: begin  // IJ

            end
            7'b0100011: begin  // S

            end
            7'b1100011: begin  // B

            end
            7'b0110111, 7'b0010111: begin  // U

            end
            7'b1101111: begin  // J

            end
            default: exception = 1;
        endcase
    end

endmodule
