set circuit1 [readnet spice /workspaces/sky130-full-chip-template/register_files/runs/work/72-magic-spiceextraction/regfile.spice]
set circuit2 [readnet verilog /dev/null]
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_12.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_12.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_20_12.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_20_12.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_40_12.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_40_12.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_60_12.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_60_12.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_80_12.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_80_12.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_12.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_12.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_2.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_2.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_4.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_4.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_8.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_8.spice $circuit2
puts "Reading SPICE netlist file '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice'..."
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice $circuit2
readnet verilog /workspaces/sky130-full-chip-template/register_files/runs/work/57-openroad-fillinsertion/regfile.pnl.v $circuit2
lvs "$circuit1 regfile" "$circuit2 regfile" /usr/local/lib/python3.12/dist-packages/librelane/scripts/netgen/setup.tcl /workspaces/sky130-full-chip-template/register_files/runs/work/74-netgen-lvs/reports/lvs.netgen.rpt -blackbox -json

lvs:
	@echo "\
	set circuit1 [readnet spice final/spice/${TOP}.spice]\n\
	set circuit2 [readnet verilog /dev/null]\n\
	readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice \$$circuit2\n\
	readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_io/spice/sg13g2_io.spi \$$circuit2\n\
	readnet verilog final/pnl/${TOP}.pnl.v \$$circuit2\n\
	lvs \"\$$circuit1 ${TOP}\" \"\$$circuit2 ${TOP}\" $(PDK_ROOT)/$(PDK)/libs.tech/netgen/ihp-sg13g2_setup.tcl netgen_lvs.rpt -blackbox" > lvs_script.tcl
	
	netgen -batch source lvs_script.tcl
.PHONY: lvs