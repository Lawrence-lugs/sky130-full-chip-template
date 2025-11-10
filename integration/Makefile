RUN_DIRNAME := work
PDK_ROOT ?= /path/to/pdk/sky130A
TEE_COMMAND := 2>&1 | tee logs/librelane_$(RUN_DIRNAME).log

librelane : librelane_config.yaml src/core_wrapper.sv outputs logs
	librelane $< --run-tag $(RUN_DIRNAME) --save-views-to outputs --manual-pdk --pdk-root $(PDK_ROOT) $(TEE_COMMAND)
.PHONY: librelane

outputs:
	mkdir -p outputs

logs:
	mkdir -p logs