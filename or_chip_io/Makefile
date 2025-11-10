# Variables
MAGIC=magic
MAGIC_RC_FILE=/foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc
NETGEN=netgen
TOP=chip_io
EXT_DIR=extract
REPORTS_DIR=reports

all: $(TOP).gds $(EXT_DIR)/$(TOP).spice $(REPORTS_DIR)/netgen_lvs.rpt

# Build GDS from DEF
.PHONY: gds
gds:	$(TOP).gds
$(TOP).gds: magic.tcl outputs/$(TOP).def 
	$(MAGIC) -dnull -noconsole -rcfile $(MAGIC_RC_FILE) $<

# Build DEF using OpenROAD
outputs/$(TOP).def: openroad.tcl src/$(TOP).gl.v | outputs
	openroad $< -exit

# Build synthesized netlist
src/$(TOP).gl.v: src/$(TOP).sv yosys.ys
	yosys -s yosys.ys

# Extract SPICE
$(EXT_DIR)/$(TOP).spice: magic_ext2sim.tcl | $(EXT_DIR)
	$(MAGIC) -dnull -noconsole -rcfile $(MAGIC_RC_FILE) $<

# LVS
.PHONY: lvs
lvs:	$(REPORTS_DIR)/netgen_lvs.rpt
$(REPORTS_DIR)/netgen_lvs.rpt: netgen_lvs.tcl | $(REPORTS_DIR)
	$(NETGEN) -batch source $<

outputs:	
	mkdir -p outputs

$(EXT_DIR):	
	mkdir -p $(EXT_DIR)

$(REPORTS_DIR):	
	mkdir -p $(REPORTS_DIR)

clean:	rm -rf $(EXT_DIR) $(REPORTS_DIR) outputs src/$(TOP).gl.v $(TOP).gds
