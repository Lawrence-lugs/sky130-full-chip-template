# This TCL file can be sourced for openroad to work with base sky130A
# example:
# ```bash
# openroad -gui sourceme_openroad.tcl
# ```
# then do stuff you want to do with openROAD

# Read tech lef
read_lef /foss/pdks/ciel/sky130/versions/0536d02d875c8f67dd7cca3902ac457e62f20005/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef

# Read standard cell lefs
read_lef /foss/pdks/ciel/sky130/versions/0536d02d875c8f67dd7cca3902ac457e62f20005/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef
read_lef /foss/pdks/ciel/sky130/versions/0536d02d875c8f67dd7cca3902ac457e62f20005/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

# Read pad lefs
read_lef /foss/pdks/ciel/sky130/versions/0536d02d875c8f67dd7cca3902ac457e62f20005/sky130A/libs.ref/sky130_fd_io/lef/sky130_fd_io.lef
read_lef /foss/pdks/ciel/sky130/versions/0536d02d875c8f67dd7cca3902ac457e62f20005/sky130A/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef

# Read the nominal corner timing library
read_liberty /foss/pdks/ciel/sky130/versions/0536d02d875c8f67dd7cca3902ac457e62f20005/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
