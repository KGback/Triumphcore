module sram_data(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rstn_i,

    input  wire        req_i,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] wdata_i,
    output wire [31:0] rdata_o
);

reg [31:0] ram [9:0];
reg [31:0] raddr_q;

    always @(posedge clk_i or posedge rstn_i) begin
        if (!rstn_i) begin
            ram[0] <= 32'h0000_000f;
            ram[1] <= 32'h0000_0001;  
            ram[2] <= 32'h0000_0001;  
            ram[3] <= 32'h0000_0010;  
            ram[4] <= 32'h0000_000a;  
            ram[5] <= 32'h00f0_0000;  
            ram[6] <= 32'h0f00_0000;  
            ram[7] <= 32'hf000_0000;
            ram[8] <= 32'h0a0a_0a0a;
            ram[9] <= 32'h5050_5050;  
        end
        else if (req_i) begin
            if (!we_i)                      // read data 
                raddr_q <= addr_i;
            else                            // write data in sram
                ram[addr_i] <= wdata_i;  
        end                                                
    end

    assign rdata_o = ram[addr_i];

endmodule