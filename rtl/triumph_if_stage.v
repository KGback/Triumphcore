module triumph_if_stage(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,

    // instruction cache interface
    output wire            [31:0] instr_addr_o,
    input  wire            [31:0] instr_rdata_i,

    // Output of IF Pipeline stage
    output wire             instr_valid_id_o,      // instruction in IF/ID pipeline is valid
    output reg       [31:0] instr_data_id_o      // read instruction is sampled and sent to ID stage for decoding
 );

reg [31:0] pc;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        pc <= 32'b0;
    end
    else begin
        pc <= pc + 32'b100;
    end
end

assign instr_addr_o = pc;
assign instr_valid_id_o = 1'b1;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        instr_data_id_o <= 0;
    end
    else
    if (instr_valid_id_o) begin
        instr_data_id_o <= instr_rdata_i;
    end
    else begin
        instr_data_id_o <= instr_data_id_o;
    end
end


endmodule