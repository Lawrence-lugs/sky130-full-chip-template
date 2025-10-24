module counter_chip(
    `ifdef USE_POWER_PINS   
    inout vdd,
    inout vss,
    `endif
    
    input clk_i,
    input nrst_i,

    output [3:0] count_o
);

    // Main instance
    counter u_counter (
        `ifdef USE_POWER_PINS   
        .vdd(vdd),
        .vss(vss),
        `endif
        
        .clk_i(clk_i),
        .nrst_i(nrst_i),
        .count_o(count_o)
    );

    // Rings connected by abutment
    wire analog_a_ring;
    wire analog_b_ring;
    wire vssd;
    wire vccd;
    
    // I don't think this is connected by abutment
    wire tielow;
    
    // External inputs?
    wire porb_h; // power on reset bar, active high
    wire por;    // power on reset, active high

    // Clock pad
    sky130_ef_io__gpiov2_pad_wrapped u_clk_pad (
        .AMUXBUS_A(analog_a_ring),
        .AMUXBUS_B(analog_b_ring),
        .ANALOG_EN(vssd),
        .ANALOG_POL(vssd),
        .ANALOG_SEL(vssd),
        .DM({ vssd, vssd, vccd }),
        .ENABLE_H(porb_h),
        .ENABLE_INP_H(tielow),
        .ENABLE_VDDA_H(porb_h),
        .ENABLE_VDDIO(vccd),
        .ENABLE_VSWITCH_H(vssa),
        .HLD_H_N(vddio),
        .HLD_OVR(vssd),
        .IB_MODE_SEL(vssd),
        .IN(clock_core),
        .INP_DIS(por),
        .IN_H(),
        .OE_N(vccd),
        .OUT(vssd),
        .PAD(clock),
        .PAD_A_ESD_0_H(),
        .PAD_A_ESD_1_H(),
        .PAD_A_NOESD_H(),
        .SLOW(vssd),
        .TIE_HI_ESD(),
        .TIE_LO_ESD(tielow),
        .VCCD(vccd),
        .VCCHIB(vccd),
        .VDDA(vdda),
        .VDDIO(vddio),
        .VDDIO_Q(\mprj_pads.vddio_q ),
        .VSSA(vssa),
        .VSSD(vssd),
        .VSSIO(vssio),
        .VSSIO_Q(\mprj_pads.vssio_q ),
        .VSWITCH(vddio),
        .VTRIP_SEL(vssd)
  );

  // NRST pad

  // VDD pad

  // VSS pad

  // COUNT[3:0] pads

endmodule