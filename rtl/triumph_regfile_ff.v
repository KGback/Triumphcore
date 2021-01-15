module triumph_regfile_ff(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // id stage
    input  wire [4:0]  rs1_addr_id_i,
    input  wire [4:0]  rs2_addr_id_i,
    input  wire [4:0]  rd_addr_id_i,
    // ex stage
    output reg  [31:0] rs1_data_ex_o,
    output reg  [31:0] rs2_data_ex_o,
    // wb stage
    input  wire        data_valid_wb_i,
    input  wire [31:0] rd_data_wb_i,
    output reg  [31:0] data_display_o
);

reg [31:0] mem_ff[31:0];

// writeback to rd register
always @(*) begin
    if (rst_i) begin
        mem_ff[0]  = 32'b0;
        mem_ff[1]  = 32'h0000_0001;
        mem_ff[2]  = 32'h0000_0001;
        mem_ff[3]  = 32'h0000_0efe;
        mem_ff[4]  = 32'h0000_001a;
        mem_ff[5]  = 32'h0000_0001;
        mem_ff[6]  = 32'h0000_0001;
        mem_ff[7]  = 32'h0f00_100a;
        mem_ff[8]  = 32'h0030_1009;
        mem_ff[9]  = 32'h0000_000b;
        mem_ff[10] = 32'h5050_5050;
        mem_ff[11] = 32'h0000_00ab;
        mem_ff[12] = 32'h0000_00ab;
        mem_ff[13] = 32'h0000_0232;
        mem_ff[14] = 32'h0000_001a;
        mem_ff[15] = 32'h0000_0009;
        mem_ff[16] = 32'h0000_000b;
        mem_ff[17] = 32'h0f00_100a;
        mem_ff[18] = 32'h0030_1009;
        mem_ff[19] = 32'h0000_000b;
        data_display_o = 32'b0;
    end
    else if (data_valid_wb_i) begin
        mem_ff[rd_addr_id_i] = rd_data_wb_i;
        data_display_o = mem_ff[7];
    end
    else begin
        mem_ff[rd_addr_id_i] = mem_ff[rd_addr_id_i];
        data_display_o = mem_ff[7];
    end
end
// read data to rs1 and rs2
always @(*) begin
    rs1_data_ex_o = rs1_addr_id_i ? mem_ff[rs1_addr_id_i] : 32'b0;
    rs2_data_ex_o = rs2_addr_id_i ? mem_ff[rs2_addr_id_i] : 32'b0;
end

endmodule