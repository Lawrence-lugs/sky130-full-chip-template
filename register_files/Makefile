# LIBRELANE HARDENING

librelane : src/regfile.sv config.yaml sak_sky130 check_librelane outputs
	/usr/local/bin/librelane config.yaml --run-tag work --save-views-to outputs --manual-pdk --pdk-root $(PDK_ROOT)
.PHONY: outputs

outputs:
	mkdir -p outputs
.PHONY: outputs

check_librelane: 
	which librelane
.PHONY: check_librelane

sak_sky130:
	/foss/tools/sak/sak-pdk-script.sh sky130A
.PHONY: sak_sky130

# VERILATOR SIMULATION
TOP_MODULE = tb_regfile
RTL_SOURCES = $(wildcard src/*.sv)
EXEC = V$(TOP_MODULE)
OBJ_DIR = obj_dir
VERILATOR_ARGS = -Wall --binary --exe --trace --timing
GATE_LEVEL_SOURCES := outputs/nl/regfile.nl.v

sim_folder: 
	mkdir -p sim
.PHONY: sim_folder

$(OBJ_DIR)/$(EXEC): tb/tb_regfile.sv $(RTL_SOURCES)
	@echo "--- Running Verilator ---"
	verilator $(VERILATOR_ARGS) tb/tb_regfile.sv $(RTL_SOURCES)

sim: $(OBJ_DIR)/$(EXEC) sim_folder
	@echo "--- Running Simulation ---"
	cd sim && ../$(OBJ_DIR)/$(EXEC)
	@echo "--- Simulation Finished ---"
.PHONY: sim

.PHONY: clean
clean:
	@echo "--- Cleaning ---"
	rm -rf $(OBJ_DIR)
	rm -f *.vcd

# Waveform viewing
.PHONY: wave
wave:
	gtkwave dump.vcd

.PHONY: iverilog
iverilog: sim_folder
	iverilog -g2012 -o sim/tb_regfile_iverilog tb/tb_regfile.sv $(RTL_SOURCES)
	cd sim && ./tb_regfile_iverilog

# Gate-level and delay annotated simulation
PDKPATH ?= /path/to/pdk/sky130A
SKY130_HD_VERILOG    := $(wildcard $(PDKPATH)/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v)
SKY130_PRIM_VERILOG    := $(wildcard $(PDKPATH)/libs.ref/sky130_fd_sc_hd/verilog/primitives.v)

.PHONY: sdf_sim 
sdf_sim: sim_folder sak_sky130
	iverilog -g2012 -o sim/tb_regfile_sdf tb/tb_regfile.sv \
	$(SKY130_PRIM_VERILOG) \
	$(SKY130_HD_VERILOG) \
	$(GATE_LEVEL_SOURCES) \
	-DSDF_ANNOTATE \
	-DGATE_LEVEL \
	-gspecify
	cd sim && ./tb_regfile_sdf