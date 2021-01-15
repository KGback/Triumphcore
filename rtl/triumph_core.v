

module triumph_core(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // instruction memory
    output wire [31:0] instr_addr_o,
    input  wire [31:0] instr_rdata_i,

    // data memory
    output wire [31:0] dcache_addr_o,
    output wire        dcache_write_en_o,
    output wire [31:0] dcache_wdata_o,
    input  wire [31:0] dcache_rdata_i,

    output wire [31:0]   data_display_o,
    input  wire         flag1s_i   
);

// if - id
wire        instr_valid_id;        
wire [31:0] instr_rdata_id;
wire [31:0] opPC_data;
wire        pc_mux;
wire        wb_mux;   //1: from memory; 0:from ALU

// id - ex
wire [31:0] op1_data;
wire [31:0] op2_data;
wire [2:0]  instr_type;
wire [6:0]  op_type;
wire [6:0]  opcode;

// ex - wb
wire [4:0]   op3_addr_wb_d;
wire [4:0]   op3_addr_wb_q;
wire         op3_data_valid_wb_d;
wire         op3_data_valid_wb_q;
wire [31:0]  op3_data_wb_d;
wire [31:0]  op3_data_wb_q;
wire         flag_zero_ex;

wire [31:0]  dcache_wdata_d;
wire [31:0]  dcache_wdata_q;

// load/store: op3_data_wb_q is the memory address
assign dcache_addr_o = (dcache_write_en_o|wb_mux) ? op3_data_wb_q : 32'b0;

triumph_if_stage triumph_if_stage_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .flag1s_i           ( flag1s_i           ),
    .instr_addr_o       ( instr_addr_o       ),
    .instr_rdata_i      ( instr_rdata_i      ),
    .instr_valid_id_o   ( instr_valid_id     ),
    .instr_data_id_o    ( instr_rdata_id     ),
    .opPC_data_i        ( opPC_data          ),
    .pc_mux_i           ( pc_mux             )
);

triumph_id_stage triumph_id_stage_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .instr_valid_i      ( instr_valid_id     ),
    .instr_data_i       ( instr_rdata_id     ),
    .opPC_data_o        ( opPC_data          ),
    .op1_data_o         ( op1_data           ),
    .op2_data_o         ( op2_data           ),
    .instr_type_o       ( instr_type         ),
    .op_type_o          ( op_type            ),
    .opcode_o           ( opcode             ),
    .data_valid_wb_i    ( op3_data_valid_wb_q),
    .op3_addr_wb_d_o    ( op3_addr_wb_d      ),
    .op3_addr_wb_q_i    ( op3_addr_wb_q      ),
    .dcache_rdata_i     ( dcache_rdata_i     ),
    .dcache_wdata_o     ( dcache_wdata_d     ),
    .wb_mux_i           ( wb_mux             ),
    .op3_data_wb_i      ( op3_data_wb_q      ),
    .data_display_o     ( data_display_o     )
);


triumph_ex_stage triumph_ex_stage_i(
    .clk_i               ( clk_i              ),
    .rst_i               ( rst_i              ),
    .op1_data_i          ( op1_data           ),
    .op2_data_i          ( op2_data           ),
    .op_type_i           ( op_type            ),
    .op3_data_wb_o       ( op3_data_wb_d      ),
    .dcache_wdata_d_i    ( dcache_wdata_d     ),
    .dcache_wdata_q_o    ( dcache_wdata_q     ),    
    .flag_zero_ex_o      ( flag_zero_ex       )
);

triumph_wb_stage triumph_wb_stage_i(
    .clk_i               ( clk_i              ),
    .rst_i               ( rst_i              ),
    .op3_addr_id_i       ( op3_addr_wb_d      ),
    .op3_addr_id_o       ( op3_addr_wb_q      ),
    .data_valid_wb_i     ( op3_data_valid_wb_d),
    .data_valid_wb_o     ( op3_data_valid_wb_q),
    .op3_data_wb_i       ( op3_data_wb_d      ),
    .op3_data_wb_o       ( op3_data_wb_q      ),
    .dcache_wdata_d_i    ( dcache_wdata_q     ),
    .dcache_wdata_q_o    ( dcache_wdata_o     )
);

triumph_controller triumph_controller_i(
    .clk_i               ( clk_i              ),
    .rst_i               ( rst_i              ),
    .instr_type_i        ( instr_type         ),
    .opcode_i            ( opcode             ),
    .flag_zero_ex_i      ( flag_zero_ex       ),
    .op3_data_valid_wb_o ( op3_data_valid_wb_d),
    .pc_mux_o            ( pc_mux             ),
    .wb_mux_o            ( wb_mux             ),
    .dcache_write_en_o   ( dcache_write_en_o  )
);


endmodule