# Define the essential variables
RTL_DIR	:= ../rtl
VERILATOR_FLAGS_VERILATE := -I$(RTL_DIR) --cc --sv
VERILATOR_FLAGS_SIMULATE := $(VERILATOR_FLAGS_VERILATE) --build --exe
TOP_MODULE_FILE := $(MODULE_NAME)_wrapper.sv
TOP_TB_FILE := $(MODULE_NAME)_tb.cpp
# Define the targets
verilate : $(TOP_MODULE_FILE)
	@echo "Now verilating module : $(MODULE_NAME)"
	verilator $(VERILATOR_FLAGS_VERILATE) $(MODULE_NAME)_wrapper.sv

simulate : $(TOP_TB_FILE) verilate
	@echo "Compiling and linking the executable....."
	verilator $(VERILATOR_FLAGS_SIMULATE) $(TOP_MODULE_FILE) $(TOP_TB_FILE)

run : simulate
	@echo "Running the executable..........."
	@./obj_dir/V$(MODULE_NAME)_wrapper

clean :
	rm -rf obj_dir
