`define MEM_SIZE 200
`define MAIN_MEM(P) dut.sram_instr_i.ram[(``P``)]

module tb;

import uvm_pkg::*; 
`include "uvm_macros.svh"

logic clk_i;
logic rstn_i;

localparam CLK_PERIOD = 20;

initial begin
    do  begin
        #(CLK_PERIOD/2) clk_i = 1;    
        #(CLK_PERIOD/2) clk_i = 0;    
    end 
    while (1);
end

initial begin
   string bin_file; 
   int fd;
   int i;
   reg [31:0] mem[0: `MEM_SIZE];
   int bin_end = 0;
   longint num_words = 0;

    rstn_i = 1;
    #40 rstn_i = 0;
    #40 rstn_i = 1;
    
    if($value$plusargs("bin_file=%s", bin_file)) begin
        fd = $fopen (bin_file, "r");   
        if (fd)  `uvm_info ("DUT_WRAP", $sformatf("%s was opened successfully : (fd=%0d)", bin_file, fd), UVM_DEBUG)
        else     `uvm_fatal("DUT_WRAP", $sformatf("%s was NOT opened successfully : (fd=%0d)", bin_file, fd))
        `uvm_info("DUT_WRAP", $sformatf("loading bin_file %0s", bin_file), UVM_NONE)
        if (fd != 0) begin
            i = $fread(mem, fd);

            while (!bin_end) begin
                if (mem[num_words] === 32'bx) begin
                    bin_end = 1;
                end
                else begin
                    bin_end = 0;
                    `MAIN_MEM(num_words) = mem[num_words];
                end
                // $display("mem[%x]: %x", num_words, mem[num_words]);
                num_words++;
            end
        end
        $fclose(fd);
    end

    $display("===============================");
    $display("       simulation begin        ");
    $display("===============================");
    #50000;
    $finish;
end
  


triumphcore_wrapper dut(
    .clk_i              ( clk_i             ),
    .rstn_i             ( rstn_i             )
    );


endmodule
