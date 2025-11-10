# OpenROAD pad generation

Here I test the OpenROAD flow for generating pads by creating a counter with 8 pads (4b count, VDD and VSS, CLK, NRST)

### Usage

Just use the makefile
```
make
```

### DRC and LVS

- [x] DRC
- [ ] Script the DRC
- [ ] LVS - Failing atm. Likely due to having to extract the pads when they already have their own spice.

### How to make edits

`src/chip_io.sv` contains the definitions of the pads. Edit logical connections there.
`openroad.tcl` creates the actual pad layout. If you add new pads, make sure to add the pad instance there.