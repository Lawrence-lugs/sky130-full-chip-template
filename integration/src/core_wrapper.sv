// Instantiates the core and connects the pad configuration signals

module core_wrapper #(
    // Parameters
    parameter int NUM_GPIO = 16,
    parameter int DATA_W   = 4,
    parameter int ADDR_W   = 4
) (
    // Ports
`ifdef USE_POWER_PINS
    inout vccd, 
    inout vssd, 
    inout vddio, 
    inout vssio, 
`endif
    // inout porb_h,
    // inout por,
    // Pad signals
    inout [NUM_GPIO-1:0] gpio_pad,
    input [NUM_GPIO-1:0] gpio_in,
    output [NUM_GPIO-1:0] gpio_out,
    // Pad configuration buses
    output [NUM_GPIO-1:0] dm0, 
    output [NUM_GPIO-1:0] dm1,
    output [NUM_GPIO-1:0] dm2,
    output [NUM_GPIO-1:0] oe_n,
    output [NUM_GPIO-1:0] hld_ovr,
    output [NUM_GPIO-1:0] ib_mode_sel
);

    // DM encoding (Sky130 gpiov2)
    localparam [2:0] DM_INPUT  = 3'b001; // Input only
    localparam [2:0] DM_OUTPUT = 3'b110; // Push-pull output

    // Core signals
    wire clk               = gpio_in[0];
    wire nrst              = gpio_in[1];
    wire we                = gpio_in[2];
    wire [ADDR_W-1:0] addr = gpio_in[6:3];
    wire [DATA_W-1:0] wdata= gpio_in[10:7];
    wire [DATA_W-1:0] rdata= gpio_out[10:7];

    // All unused outputs tie to 0
    // assign gpio_out[NUM_GPIO-1:11]   = '0;
    // assign gpio_out[6:0]             = '0;
    // assign dm0[NUM_GPIO-1:0]         = '0;
    // assign dm1[NUM_GPIO-1:0]         = '0;
    // assign dm2[NUM_GPIO-1:0]         = '1;
    // assign oe_n[NUM_GPIO-1:0]        = '1; // Only data pins are outputs
    // assign hld_ovr[NUM_GPIO-1:0]     = '0;
    // assign ib_mode_sel[NUM_GPIO-1:0] = '0;

    // Instantiate core
    // No parameters in this instantiation because
    // we are already using the gate-level netlist of the core.
    regfile u_regfile (
`ifdef USE_POWER_PINS
        .vccd (vccd),
        .vssd (vssd),
`endif
        .clk   (clk),
        .nrst  (nrst),
        .we    (we),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );

endmodule