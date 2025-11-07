# OpenROAD pad generation

Here I test the OpenROAD flow for generating pads by creating a counter with 8 pads (4b count, VDD and VSS, CLK, NRST)

### Usage

```
yosys -s yosys.ys
openroad -gui openroad.tcl
```
or just use the makefile
```
make
```

### How to make edits

`chip_io.sv` contains the definitions of the pads. Edit logical connections there.
`openroad.tcl` creates the actual pad layout. If you add new pads, make sure to add the pad instance there.