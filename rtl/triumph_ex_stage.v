`include "triumph_riscv_defines.v"

module triumph_ex_stage(
    input  wire        clk_i,
    input  wire        rstn_i,
    // from regfile
    input  wire [31:0] op1_data_i,
    input  wire [31:0] op2_data_i,
    // id stage
    input  wire [6:0]  op_type_i,
    // wb stage
    output wire [31:0] op3_data_wb_o,

    input  wire [31:0] dcache_wdata_d_i,
    output reg  [31:0] dcache_wdata_q_o,
    // some flags
    output wire        flag_zero_ex_o 
);

reg  [31:0] op1_data;
reg  [31:0] op2_data;
reg  [6:0]  op_type;
reg  [2:0]  instr_type;
reg  [31:0] op3_data_wb;

always @(posedge clk_i or posedge rstn_i) begin
    if (!rstn_i) begin
        op1_data            <= 32'b0;
        op2_data            <= 32'b0;
        op_type             <= 7'b0;
        dcache_wdata_q_o    <= 32'b0;
    end
    else begin
        op1_data            <= op1_data_i; 
        op2_data            <= op2_data_i;
        op_type             <= op_type_i;
        dcache_wdata_q_o    <= dcache_wdata_d_i;
    end
end

assign op3_data_wb_o = op3_data_wb;

always @(*) begin
     case (op_type)
        `ALU_ADD: op3_data_wb = op1_data + op2_data;
        `ALU_SUB: op3_data_wb = op1_data - op2_data;
        `ALU_XOR: op3_data_wb = op1_data ^ op2_data;
        `ALU_OR:  op3_data_wb = op1_data | op2_data;
        `ALU_AND: op3_data_wb = op1_data & op2_data;
        default:  op3_data_wb = 0;
    endcase
end

assign flag_zero_ex_o = (op3_data_wb==0) ? 1'b1 : 1'b0;

endmodule