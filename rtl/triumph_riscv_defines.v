`define INSTR_R     3'b001
`define INSTR_I     3'b010
`define INSTR_S     3'b011
`define INSTR_B     3'b100
`define INSTR_U     3'b101
`define INSTR_J     3'b110
// opcode
`define OP_SYSTEM	7'h73
`define OP_FENCE	7'h0f
`define OP_R_R		7'h33     //
`define OP_R_IMM	7'h13
`define OP_STORE	7'h23
`define OP_LOAD	    7'h03
`define OP_BNE	    7'h63
`define OP_BEQ  	7'h64
`define OP_JALR	    7'h67
`define OP_JAL		7'h6f
`define OP_AUIPC	7'h17
`define OP_LUI		7'h37


// ALU operation

`define ALU_ADD    7'b0011000    //18
`define ALU_SUB    7'b0011001    //19
`define ALU_ADDU   7'b0011010
`define ALU_SUBU   7'b0011011
`define ALU_ADDR   7'b0011100
`define ALU_SUBR   7'b0011101
`define ALU_ADDUR  7'b0011110
`define ALU_SUBUR  7'b0011111

`define ALU_XOR    7'b0101111
`define ALU_OR     7'b0101110    //2e
`define ALU_AND    7'b0010101    //15

// Shifts
`define ALU_SRA    7'b0100100
`define ALU_SRL    7'b0100101
`define ALU_ROR    7'b0100110
`define ALU_SLL    7'b0100111
