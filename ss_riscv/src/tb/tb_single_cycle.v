`timescale 1ns/1ps

module tb_single_cycle;
    reg clk = 0;
    reg reset = 1;

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    sim_top dut();

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_single_cycle);

        // Drive reset inside sim_top via force/release
        force dut.reset = 1'b1;
        repeat (3) @(posedge clk);
        force dut.reset = 1'b0;
        release dut.reset;

        // Run for some cycles
        repeat (50) @(posedge clk);

        // Peek data memory word 0
        $display("DMEM[0] = %0d (0x%08x)", dut.ram.mem[0], dut.ram.mem[0]);

        $finish;
    end
endmodule
