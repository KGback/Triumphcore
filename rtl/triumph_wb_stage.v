module triumph_wb_stage(
    input  wire        clk_i,
    input  wire        rstn_i,
    // id stage
    input  wire [4:0]  op3_addr_id_i,
    output reg  [4:0]  op3_addr_id_o,
    // ex stage
    input  wire        data_valid_wb_i,
    input  wire [31:0] op3_data_wb_i,
    output reg         data_valid_wb_o,
    output reg  [31:0] op3_data_wb_o,

    input  wire [31:0] dcache_wdata_d_i,
    output reg  [31:0] dcache_wdata_q_o
);


always @(posedge clk_i or posedge rstn_i) begin 
    if (!rstn_i)  begin
        op3_addr_id_o       <= 32'b0;
        op3_data_wb_o       <= 32'b0;
        data_valid_wb_o     <= 0;
        dcache_wdata_q_o    <= 32'b0;
    end
    else        begin
        op3_addr_id_o       <= op3_addr_id_i;
        op3_data_wb_o       <= op3_data_wb_i;
        data_valid_wb_o     <= data_valid_wb_i;
        dcache_wdata_q_o    <= dcache_wdata_d_i;
    end
end




endmodule