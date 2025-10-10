SRC_FILES := $(wildcard src/*.v)
RUN_TAG = $(shell ls runs/ | tail -n 1)

gds: librelane_config.json $(SRC_FILES)
	librelane librelane_config.json
	mv -r runs/$(RUN_TAG)/final/ final/

.PHONY: move_final
move_final: 
	mv -r runs/$(RUN_TAG)/final/ final/