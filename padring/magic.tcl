def read $env(OUTPUTS_DIR)/padring.def
drc check
drc count
drc listall why
gds write $env(OUTPUTS_DIR)/padring_magic.gds
quit