module triumph_regfile_ff(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // id stage
    input  wire [4:0]  op1_addr_id_i,
    input  wire [4:0]  op2_addr_id_i,
    input  wire [4:0]  op3_addr_id_i,
    // ex stage
    output reg  [31:0] op1_data_ex_o,
    output reg  [31:0] op2_data_ex_o,
    // wb stage
    input  wire        data_valid_wb_i,
    input  wire [31:0] op3_data_wb_i
);

reg [31:0] mem[31:0];

integer i;
	initial begin
        mem[0] <= 32'b0;
        mem[1] <= 32'h0000_0005;
        mem[2] <= 32'h0000_0003;
        mem[3] <= 32'h0000_0011;
        mem[4] <= 32'h0000_001a;
        mem[5] <= 32'h0000_0009;
        mem[6] <= 32'h0000_000b;
        mem[7] <= 32'h0f00_100a;
        mem[8] <= 32'h0030_1009;
        mem[9] <= 32'h0000_000b;
        for(i = 10; i < 32; i=i+1)
			mem[i] <= 32'h0;
    end
		


// writeback to op3 register

always @(posedge clk_i) begin  
    if (data_valid_wb_i) begin
        mem[op3_addr_id_i] <= op3_data_wb_i;
    end
    else begin
        mem[op3_addr_id_i] <= mem[op3_addr_id_i];
    end
end
// read data to op1 and op2
always @(*) begin
    op1_data_ex_o <= op1_addr_id_i ? mem[op1_addr_id_i] : 32'b0;
    op2_data_ex_o <= op2_addr_id_i ? mem[op2_addr_id_i] : 32'b0;
end

endmodule