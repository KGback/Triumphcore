`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/24 14:14:46
// Design Name: 
// Module Name: SoC_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SoC_top(
    input   wire        clk_i,
    input   wire        rst_i,
    //IO: SMG
    output  wire  [3:0]  seg_byte_o,
    output  wire  [6:0]  seg_bit_o,
    output  wire         dp_o
    );

wire clk50,clk25;

wire [31:0] pc;
wire [31:0] instr_rdata;

wire [31:0] dcache_addr;
wire [31:0] dcache_rdata;
wire [31:0] dcache_wdata;
wire        dcache_write_en;

wire [31:0]   data_display;

triumph_core dut(
    .clk_i              ( clk25             ),
    .rst_i              ( rst_i             ),
    .flag1s_i           ( flag1s            ),
    .instr_addr_o       ( pc                ),
    .instr_rdata_i      ( instr_rdata       ),
    .dcache_addr_o      ( dcache_addr       ),
    .dcache_write_en_o  ( dcache_write_en   ),
    .dcache_wdata_o     ( dcache_wdata      ),
    .dcache_rdata_i     ( dcache_rdata      ),
    .data_display_o     ( data_display    )
    );

sram_instr sram_instr_i(
    .clk_i          ( clk25         ),
    .rst_i          ( rst_i         ),
    .req_i          ( 1'b1          ),
    .we_i           ( 1'b0          ),
    .addr_i         ( pc            ),
    .wdata_i        ( 32'b0         ),
    .rdata_o        ( instr_rdata   )
);

sram_data sram_data_i(
    .clk_i          ( clk25             ),
    .rst_i          ( rst_i             ),
    .req_i          ( 1'b1              ),
    .we_i           ( dcache_write_en   ),
    .addr_i         ( dcache_addr       ),
    .wdata_i        ( dcache_wdata      ),
    .rdata_o        ( dcache_rdata      )
);


endmodule
