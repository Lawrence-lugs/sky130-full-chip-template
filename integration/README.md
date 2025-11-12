# Padring + Core integration

Here we run librelane to connect the core macro (regfile for now) to the padring.

## Usage

Run make
```
make
```

## DRC and LVS

- [ ] DRC
    - Currently DRC errors exist due to tie cells and clock buffers (why?) being placed before the pad ties. 
    - This is because the 
- [ ] LVS
- [ ] Fill

### Checking the DRC errors

To check on the DRC errors, run make at least once.

Then,

```
librelane --run-tag work -flow=OpenInKLayout
```

Then, Tools > Marker Browser
Then open `runs/work/61-magic-drc/reports/drc_violations.magic.xml` to get the markers open.
Click the flags to find each DRC error. 