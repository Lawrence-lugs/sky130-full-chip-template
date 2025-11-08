# User configuration
PDKPATH ?= /path/to/pdk/sky130A

TB                   := tb/tb_regfile_top.sv
RTL                  := src/chip_top.sv src/regfile.sv src/chip_io.sv
OUT                  := sim.out

# PDK library file globs
SKY130_IO_VERILOG    := $(wildcard $(PDKPATH)/libs.ref/sky130_fd_io/verilog/sky130_fd_io.v)
SKY130_EF_IO_VERILOG := $(wildcard $(PDKPATH)/libs.ref/sky130_fd_io/verilog/sky130_ef_io.v)
SKY130_HD_VERILOG    := $(wildcard $(PDKPATH)/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v)
SKY130_PRIM_VERILOG    := $(wildcard $(PDKPATH)/libs.ref/sky130_fd_sc_hd/verilog/primitives.v)

SKY130_IO_PATCHED := build/sky130_fd_io_patched.v

# Icarus flags
IVERILOG_FLAGS       := -g2012 -Wall
DEFINES              := -D USE_POWER_PINS

all: $(OUT)

$(OUT): $(TB) $(RTL) $(SKY130_IO_PATCHED) $(SKY130_HD_VERILOG)
	iverilog $(IVERILOG_FLAGS) \
		$(DEFINES) \
		-o $(OUT) \
		$(TB) $(RTL) \
		$(SKY130_IO_PATCHED) \
		$(SKY130_EF_IO_VERILOG) \
		$(SKY130_PRIM_VERILOG) \
		$(SKY130_HD_VERILOG) 2>&1 | tee iverilog.log

run: $(OUT)
	vvp $(OUT)

$(SKY130_IO_PATCHED): $(SKY130_IO_VERILOG)
	@echo "Patching IO PDK: $< -> $@"
	./scripts/patch_sky130_fd_io.py $(SKY130_IO_VERILOG) $(SKY130_IO_PATCHED)

clean:
	rm -f $(OUT) *.vcd *.fst

.PHONY: all run clean
