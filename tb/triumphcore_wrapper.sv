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


module triumphcore_wrapper(
    input   logic        clk_i,
    input   logic        rst_i
    );

logic [31:0] pc;
logic [31:0] instr_rdata;

logic [31:0] dcache_addr;
logic [31:0] dcache_rdata;
logic [31:0] dcache_wdata;
logic        dcache_write_en;

logic [31:0]   data_display;

triumph_core triumph_core_i(
    .clk_i              ( clk_i             ),
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
    .clk_i          ( clk_i         ),
    .rst_i          ( rst_i         ),
    .req_i          ( 1'b1          ),
    .we_i           ( 1'b0          ),
    .addr_i         ( pc            ),
    .wdata_i        ( 32'b0         ),
    .rdata_o        ( instr_rdata   )
);

sram_data sram_data_i(
    .clk_i          ( clk_i             ),
    .rst_i          ( rst_i             ),
    .req_i          ( 1'b1              ),
    .we_i           ( dcache_write_en   ),
    .addr_i         ( dcache_addr       ),
    .wdata_i        ( dcache_wdata      ),
    .rdata_o        ( dcache_rdata      )
);


endmodule
