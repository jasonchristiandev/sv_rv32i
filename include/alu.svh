typedef enum logic [4:0] {
    ADD  = 5'd0,
    SUB  = 5'd1,
    XOR  = 5'd2,
    OR   = 5'd3,
    AND  = 5'd4,
    SLL  = 5'd5,
    SRL  = 5'd6,
    SRA  = 5'd7,
    SLT  = 5'd8,
    SLTU = 5'd9
} alu_op_t;
