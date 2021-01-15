`include "triumph_riscv_defines.v"

module triumph_controller(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // id
    input wire  [2:0]  instr_type_i,
    input wire  [6:0]  opcode_i,

    // ex
    input wire         flag_zero_ex_i,

    // pipeline controling signals
    output reg         op3_data_valid_wb_o,
    output reg         pc_mux_o,
    output reg         wb_mux_o,       //writeback to regfile 1: from memory; 0:from ALU
    // store data to memory
    output reg         dcache_write_en_o
);

reg   [2:0]  instr_type;
reg   [6:0]  opcode;
reg          wb_mux;
reg          dcache_write_en;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        instr_type          <= 3'b0;
        opcode              <= 7'b0;
        wb_mux_o            <= 0;
        dcache_write_en_o   <= 0;
    end
    else begin
        instr_type          <= instr_type_i;
        opcode              <= opcode_i;
        wb_mux_o            <= wb_mux;
        dcache_write_en_o   <= dcache_write_en;
    end
end

always @(*) begin
     case (instr_type)
        `INSTR_R:
        begin 
            op3_data_valid_wb_o = 1; 
            pc_mux_o            = 1'b0;
            wb_mux              = 1'b0;
            dcache_write_en   = 1'b0;
        end
        `INSTR_I:
        begin 
            op3_data_valid_wb_o = 1;
            pc_mux_o            = 1'b0;
            wb_mux              = (opcode == `OP_LOAD) ? 1'b1 : 1'b0; //there are too many I type instructions.
            dcache_write_en   = 1'b0;
        end
        `INSTR_S:
        begin 
            op3_data_valid_wb_o = 0;
            pc_mux_o            = 1'b0;
            wb_mux              = 1'b0;
            dcache_write_en     = 1'b1;
        end
        `INSTR_B:
        begin 
            op3_data_valid_wb_o = 0; 
            pc_mux_o            = (((opcode == `OP_BEQ)&&flag_zero_ex_i) || ((opcode == `OP_BNE)&&(!flag_zero_ex_i))) ? 1'b1 : 1'b0;
            wb_mux              = 1'b0;
            dcache_write_en     = 1'b0;
        end
        `INSTR_U:
        begin 
            op3_data_valid_wb_o = 1; 
            wb_mux              = 1'b0;
            dcache_write_en    = 1'b0;
        end
        `INSTR_J:
        begin 
            op3_data_valid_wb_o = 1;
            wb_mux              = 1'b0;
            dcache_write_en    = 1'b0;
        end
        default:begin
            op3_data_valid_wb_o = 0;
            pc_mux_o            = 1'b0;
            wb_mux              = 1'b0;
            dcache_write_en    = 1'b0;
        end
     endcase
end

endmodule