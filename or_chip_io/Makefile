MAGIC_RC_FILE = /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc

chip_io.gds : outputs/chip_io.def
	magic -dnull -noconsole -rcfile $(MAGIC_RC_FILE) magic.tcl

chip_io.def : openroad.tcl src/chip_io.gl.v
	openroad openroad.tcl -exit

src/chip_io.gl.v : src/chip_io.sv
	yosys -s yosys.ys