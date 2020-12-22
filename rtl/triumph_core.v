

module triumph_core(
    // Clock and Reset
    input  wire        clk_i,
    input  wire        rst_i,
    // instruction memory
    output wire [31:0] instr_addr_o,
    input  wire [31:0] instr_rdata_i
);

// if - id
wire [31:0] instr_rdata_id;

// id - ex
wire [4:0]  regfile_rs1_addr;
wire [4:0]  regfile_rs2_addr;
wire [4:0]  regfile_rd_addr;

wire [31:0] regfile_rs1_data;
wire [31:0] regfile_rs2_data;

wire [6:0]  op_type;

// ex - wb
wire        data_valid_wb;
wire [31:0] rd_data_wb;

triumph_if_stage triumph_if_stage_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .instr_addr_o       ( instr_addr_o       ),
    .instr_rdata_i      ( instr_rdata_i      ),
    .instr_valid_id_o   ( instr_valid_id     ),
    .instr_data_id_o    ( instr_rdata_id     )
);

triumph_id_stage triumph_id_stage_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .instr_valid_i      ( instr_valid_id     ),
    .instr_data_i       ( instr_rdata_id     ),
    .regfile_rs1_addr_o ( regfile_rs1_addr   ),
    .regfile_rs2_addr_o ( regfile_rs2_addr   ),
    .regfile_rd_addr_o  ( regfile_rd_addr    ),
    .op_type_ex_o       ( op_type            )
);

triumph_regfile_ff triumph_regfile_ff_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .rs1_addr_id_i      ( regfile_rs1_addr   ),
    .rs1_data_ex_o      ( regfile_rs1_data   ),
    .rs2_addr_id_i      ( regfile_rs2_addr   ),
    .rs2_data_ex_o      ( regfile_rs2_data   ),
    .data_valid_wb_i    ( data_valid_wb      ),
    .rd_addr_id_i       ( regfile_rd_addr    ),
    .rd_data_wb_i       ( rd_data_wb         )
);

triumph_ex_stage triumph_ex_stage_i(
    .clk_i              ( clk_i              ),
    .rst_i              ( rst_i              ),
    .regfile_rs1_data_i ( regfile_rs1_data   ),
    .regfile_rs2_data_i ( regfile_rs2_data   ),
    .op_type_i          ( op_type            ),
    .rd_data_valid_wb_o ( data_valid_wb      ),
    .rd_data_wb_o       ( rd_data_wb         )
);


endmodule