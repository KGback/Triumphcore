# Authored by kevin.

# common variables
BANNER=*******************************************************************************************

# some directories
ROOT_DIR=  $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/..
export RTL_DIR=$(ROOT_DIR)/rtl
export TB_DIR=$(ROOT_DIR)/tb
TESTS_DIR=$(ROOT_DIR)/tests
export SIM_DIR=$(ROOT_DIR)/sim
BUILD_DIR=$(SIM_DIR)/build

XRUN_RESULTS = $(BUILD_DIR)/xrun_results

# some files
TB_TOP         = $(TB_DIR)/tb.sv
TRIUMPHCORE_FL = $(RTL_DIR)/triumphcore.flist
TB_FL          = $(TB_DIR)/tb.flist


#=============================================
#         xcelium comp, elab and simulate
#=============================================

# xcelium options
XCOMP_OPT	=		-64bit \
					-access +r\
					-disable_sem2009\
					-quiet\
					-sv \
					-top $(TB_TOP) \
					+incdir+$(TB_DIR)\
					+incdir+$(RTL_DIR)\
					-f $(TRIUMPHCORE_FL) \
					-f $(TB_FL)
XELAB_OPT   = 		-64bit\
					-access +r\
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


# define which test to run 
ifneq (${TEST}, )
include $(TESTS_DIR)/${TEST}/scripts/Makefrag 
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
		-l xcomp.log 
	cd $(XRUN_RESULTS) && xrun -elaborate \
		${XELAB_OPT}\
		-l xelab.log

sanity: xcomp
	@make sim TEST=fibonacci GUI=1
	
sim: xcomp $(target_elf)

%.xrun: %.elf
	@mkdir -p $(XRUN_RESULTS)/$(basename $@)
	cd $(XRUN_RESULTS)/$(basename $@) && xrun \
			$(XSIM_OPT)\
			-l xsim.log
	cd $(XRUN_RESULTS)/$(basename $@) && simvision waves.shm

help:
	xrun -help

#===========================================
#       riscv-toolchain gcc, objdump
#===========================================

# some toolchain options
COMMON32_OPT=-Wa,-march=rv32i -mabi=ilp32 -g -Wl,--start-group,-lg,-lgloss,--end-group -lm -DRVTEST_ASSERT
GCC_OPTION=-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles

%.elf: ${TESTS_DIR}/${TEST}/%.S
	@mkdir -p $(XRUN_RESULTS)/$(basename $@)
	cp ${TESTS_DIR}/${TEST}/$(basename $@).S $(XRUN_RESULTS)/$(basename $@)
	cd $(XRUN_RESULTS)/$(basename $@) && riscv32-unknown-elf-gcc ${COMMON32_OPT} ${GCC_OPTION} -c $< -o $@
	cd $(XRUN_RESULTS)/$(basename $@) && riscv32-unknown-elf-objdump -D $@ > $(basename $@).dump
%.elf: ${TESTS_DIR}/${TEST}/%.c
	@mkdir -p $(XRUN_RESULTS)/$(basename $@)
	cp ${TESTS_DIR}/${TEST}/$(basename $@).c $(XRUN_RESULTS)/$(basename $@)
	cd $(XRUN_RESULTS)/$(basename $@) && riscv32-unknown-elf-gcc ${COMMON32_OPT} ${GCC_OPTION} -c $< -o $@
	cd $(XRUN_RESULTS)/$(basename $@) && riscv32-unknown-elf-objdump -D $@ > $(basename $@).dump

clean:
	rm -rf $(BUILD_DIR)