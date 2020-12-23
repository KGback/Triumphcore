module sram(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,

    input  wire        req_i,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] wdata_i,
    output wire [31:0] rdata_o
);


reg [31:0] ram [9:0];
reg [31:0] raddr_q;

initial begin
    ram[0] <= 32'h0000_0000;
    ram[1] <= 32'b0000000_00010_00001_000_00011_0110011;   //002081b3 add x3,x1,x2
    ram[2] <= 32'b0100000_00101_00100_000_00110_0110011;   //40520333 sub x6,x4,x5
    ram[3] <= 32'b0000000_01000_00111_111_01001_0110011;   //0083F4B3 and x9,x7,x8
    ram[4] <= 32'b000000001000_00000_110_01010_0010011;   //00806513 ori x10,x0,1000B
    ram[5] <= 32'b1111111_01100_01011_000_11011_1100011;   //FEC581E7 beq x12,x11,-2
    ram[6] <= 32'b0000000_00000_00011_000_01101_0110011;  // 000186b0 add x13,x3,x0
    ram[7] <= 32'h0000_000b;
    ram[8] <= 32'h0f00_100a;
    ram[9] <= 32'h0030_1009;
end

    always @(posedge clk_i) begin
        if (req_i) begin
            if (!we_i)                      // read data 
                raddr_q <= addr_i;
            else                            // write data in sram
                ram[addr_i] <= wdata_i;  
        end                                                
    end

    assign rdata_o = ram[raddr_q];

endmodule