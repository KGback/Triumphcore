`include "triumph_riscv_defines.v"

module triumph_id_controller(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,

    input  wire [6:0]  opcode_i,
    input  wire [2:0]  funct3_i,
    input  wire [6:0]  funct7_i,

    output wire  [2:0]  instr_type_o,
    output wire  [6:0]  op_type_o
);

reg  [2:0] instr_type;
reg  [6:0] op_type;

assign instr_type_o = instr_type;
assign op_type_o = op_type;

always @(*)begin
    case (opcode_i)
        `OP_R_R:                                            instr_type = `INSTR_R;
        `OP_R_IMM,`OP_SYSTEM, `OP_FENCE,`OP_LOAD,`OP_JALR:  instr_type = `INSTR_I;
        `OP_STORE:                                          instr_type = `INSTR_S;
        `OP_BEQ, `OP_BNE:                                   instr_type = `INSTR_B;
        `OP_JAL:                                            instr_type = `INSTR_J;
        `OP_AUIPC, `OP_LUI:                                 instr_type = `INSTR_U;
        default:                                            instr_type = 3'b000;
    endcase
end

always @(*) begin
    case (instr_type)
        `INSTR_R:
        begin
            if(funct3_i == 3'b000)
            begin
                if(funct7_i == 7'b0000000) 
                    op_type = `ALU_ADD;             //add
                else
                    op_type = `ALU_SUB;             //sub
            end
            else if (funct3_i == 3'b001) begin
                op_type = `ALU_SLL;   
            end
            else if (funct3_i == 3'b111) begin
                op_type = `ALU_AND;                 // and
            end
        end
        `INSTR_I:
        begin
            if (funct3_i == 3'b110)                    //ORI
                op_type = `ALU_OR;
            else if (funct3_i == 3'b010)               //lw
                op_type = `ALU_ADD;
            else op_type = `OP_JALR;                //JALR
        end
        `INSTR_S:
        begin
            if (funct3_i == 3'b010)                    //sw
                op_type = `ALU_ADD;
        end
        `INSTR_B:
        begin
            //if (funct3_i == 3'b000 || funct3_i == 3'b000)                    //BEQ
            op_type = `ALU_SUB;                      //BNE BEQ      
        end
        `INSTR_J:  op_type = `OP_JAL;               //JAL
        `INSTR_U:  op_type = `OP_LUI;               //LUI
        default: op_type = 7'b0000000;
    endcase
end

endmodule