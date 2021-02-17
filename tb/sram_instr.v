module sram_instr(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,

    input  wire        req_i,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] wdata_i,
    output wire [31:0] rdata_o
);

reg [31:0] ram [30:0];
reg [31:0] raddr_q;

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            ram[0]  = 32'h0000_0000;
            ram[1]  = 32'b0000000_00000_00000_000_00000_0110011;  //  add x0,x0,x0
            ram[2]  = 32'b0000000_00000_00000_000_00000_0110011;  //  add x0,x0,x0
            ram[3]  = 32'b0000000_00000_00000_000_00000_0110011;  //  add x0,x0,x0
            ram[4]  = 32'b0000000_00000_00000_000_00000_0110011;  //  add x0,x0,x0
            ram[5]  = 32'b000000000011_00000_010_00100_0000011;    // 00302203 lw x4, 3(x0)
            ram[6]  = 32'b000000000001_00000_010_00101_0000011;    // 00102283 lw x5, 1(x0)
            ram[7]  = 32'b000000000010_00000_010_00110_0000011;    // 00202303 lw x6, 2(x0)
            ram[8]  = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[9]  = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[10] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[11] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[12] = 32'b0000000_00110_00101_000_00111_0110011;  // 006283b3 add x7,x5,x6
            ram[13] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[14] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[15] = 32'b0000000_00110_00000_010_00001_0100011;  // 006020A3 sw x6,1(x0)
            ram[16] = 32'b0000000_00111_00000_010_00010_0100011;  // 00702123 sw x7,2(x0)
            ram[17] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[18] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[19] = 32'b0100000_00001_00100_000_00100_0110011;   //40120233 sub x4,x4,x1
            ram[20] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[21] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[22] = 32'b1111111_00000_00100_001_11011_1100011;  //FE021eE3 bne x4,x0,-4
            ram[23] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[24] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[25] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[26] = 32'b1111111_00111_00100_001_01001_1100011;   //FE7215E3 bne x4,x7,-16
            ram[27] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            ram[28] = 32'b0000000_00000_00000_000_00000_0000000;  // nop
            
            raddr_q <= 0;
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