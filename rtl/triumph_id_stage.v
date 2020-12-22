`include "triumph_riscv_defines.v"

module triumph_id_stage(
    input  wire        clk_i,
    input  wire        rst_i,
    // if stage
    input  wire        instr_valid_i,
    input  wire [31:0] instr_data_i,

    // ex stage
    output wire [31:0]  op1_data_o,
    output wire [31:0]  op2_data_o,
    output wire [6:0]   op_type_ex_o,  // excuting type in the following excution stage
    
    // wb stage
    input  wire         data_valid_wb_i,
    input  wire [31:0]  op3_data_wb_i
);

reg  [31:0] instr_data;

wire [6:0] opcode;
reg  [4:0] op1_addr;
reg  [4:0] op2_addr;
reg  [4:0] op3_addr;
reg  [2:0] funct3;
reg  [6:0] funct7;
reg  [11:0] imm_12;
// R/S/I/J/B/U type
wire [2:0] instr_type;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        instr_data <= 0;
    end
    else instr_data <= instr_data_i;
end

assign opcode = instr_data[6:0];

always @(*) begin
    if (rst_i) begin
        op1_addr = 0;
        op2_addr = 0;
        op3_addr = 0;
        funct3   = 0;
        funct7   = 0;
        imm_12   = 0;
    end
    else if (instr_valid_i) begin
        case(instr_type) 
            `INSTR_R: 
            begin
                op3_addr = instr_data[11:7];
                funct3   = instr_data[14:12];
                op1_addr = instr_data[19:15];
                op2_addr = instr_data[24:20];
                funct7   = instr_data[31:25];
            end
            `INSTR_I:  
            begin
                op3_addr = instr_data[11:7];
                funct3   = instr_data[14:12];
                op1_addr = instr_data[19:15];
                imm_12   = instr_data[31:20];
            end
            `INSTR_S:  ;
            `INSTR_B:  ;
            `INSTR_U:  ;
            `INSTR_J:  ;
            default:   ;
        endcase
    end
    else begin
        op1_addr = op1_addr;
        op2_addr = op2_addr;
        op3_addr = op3_addr;
        funct3   = funct3  ;
        funct7   = funct7  ;
        imm_12   = imm_12  ;
    end
end
// judge the type of instruction and operation
triumph_id_controller triumph_id_controller_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .opcode_i           ( opcode             ),
    .funct3_i           ( funct3             ),
    .funct7_i           ( funct7             ),
    .instr_type_o       ( instr_type         ),
    .op_type_o          ( op_type_ex_o       )
);

triumph_regfile_ff triumph_regfile_ff_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .op1_addr_id_i      ( op1_addr           ),
    .op1_data_ex_o      ( op1_data_o         ),
    .op2_addr_id_i      ( op2_addr           ),
    .op2_data_ex_o      ( op2_data_o         ),
    .data_valid_wb_i    ( data_valid_wb_i    ),
    .op3_addr_id_i      ( op3_addr           ),
    .op3_data_wb_i      ( op3_data_wb_i      )
);

endmodule