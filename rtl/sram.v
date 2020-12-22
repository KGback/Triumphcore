module sram(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,

    input  wire        req_i,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] wdata_i,
    output reg  [31:0] rdata_o
);


reg [31:0] ram [2:0];
reg [31:0] raddr_q;

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