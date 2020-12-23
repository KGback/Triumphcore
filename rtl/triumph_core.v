

module triumph_core(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // instruction memory
    output wire [31:0] instr_addr_o,
    input  wire [31:0] instr_rdata_i
);

// if - id
wire        instr_valid_id;        
wire [31:0] instr_rdata_id;
wire [31:0] opPC_data;
wire        pc_mux;

// id - ex
wire [31:0] op1_data;
wire [31:0] op2_data;
wire [2:0]  instr_type;
wire [6:0]  op_type;

// ex - wb
wire        op3_data_valid_wb;
wire [31:0] op3_data_wb;
wire        flag_zero_ex;

triumph_if_stage triumph_if_stage_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
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
    .data_valid_wb_i    ( op3_data_valid_wb  ),
    .op3_data_wb_i      ( op3_data_wb        )
);


triumph_ex_stage triumph_ex_stage_i(
    .clk_i               ( clk_i              ),
    .rst_i               ( rst_i              ),
    .op1_data_i          ( op1_data           ),
    .op2_data_i          ( op2_data           ),
    .op_type_i           ( op_type            ),
    .op3_data_wb_o       ( op3_data_wb        ),
    .flag_zero_ex_o      ( flag_zero_ex       )
);

triumph_controller triumph_controller_i(
    .clk_i               ( clk_i              ),
    .rst_i               ( rst_i              ),
    .instr_type_i        ( instr_type         ),
    .op_type_i           ( op_type            ),
    .flag_zero_ex_i      ( flag_zero_ex       ),
    .op3_data_valid_wb_o ( op3_data_valid_wb  ),
    .pc_mux_o            ( pc_mux             )
);


endmodule