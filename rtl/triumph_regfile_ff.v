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

reg [31:0] mem[31:0];

// writeback to rd register
integer i;
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        mem[0] <= 32'b0;
        for (i=1; i<32; i=i+1) begin
            mem[i] <= 32'b1;
        end
    end
    else begin
        mem[0] <= 32'b0;
        mem[1] <= 32'h0000_0003;
        mem[2] <= 32'h0000_0004;
        mem[3] <= 32'h0000_000f;
        if (data_valid_wb_i) begin
            mem[rd_addr_id_i] <= rd_data_wb_i;
        end
        else begin
            mem[rd_addr_id_i] <= mem[rd_addr_id_i];
        end
    end
end
// read data to rs1 and rs2
always @(*) begin
    rs1_data_ex_o = rs1_addr_id_i ? mem[rs1_addr_id_i] : 32'b0;
    rs2_data_ex_o = rs2_addr_id_i ? mem[rs2_addr_id_i] : 32'b0;
end

endmodule