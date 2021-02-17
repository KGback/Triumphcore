module triumph_if_stage(
    // Clock and Reset
    input  wire             clk_i,
    input  wire             rstn_i,

    // instruction cache interface
    output wire      [31:0] instr_addr_o,
    input  wire      [31:0] instr_rdata_i,

    // Output of IF Pipeline stage
    output wire             instr_valid_id_o,      // instruction in IF/ID pipeline is valid
    output reg       [31:0] instr_data_id_o,      // read instruction is sampled and sent to ID stage for decoding
    // id
    input  wire      [31:0] opPC_data_i,
    // ex 
    input  wire             pc_mux_i,
    input  wire             flag1s_i   
 );

reg [31:0] pc;
reg [31:0] opPC_data;

always @(posedge clk_i or posedge rstn_i) begin
    if (!rstn_i) begin
        opPC_data   <= 32'b0;
        pc          <= 32'b0;
    end
    else begin
        opPC_data   <= opPC_data_i;
        if (pc > 29) begin
           // if (flag1s_i) begin
                pc <= 32'b0;
           // end
           // else begin
           //     pc <= pc;
           // end
            
        end
        else begin
            if (pc_mux_i) begin
            pc      <= pc + opPC_data;
            end
            else  pc    <= pc + 32'b1;
        end    
    end
end

assign instr_addr_o = pc;
assign instr_valid_id_o = 1'b1;

always @(*) begin
    if (!rstn_i) begin
        instr_data_id_o = 0;
    end
    else
    if (instr_valid_id_o) begin
        instr_data_id_o = instr_rdata_i;
    end
    else begin
        instr_data_id_o = instr_data_id_o;
    end
end



endmodule