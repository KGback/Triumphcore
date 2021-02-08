`timescale 1ns / 1ps

module tb;

logic clk_i;
logic rst_i;

localparam CLK_PERIOD = 20;

initial begin
    do  begin
        #(CLK_PERIOD/2) clk_i = 1;    
        #(CLK_PERIOD/2) clk_i = 0;    
    end 
    while (1);
end

initial begin
    rst_i = 1;
    #20 rst_i = 0;
    #20 rst_i = 1;
    $display("===============================");
    $display("       simulation begin        ");
    $display("===============================");
    #5000;
    $finish;
end

initial begin
    while (1) begin
        #20;
      // $display("PC: 0x%x",dut.pc); 
    end
end
          


triumphcore_wrapper dut(
    .clk_i              ( clk_i             ),
    .rst_i              ( rst_i             )
    );


endmodule
