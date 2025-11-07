def read outputs/chip_io.def
drc check
drc count
drc listall why
gds write outputs/chip_io.gds
quit