// Chip top integrating regfile with the padring GPIOs.
// Pads used:
//   0     : clk    (input)
//   1     : nrst   (input, active low)
//   2     : we     (input)
//   3-6   : addr[3:0] (input)
//   7-10  : wdata[3:0] (input)
//   11-14 : rdata[3:0] (output)
//   15    : unused

module chip_top #(
    // Parameters
    parameter int NUM_GPIO = 16,
    parameter int DATA_W   = 4,
    parameter int ADDR_W   = 4
) (
    // Ports
    inout  wire [NUM_GPIO-1:0] gpio_pad
);

    // ============================================================
    // Wire/logic declarations
    // ============================================================
    // Supplies / resets (idealized for simulation)
    logic vccd, vssd, vddio, vssio;
    logic porb_h; // active high enable (sense inverted reset)
    logic por;    // active high reset (non-inverted core domain)

    // Core-facing pad signals
    wire [NUM_GPIO-1:0] gpio_in;
    wire [NUM_GPIO-1:0] gpio_out;

    // Pad configuration buses
    logic [NUM_GPIO-1:0] dm0, dm1, dm2;
    logic [NUM_GPIO-1:0] oe_n;
    logic [NUM_GPIO-1:0] hld_ovr;
    logic [NUM_GPIO-1:0] ib_mode_sel;

    // Core signals
    wire clk               = gpio_in[0];
    wire nrst              = gpio_in[1];
    wire we                = gpio_in[2];
    wire [ADDR_W-1:0] addr = gpio_in[6:3];
    wire [DATA_W-1:0] wdata= gpio_in[10:7];
    wire [DATA_W-1:0] rdata;

    // DM encoding (Sky130 gpiov2) - local to this module
    localparam [2:0] DM_INPUT  = 3'b001; // Input only
    localparam [2:0] DM_OUTPUT = 3'b110; // Push-pull output

    // ============================================================
    // Assignments
    // ============================================================
    // Drive rdata to gpio_out[14:11]; tie others low
    assign gpio_out[14:11] = rdata;
    assign gpio_out[10:0]  = '0;
    assign gpio_out[15]    = 1'b0;

    // Static pad config: inputs 0..10, outputs 11..14, pad 15 input/unused
    genvar i;
    generate
        for (i = 0; i < NUM_GPIO; i++) begin : dm_cfg
            if (i <= 10) begin
                assign {dm2[i], dm1[i], dm0[i]} = DM_INPUT;
                assign oe_n[i] = 1'b1; // disable output (active low)
            end else if (i >= 11 && i <= 14) begin
                assign {dm2[i], dm1[i], dm0[i]} = DM_OUTPUT;
                assign oe_n[i] = 1'b0; // enable output
            end else begin
                assign {dm2[i], dm1[i], dm0[i]} = DM_INPUT;
                assign oe_n[i] = 1'b1;
            end
            assign hld_ovr[i]     = 1'b0;
            assign ib_mode_sel[i] = 1'b0;
        end
    endgenerate

    // Tie supplies internally for pure logic simulation (can be overridden by TB via force)
    // These assignments can be driven from testbench with 'force' if needed.
    assign vccd  = 1'b1;
    assign vddio = 1'b1;
    assign vssd  = 1'b0;
    assign vssio = 1'b0;
    // Resets (pad-level POR not used by regfile)
    assign porb_h = 1'b1;
    assign por    = 1'b1;

    // ============================================================
    // Module instances
    // ============================================================
    // Regfile instance
    regfile #(
        .dataWidth(DATA_W),
        .addrWidth(ADDR_W)
    ) u_regfile (
        .clk   (clk),
        .nrst  (nrst),
        .we    (we),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );

    // Padring instance
    chip_io #(
        .numGPIO(NUM_GPIO)
    ) u_chip_io (
        .vccd       (vccd),
        .vssd       (vssd),
        .vddio      (vddio),
        .vssio      (vssio),
        .porb_h     (porb_h),
        .por        (por),
        .gpio_pad   (gpio_pad),
        .gpio_in    (gpio_in),
        .gpio_out   (gpio_out),
        .dm2        (dm2),
        .dm1        (dm1),
        .dm0        (dm0),
        .oe_n       (oe_n),
        .hld_ovr    (hld_ovr),
        .ib_mode_sel(ib_mode_sel)
    );

    // ============================================================
    // Behavioral blocks (none)
    // ============================================================

endmodule