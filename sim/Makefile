# Authored by kevin.

# common variables
BANNER=*******************************************************************************************

# some directories
ROOT_DIR=  $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/..
export RTL_DIR=$(ROOT_DIR)/rtl
export TB_DIR=$(ROOT_DIR)/tb
TESTS_DIR=$(ROOT_DIR)/tests
SIM_DIR=$(ROOT_DIR)/sim
BUILD_DIR=$(SIM_DIR)/build

XRUN_RESULTS = $(BUILD_DIR)/xrun_results

# some files
TB_TOP         = $(TB_DIR)/tb.sv
TRIUMPHCORE_FL = $(RTL_DIR)/triumphcore.flist
TB_FL          = $(TB_DIR)/tb.flist

# xcelium options
XCOMP_OPT	=		-64bit -access +rwc\
					-disable_sem2009\
					-quiet\
					-sv \
					+incdir+$(TB_DIR)\
					+incdir+$(RTL_DIR)\
					-f $(TRIUMPHCORE_FL) \
					-f $(TB_FL)
XELAB_OPT   = 		-64bit\
					-disable_sem2009\
					-timescale 1ns/1ps\
					+incdir+$(TB_DIR)\
					+incdir+$(RTL_DIR)\
					-f $(TRIUMPHCORE_FL) \
					-f $(TB_FL)
XSIM_OPT	=		-64bit \
					-R -xmlibdirname $(XRUN_RESULTS)/xcelium.d \
					$(XRUN_GUI)\
					-input $(SIM_DIR)/scripts/probe.tcl

ifeq ($(call IS_YES,$(GUI)),YES)
XRUN_GUI += -gui
endif

# some toolchain options
COMMON32_OPT=-Wa,-march=rv32gv -mabi=ilp32 -march=rv32imac -g -Wl,--start-group,-lg,-lgloss,--end-group -lm -DRVTEST_ASSERT
GCC_OPTION=-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
ifeq (${TRACE}, 1)
	TRACE_OPT = --trace --tracechange
else
	TRACE_OPT = 
endif

# define which test to run 
RISCV_ISA_ALL = $(shell ls $(TESTS_DIR))
ifneq (${RISCV_ISA}, )
include $(TESTS_DIR)/${RISCV_ISA}/scripts/Makefrag 
endif

target_elf = $(foreach e,$(target_tests),$(e))


xcomp:
	mkdir -p $(XRUN_RESULTS)
	@echo "$(BANNER)"
	@echo "* Compiling xrun in $(XRUN_RESULTS)"
	@echo "* Log: $(XRUN_RESULTS)/xrun.log"
	@echo "$(BANNER)"
	cd $(XRUN_RESULTS) && xrun -compile\
		$(XCOMP_OPT) \
		-top $(TB_TOP) \
		-l xcomp.log 
	cd $(XRUN_RESULTS) && xrun -elaborate \
		${XELAB_OPT}\
		-l xelab.log

sanity: xcomp
	@make Fibonacci_seq.xrun RISCV_ISA=fibonacci GUI=YES
	
sim: $(target_elf)


%.xrun: %.gcc
	@mkdir -p $(XRUN_RESULTS)/$(basename $@)
	cd $(XRUN_RESULTS)/$(basename $@) && xrun \
			$(XSIM_OPT)\
			-l xsim.log
	cd $(XRUN_RESULTS)/$(basename $@) && simvision waves.shm

%.gcc:
	@mkdir -p $(XRUN_RESULTS)/$(basename $@)
	cd $(XRUN_RESULTS)/$(basename $@) && riscv32-unknown-elf-gcc ${COMMON32_OPT} ${GCC_OPTION} ${TESTS_DIR}/${RISCV_ISA}/$(basename $@).S -I$(env_dir) -T${link_file} -o $(basename $@)
	cd $(XRUN_RESULTS)/$(basename $@) && riscv32-unknown-elf-objdump -D $(basename $@) > $(basename $@).dump

help:
	xrun -help

clean:
	rm -rf $(BUILD_DIR)