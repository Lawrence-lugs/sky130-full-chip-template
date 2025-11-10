cd extract

set design_name chip_io
set def_file ../outputs/chip_io.def
set output_spice_file ../outputs/chip_io.spice
set output_ext_file ../outputs/chip_io.ext
set output_sim_file ../outputs/chip_io.sim

def read $def_file

# Create list of abstract cells to be used during extraction
# All IO cells should just use abstract views
# It's weird to extract the pad views. In sky130 we trust.
set cells [cellname list allcells]
set io_cells [concat \
    [lsearch -all -inline $cells *sky130_fd_io*] \
    [lsearch -all -inline $cells *sky130_ef_io*] \
]
set abstract_cells $io_cells

# Set properties for abstract cells to property LEFview true
foreach cell $abstract_cells {
    load $cell
    property LEFview true
}

load $design_name -dereference

# Based off of /usr/local/lib/python3.12/dist-packages/librelane/scripts/magic/extract_spice.tcl
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract unique
extract

# Sim format used by netgen
ext2sim
ext2spice lvs

# For designs with more than one top-level pin connected to the same net
ext2spice short resistor
ext2spice -o outputs/chip_io.spice outputs/chip_io.ext
quit