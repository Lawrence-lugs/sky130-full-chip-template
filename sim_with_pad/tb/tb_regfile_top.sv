`timescale 1ns/1ps

module tb_regfile_top;

    parameter int WRITE_COUNT = 6;

    // ------------------------------------------------------------
    // Wires
    // ------------------------------------------------------------
    wire [15:0] gpio_pad;        
    wire [3:0]  rdata_obs = gpio_pad[14:11];

    // ------------------------------------------------------------
    // Regs
    // ------------------------------------------------------------
    reg clk_drv;
    reg nrst_drv;
    reg we_drv;
    reg [3:0] addr_drv;
    reg [3:0] wdata_drv;
    reg [3:0] shadow_mem [0:15];
    logic [3:0] rdata_prev;

    // ------------------------------------------------------------
    // Assign drive-outs to pads
    // ------------------------------------------------------------
    assign gpio_pad[0]     = clk_drv;
    assign gpio_pad[1]     = nrst_drv;
    assign gpio_pad[2]     = we_drv;
    assign gpio_pad[6:3]   = addr_drv;
    assign gpio_pad[10:7]  = wdata_drv;
    // Pads [14:11] are observed only; DO NOT assign to them.

    // ------------------------------------------------------------
    // DUT instantiation
    // ------------------------------------------------------------
    chip_top dut (
        .gpio_pad(gpio_pad)
    );

    // ------------------------------------------------------------
    // Clock generation
    // ------------------------------------------------------------
    initial begin
        clk_drv = 0;
        forever #5 clk_drv = ~clk_drv;   // 100 MHz
    end

    // ------------------------------------------------------------
    // Stimulus
    // ------------------------------------------------------------
    initial begin
        int num_errors = 0;

        // Initialize drives
        nrst_drv  = 1'b0;
        we_drv    = 1'b0;
        addr_drv  = '0;
        wdata_drv = '0;

        // Clear shadow
        for (int i = 0; i < 16; i++)
            shadow_mem[i] = '0;

        // Apply reset
        repeat (3) @(posedge clk_drv);
        nrst_drv = 1'b1;
        repeat (2) @(posedge clk_drv);

        // Perform writes (through pads)
        for (int i = 0; i < 6; i++) begin
            addr_drv  = i[3:0];
            wdata_drv = (i * 3) & 4'hF;
            we_drv    = 1'b1;

            @(posedge clk_drv);
            shadow_mem[addr_drv] = wdata_drv;
        end

        // Disable write path
        we_drv    = 1'b0;
        wdata_drv = '0;
        @(posedge clk_drv);

        // Perform reads and check
        for (int i = 0; i < WRITE_COUNT; i++) begin
            addr_drv = i[3:0];
            we_drv   = 1'b0;

            @(posedge clk_drv);
            #1;

            if (rdata_obs !== shadow_mem[i]) begin
                $display("[%0t] ERROR Read addr=%0d got %h expected %h",
                         $time, i, rdata_obs, shadow_mem[i]);
                num_errors++;
            end else begin
                $display("[%0t] INFO Read addr=%0d OK (%h)",
                         $time, i, rdata_obs);
            end
        end

        // Final result
        if (num_errors == 0) begin
            $display("==================================================");
            $display("REGFILE PADRING TEST PASSED");
            $display("==================================================");
        end else begin
            $display("==================================================");
            $display("REGFILE PADRING TEST FAILED with %0d errors",
                     num_errors);
            $display("==================================================");
        end

        $finish;
    end

    // ------------------------------------------------------------
    // Assertions
    // ------------------------------------------------------------
    always @(posedge clk_drv) begin
        rdata_prev <= rdata_obs;
        if (we_drv) begin
            assert (rdata_obs === rdata_prev)
                else $error("[%0t] ASSERTION FAILED: rdata changed during write",
                            $time);
        end
    end

endmodule
