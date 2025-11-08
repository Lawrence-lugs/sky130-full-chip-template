# Simulating with a pad

Conclusion: You can't with open-source tools.

The way `sky130_fd_io/verilog` is written doesn't work with open source tools.
- Verilator doesn't support transistor/gate/buffer level statements.
- IVerilog doesn't allow use of signals before their declarations, which happens for `REFGEN` and `SIO_PAIR` modules in the models. We tried to fix this by moving the assign statements causing the error to the very end of the modules. HOWEVER-->
- IVerilog doesn't allow snooping inside modules. Hence, the scope still cannot find the internal signal.

```bash
build/sky130_fd_io_patched.v:11826: error: Net SIO_PAIR_1_.NOTIFIER_OE_N is not defined in this context.
build/sky130_fd_io_patched.v:11742:      : Found a scope with this name here.
```

I'm pretty sure this would work with Synopsys VCS.

---

# So what to do?

If you HAVE to stick to open source, I would recommend just simulating the spice of the padring (alone, to avoid too much simulation) to see if it works.

So just write an NGSPICE that instantiates `or_chip_io/chip_io.spice` and do a tran simulation with bit stimulus.

There is no mature mixed-signal simulation flow for open-source yet (though I've heard rumors in linkedin)

# Otherwise...

Otherwise, we just stick to simulations of the core.