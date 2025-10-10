MAGIC_RC_FILE = /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc
OUTPUTS_DIR = outputs

export OUTPUTS_DIR

gds: $(OUTPUTS_DIR)/padring.def magic.tcl $(MAGIC_RC_FILE)
	magic -dnull -noconsole -rcfile $(MAGIC_RC_FILE) magic.tcl | tee $(OUTPUTS_DIR)/gdsmake.log

$(OUTPUTS_DIR)/padring.def: padring.cfg
	padring -v --lef $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef --svg $(OUTPUTS_DIR)/padring.svg --def $(OUTPUTS_DIR)/padring.def padring.cfg | tee $(OUTPUTS_DIR)/padring.log

clean:
	rm -rf $(OUTPUTS_DIR)/*