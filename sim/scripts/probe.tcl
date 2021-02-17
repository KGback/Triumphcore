database -open waves -shm  -into waves.shm -default
status

status
probe -show -verbose

# probe -create -database waves $uvm:{uvm_test_top} -all -depth all
probe -create -database waves tb.clk_i tb.rstn_i
probe -create -database waves tb.dut.pc tb.dut.instr_rdata tb.dut.triumph_core_i.opcode tb.dut.triumph_core_i.op1_data tb.dut.triumph_core_i.op2_data tb.dut.triumph_core_i.op3_data_wb_d tb.dut.triumph_core_i.op3_data_wb_q tb.dut.triumph_core_i.triumph_id_stage_i.triumph_regfile_ff_i.mem_ff[4] tb.dut.triumph_core_i.triumph_id_stage_i.triumph_regfile_ff_i.mem_ff[5] tb.dut.triumph_core_i.triumph_id_stage_i.triumph_regfile_ff_i.mem_ff[7] tb.dut.triumph_core_i.triumph_id_stage_i.triumph_regfile_ff_i.mem_ff[6] tb.dut.sram_data_i.ram[1] tb.dut.sram_data_i.ram[2]
probe -create -database waves tb.dut.sram_instr_i.ram[1] tb.dut.sram_instr_i.ram[2]

probe -show -verbose

run
exit