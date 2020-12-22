`include "triumph_riscv_defines.v"

module triumph_ex_stage(
    input  wire        clk_i,
    input  wire        rst_i,
    // from regfile
    input  wire [31:0] regfile_rs1_data_i,
    input  wire [31:0] regfile_rs2_data_i,
    // id stage
    input  wire [6:0]  op_type_i,
    // wb stage
    output reg         rd_data_valid_wb_o,
    output reg  [31:0] rd_data_wb_o
);

reg [31:0] ex_result;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        rd_data_valid_wb_o  <= 0;
        rd_data_wb_o        <= 32'b0;
    end
    else begin
        rd_data_valid_wb_o <= 1;
         rd_data_wb_o      <= ex_result;
    end
end

always @(*) 
begin
    case (op_type_i)
        `ALU_ADD: ex_result <= regfile_rs1_data_i + regfile_rs2_data_i;
        `ALU_XOR: ex_result <= regfile_rs1_data_i ^ regfile_rs2_data_i;
        `ALU_OR:  ex_result <= regfile_rs1_data_i | regfile_rs2_data_i;
        `ALU_AND: ex_result <= regfile_rs1_data_i & regfile_rs2_data_i;
        default:  ;
    endcase
end


endmodule