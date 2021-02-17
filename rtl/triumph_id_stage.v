`include "triumph_riscv_defines.v"

module triumph_id_stage(
    input  wire        clk_i,
    input  wire        rstn_i,
    // if stage
    input  wire        instr_valid_i,
    input  wire [31:0] instr_data_i,
    output reg  [31:0] opPC_data_o,

    // ex stage
    output reg  [31:0]  op1_data_o,
    output reg  [31:0]  op2_data_o,
    output wire [2:0]   instr_type_o,  // R/S/I/J/B/U type
    output wire [6:0]   op_type_o,  // excuting type in the following excution stage
    output wire [6:0]   opcode_o,

    // wb stage and LSU
    input  wire         data_valid_wb_i,
    output reg  [4:0]   op3_addr_wb_d_o,
    input  wire [4:0]   op3_addr_wb_q_i,
    input  wire [31:0]  op3_data_wb_i,
    // LSU 
    input  wire         wb_mux_i,
    input  wire [31:0]  dcache_rdata_i,
    output reg  [31:0]  dcache_wdata_o,

    output wire [31:0]   data_display_o
    
);

reg  [31:0]  instr_data;

reg  [4:0]   rs1_addr;
reg  [4:0]   rs2_addr;
wire [31:0]  rs1_data;
wire [31:0]  rs2_data;
reg  [4:0]   rd_addr;
reg  [2:0]   funct3;
reg  [6:0]   funct7;
reg  [11:0]  imm_12;

wire [31:0]  rd_data_wb;


always @(posedge clk_i or posedge rstn_i) begin
    if (!rstn_i) begin
        instr_data <= 0;
        op3_addr_wb_d_o <= 32'b0;
    end
    else begin
        instr_data <= instr_data_i;
        op3_addr_wb_d_o <= rd_addr;
    end
end

assign opcode_o   = instr_data[6:0];

always @(*) begin
    if (!rstn_i) begin
        rs1_addr            = 0;
        rs2_addr            = 0;
        rd_addr             = 0;
        funct3              = 0;
        funct7              = 0;
        imm_12              = 0;
        op1_data_o          = 0;
        op2_data_o          = 0;
        dcache_wdata_o      = 0;
    end
    else if (instr_valid_i) begin
        case(instr_type_o) 
            `INSTR_R: 
            begin
                rd_addr     = instr_data[11:7];
                funct3      = instr_data[14:12];
                rs1_addr    = instr_data[19:15];
                rs2_addr    = instr_data[24:20];
                funct7      = instr_data[31:25];
                op1_data_o  = rs1_data;
                op2_data_o  = rs2_data;
            end
            `INSTR_I:  
            begin
                rd_addr     = instr_data[11:7];
                funct3      = instr_data[14:12];
                rs1_addr    = instr_data[19:15];
                imm_12      = instr_data[31:20];
                op1_data_o  = rs1_data;
                op2_data_o  = {20'h00000, imm_12};
            end
            `INSTR_S:  
            begin
                funct3         = instr_data[14:12];
                rs1_addr       = instr_data[19:15];
                rs2_addr       = instr_data[24:20];
                op1_data_o     = rs1_data;
                op2_data_o     = { {21{ instr_data[31] }}, instr_data[30:25], instr_data[11:7]};
                dcache_wdata_o = rs2_data;
            end
            `INSTR_B:  
            begin
                funct3      = instr_data[14:12];
                rs1_addr    = instr_data[19:15];
                rs2_addr    = instr_data[24:20];
                op1_data_o  = rs1_data;
                op2_data_o  = rs2_data;
                opPC_data_o = { {20{instr_data[31]}}, instr_data[7], instr_data[30:25], instr_data[11:8], 1'b0};
            end
            `INSTR_U:  ;
            `INSTR_J:  ;
            default:   ;
        endcase
    end
    else begin
        rs1_addr = rs1_addr;
        rs2_addr = rs2_addr;
        rd_addr  = rd_addr;
        funct3   = funct3  ;
        funct7   = funct7  ;
        imm_12   = imm_12  ;
    end
end

// judge the type of instruction and operation
triumph_id_controller triumph_id_controller_i(
    .clk_i              ( clk_i              ),
    .rstn_i              ( rstn_i              ),
    .opcode_i           ( opcode_o           ),
    .funct3_i           ( funct3             ),
    .funct7_i           ( funct7             ),
    .instr_type_o       ( instr_type_o       ),
    .op_type_o          ( op_type_o          )
);

assign rd_data_wb = wb_mux_i ? dcache_rdata_i : op3_data_wb_i;

triumph_regfile_ff triumph_regfile_ff_i(
    .clk_i              ( clk_i              ),
    .rstn_i              ( rstn_i              ),
    .rs1_addr_id_i      ( rs1_addr           ),
    .rs1_data_ex_o      ( rs1_data           ),
    .rs2_addr_id_i      ( rs2_addr           ),
    .rs2_data_ex_o      ( rs2_data           ),
    .data_valid_wb_i    ( data_valid_wb_i    ),
    .rd_addr_id_i       ( op3_addr_wb_q_i    ),
    .rd_data_wb_i       ( rd_data_wb         ),
    .data_display_o     ( data_display_o     )
);

endmodule