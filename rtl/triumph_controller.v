`include "triumph_riscv_defines.v"

module triumph_controller(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // id
    input wire  [2:0]  instr_type_i,
    input wire  [6:0]  op_type_i,

    // ex
    input wire         flag_zero_ex_i,

    // pipeline controling signals
    output reg         op3_data_valid_wb_o,
    output reg         pc_mux_o
);

reg   [2:0]  instr_type;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        instr_type <= 3'b0;
    end
    else begin
        instr_type <= instr_type_i;
    end
end

always @(*) begin
     case (instr_type)
        `INSTR_R:
        begin 
            op3_data_valid_wb_o = 1; 
            pc_mux_o            = 1'b0;
        end
        `INSTR_I:
        begin 
            op3_data_valid_wb_o = 1;
            pc_mux_o            = 1'b0;
        end
        `INSTR_S:
        begin 
            op3_data_valid_wb_o = 0;
            pc_mux_o            = 1'b0;
        end
        `INSTR_B:
        begin 
            op3_data_valid_wb_o = 0; 
            pc_mux_o            = (flag_zero_ex_i) ? 1'b1 : 1'b0;
        end
        `INSTR_U:
        begin 
            op3_data_valid_wb_o = 1; 
        end
        `INSTR_J:
        begin 
            op3_data_valid_wb_o = 1; 
        end
        default:;
     endcase
end

endmodule