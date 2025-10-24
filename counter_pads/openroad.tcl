
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

read_verilog /workspaces/testing_sky130/sky130-full-chip-template/reference_files/caravel_padring__reference.v

link_design chip_io

initialize_floorplan \
  -die_area "0 0 2000 2000" \
  -core_area "250 250 1750 1750" \
  -site unithd

make_tracks

make_fake_io_site \
  -name IO_SITE \
  -width 1 \
  -height 200
make_fake_io_site \
  -name IO_CSITE \
  -width 200 \
  -height 204

make_io_sites -horizontal_site IO_SITE -vertical_site IO_SITE -corner_site IO_CSITE \
  -offset 0 -rotation_horizontal R180 -rotation_vertical R180 -rotation_corner R180

