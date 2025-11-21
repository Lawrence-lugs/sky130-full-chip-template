# Integrating the missing analog blocks onto SKY130 padring

One of the missing blocks is a 10ms power-on-reset timer.
That is, the `sky130_fd_io` pads specify that you must wait ~10ms after VDDC and VSSC have ramped up properly before setting `porb, porb_h, por_l` to their respective voltages.
 