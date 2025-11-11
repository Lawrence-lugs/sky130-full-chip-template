RUN_DIRNAME := work
PDK_ROOT ?= /path/to/pdk/sky130A
# TEE_COMMAND := 2>&1 | tee logs/librelane_$(RUN_DIRNAME).log
TEE_COMMAND := 

librelane : librelane_config.yaml src/core_wrapper.sv outputs logs outputs/chip_io_template.def
	librelane $< --run-tag $(RUN_DIRNAME) --save-views-to outputs --manual-pdk --overwrite --pdk-root $(PDK_ROOT) $(TEE_COMMAND)
.PHONY: librelane

# apply clean_def.py to chip_io.def to remove unneeded sections
outputs/chip_io_template.def : ../or_chip_io/outputs/chip_io.def clean_def.py outputs
	python3 clean_def.py $< $@

outputs:
	mkdir -p outputs

logs:
	mkdir -p logs