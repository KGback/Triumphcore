`include "triumph_riscv_defines.v"

module triumph_ex_stage(
    input  wire        clk_i,
    input  wire        rst_i,
    // from regfile
    input  wire [31:0] op1_data_i,
    input  wire [31:0] op2_data_i,
    // id stage
    input  wire [6:0]  op_type_i,
    // wb stage
    output reg         op3_data_valid_wb_o,
    output reg  [31:0] op3_data_wb_o
);

reg [31:0] op1_data;
reg [31:0] op2_data;
reg [6:0]  op_type;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        op1_data <= 32'b0;
        op2_data <= 32'b0;
        op_type  <= 7'b0;
    end
    else begin
        op1_data <= op1_data_i; 
        op2_data <= op2_data_i;
        op_type  <= op_type_i;
    end
end

always @(*) begin
     case (op_type)
        `ALU_ADD: op3_data_wb_o <= op1_data + op2_data;
        `ALU_SUB: op3_data_wb_o <= op1_data - op2_data;
        `ALU_XOR: op3_data_wb_o <= op1_data ^ op2_data;
        `ALU_OR:  op3_data_wb_o <= op1_data | op2_data;
        `ALU_AND: op3_data_wb_o <= op1_data & op2_data;
        default:  op3_data_wb_o <= op3_data_wb_o;
    endcase
        op3_data_valid_wb_o <= 1;
end




endmodule