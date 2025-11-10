set circuit1 [readnet spice outputs/chip_io.spice]
set circuit2 [readnet verilog /dev/null]

# Readnet the spice for standard cells
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

# Readnet the spice for IO cells
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_io/spice/sky130_fd_io.spice $circuit2
readnet spice /foss/pdks/sky130A/libs.ref/sky130_fd_io/spice/sky130_ef_io__analog.spice $circuit2

readnet verilog outputs/chip_io.gl.v $circuit2

lvs "$circuit1 chip_io" "$circuit2 chip_io" /usr/local/lib/python3.12/dist-packages/librelane/scripts/netgen/setup.tcl reports/netgen_lvs.rpt -blackbox -json
