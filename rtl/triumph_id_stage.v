`include "triumph_riscv_defines.v"

module triumph_id_stage(
    input  wire        clk_i,
    input  wire        rst_i,
    // if stage
    input  wire        instr_valid_i,
    input  wire [31:0] instr_data_i,

    // load data from regfile
    output reg  [4:0]  regfile_rs1_addr_o,
    output reg  [4:0]  regfile_rs2_addr_o,
    output reg  [4:0]  regfile_rd_addr_o,
    // ex stage
    output wire [6:0] op_type_ex_o
);

wire [6:0] opcode;
reg  [4:0] rs1_addr;
reg  [4:0] rs2_addr;
reg  [4:0] rd_addr;
reg  [2:0] funct3;
reg  [6:0] funct7;
// R/S/I/J/B/U type
wire [2:0] instr_type;
// excuting type in the following excution stage
wire [6:0] op_type_ex_o;

always @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        regfile_rs1_addr_o  <= 32'b0;
        regfile_rs2_addr_o  <= 32'b0;
        regfile_rd_addr_o   <= 32'b0;
    end
    else begin
        regfile_rs1_addr_o  <= rs1_addr;
        regfile_rs2_addr_o  <= rs2_addr;
        regfile_rd_addr_o   <= rd_addr;
    end
end

assign opcode = instr_data_i[6:0];

always @(*) begin
    if (instr_valid_i) begin
        case(instr_type) 
            `INSTR_R: 
            begin
                rd_addr  = instr_data_i[11:7];
                funct3   = instr_data_i[14:12];
                rs1_addr = instr_data_i[19:15];
                rs2_addr = instr_data_i[24:20];
                funct7   = instr_data_i[31:25];
            end
            `INSTR_I:  ;
            `INSTR_S:  ;
            `INSTR_B:  ;
            `INSTR_U:  ;
            `INSTR_J:  ;
            default:   ;
        endcase
    end
    else begin
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        funct3   = 0;
        funct7   = 0;
    end
end

triumph_id_controller triumph_id_controller_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .opcode_i           ( opcode             ),
    .funct3_i           ( funct3             ),
    .funct7_i           ( funct7             ),
    .instr_type_o       ( instr_type         ),
    .op_type_o          ( op_type_ex_o       )
);

endmodule