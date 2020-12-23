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
    input  wire [31:0] rd_data_wb_i
);

reg [31:0] mem_ff[31:0];
reg [4:0]  rd_addr_id;
/*
integer i;
	initial begin
        mem_ff[0]  <= 32'b0;
        mem_ff[1]  <= 32'h0000_0005;
        mem_ff[2]  <= 32'h0000_0003;
        mem_ff[3]  <= 32'h0000_0011;
        mem_ff[4]  <= 32'h0000_001a;
        mem_ff[5]  <= 32'h0000_0009;
        mem_ff[6]  <= 32'h0000_000b;
        mem_ff[7]  <= 32'h0f00_100a;
        mem_ff[8]  <= 32'h0030_1009;
        mem_ff[9]  <= 32'h0000_000b;
        mem_ff[10] <= 32'b0;
        mem_ff[11] <= 32'h0000_00ab;
        mem_ff[12] <= 32'h0000_00ab;
        mem_ff[13] <= 32'h0000_0232;
        mem_ff[14] <= 32'h0000_001a;
        mem_ff[15] <= 32'h0000_0009;
        mem_ff[16] <= 32'h0000_000b;
        mem_ff[17] <= 32'h0f00_100a;
        mem_ff[18] <= 32'h0030_1009;
        mem_ff[19] <= 32'h0000_000b;
        for(i = 20; i < 32; i=i+1)
			mem_ff[i] <= 32'h0;
    end
*/		
always @(posedge clk_i or posedge rst_i) begin 
    if (rst_i)  rd_addr_id <= 32'b0;
    else        rd_addr_id <= rd_addr_id_i;
end

// writeback to rd register

always @(posedge clk_i) begin  
    if (data_valid_wb_i) begin
        mem_ff[rd_addr_id] <= rd_data_wb_i;
    end
    else begin
        mem_ff[rd_addr_id] <= mem_ff[rd_addr_id_i];
    end
end
// read data to rs1 and rs2
always @(*) begin
    rs1_data_ex_o = rs1_addr_id_i ? mem_ff[rs1_addr_id_i] : 32'b0;
    rs2_data_ex_o = rs2_addr_id_i ? mem_ff[rs2_addr_id_i] : 32'b0;
end

endmodule