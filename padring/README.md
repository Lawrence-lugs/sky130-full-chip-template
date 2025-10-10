# Sky130 Padring Example

Example taken from [YosysHQ padring issue 9](https://github.com/YosysHQ/padring/issues/9)

Must target sky130_ef_io__** pads, not sky130_fd_io__** pads.
This is because the ef (Efabless) pads have corrected versions of the fd (foundry) pads and other supplementary things.

The current padring is a sample- not yet final.

### Recommended flow

Run `make`

### DRC

`run.sh` script by itself already runs magic drc.
You can reconfirm DRC clean by opening in Magic or KLayout.