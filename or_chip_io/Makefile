chip_io.def : openroad.tcl src/chip_io.gl.v
	openroad -no_init -no_prompt openroad.tcl

chip_io.gl.v : src/chip_io.sv
	yosys -s yosys.ys
