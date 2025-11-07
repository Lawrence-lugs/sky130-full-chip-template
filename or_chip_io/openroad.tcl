
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

read_verilog /workspaces/sky130-full-chip-template/or_chip_io/outputs/chip_io.gl.v
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

######## Helper spacing based on caravel_sample.tcl (scaled to fit die height) ########
# We use relative weights derived from observed spacings in caravel_sample.tcl and
# scale them to fit the 2000um side. The next pad location increments are based on
# the master of the previous pad.

# Spacing weights (relative): gpiov2 ~225, lvc/hvc power pads ~220-221
array set pad_weight {
  sky130_ef_io__gpiov2_pad_wrapped 1.000
  sky130_ef_io__vccd_lvc_pad       0.982
  sky130_ef_io__vssd_lvc_pad       0.982
  sky130_ef_io__vssio_hvc_pad      0.978
  sky130_ef_io__vddio_hvc_pad      0.978
}

proc get_weight {master} {
  upvar pad_weight pad_weight
  if {[info exists pad_weight($master)]} {
    return $pad_weight($master)
  }
  return 1.0
}

proc place_row_pads {row start end pad_list} {
  # pad_list: flat list {master inst master inst ...}
  set n [llength $pad_list]
  if {$n < 2} { return }
  # Sum weights for each step (based on previous master)
  set sumw 0.0
  for {set i 0} {$i < $n - 2} {incr i 2} {
    set master [lindex $pad_list $i]
    set w [get_weight $master]
    set sumw [expr {$sumw + $w}]
  }
  set usable [expr {$end - $start}]
  if {$usable <= 0 || $sumw <= 0} {
    set base 150.0
  } else {
    set base [expr {$usable / $sumw}]
  }
  set loc $start
  for {set i 0} {$i < $n} {incr i 2} {
    set master [lindex $pad_list $i]
    set inst   [lindex $pad_list [expr {$i+1}]]
    # Use [list $inst] to preserve special chars like [] in instance names
    place_pad -master $master -row $row -location $loc $inst
    if {$i < $n - 2} {
      set w [get_weight $master]
      set loc [expr {$loc + $base * $w}]
    }
  }
}

# Define pad sequences per row (order matters)
set east_pads [list \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[15\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[14\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[13\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[12\].u_gpio_pad} \
  sky130_ef_io__vccd_lvc_pad        {vccd} \
  sky130_ef_io__vssd_lvc_pad        {vssd} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[11\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[10\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[9\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[8\].u_gpio_pad} \
  sky130_ef_io__vssio_hvc_pad       {u_vssio_pad} \
  sky130_ef_io__vddio_hvc_pad       {u_vddio_pad} \
]

set west_pads [list \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[7\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[6\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[5\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[4\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[3\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[2\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[1\].u_gpio_pad} \
  sky130_ef_io__gpiov2_pad_wrapped  {gpio_pads\[0\].u_gpio_pad} \
  sky130_ef_io__vccd_lvc_pad        {u_vccd_pad} \
  sky130_ef_io__vssd_lvc_pad        {u_vssd_pad} \
]

# Place with scaled spacing so pads fit on 2000um side; keep ~250um margins from corners
place_row_pads IO_EAST 300 1700 $east_pads
place_row_pads IO_WEST 300 1700 $west_pads

# Place corner
place_corners sky130_ef_io__corner_pad

# Place fill
place_io_fill \
  -row IO_NORTH \
  sky130_ef_io__com_bus_slice_1um \
  sky130_ef_io__com_bus_slice_5um \
  sky130_ef_io__com_bus_slice_20um \
  sky130_ef_io__com_bus_slice_10um
place_io_fill \
  -row IO_SOUTH \
  sky130_ef_io__com_bus_slice_20um \
  sky130_ef_io__com_bus_slice_10um \
  sky130_ef_io__com_bus_slice_5um \
  sky130_ef_io__com_bus_slice_1um
place_io_fill \
  -row IO_WEST \
  sky130_ef_io__com_bus_slice_20um \
  sky130_ef_io__com_bus_slice_10um \
  sky130_ef_io__com_bus_slice_5um \
  sky130_ef_io__com_bus_slice_1um
place_io_fill \
  -row IO_EAST \
  sky130_ef_io__com_bus_slice_20um \
  sky130_ef_io__com_bus_slice_10um \
  sky130_ef_io__com_bus_slice_5um \
  sky130_ef_io__com_bus_slice_1um

connect_by_abutment
place_io_terminals */PAD
place_io_terminals -allow_non_top_layer */IN
place_io_terminals -allow_non_top_layer */HLD_OVR
place_io_terminals -allow_non_top_layer */IB_MODE_SEL
place_io_terminals -allow_non_top_layer */INP_DIS
place_io_terminals -allow_non_top_layer */OE_N
place_io_terminals -allow_non_top_layer */OUT
place_io_terminals -allow_non_top_layer */PAD
place_io_terminals -allow_non_top_layer */DM\[0\]
place_io_terminals -allow_non_top_layer */DM\[1\]
place_io_terminals -allow_non_top_layer */DM\[2\]

place_io_terminals -allow_non_top_layer */ENABLE_H
place_io_terminals -allow_non_top_layer */ENABLE_VDDA_H

place_io_terminals -allow_non_top_layer u_vccd_pad/VCCD
place_io_terminals -allow_non_top_layer u_vssd_pad/VSSD
place_io_terminals -allow_non_top_layer vccd/VCCD
place_io_terminals -allow_non_top_layer vssd/VSSD
place_io_terminals -allow_non_top_layer u_vddio_pad/VDDIO
place_io_terminals -allow_non_top_layer u_vssio_pad/VSSIO

# Remove the rows so they don't show up in the DEF
remove_io_rows

set def_file "chip_io.def"
write_def $def_file
