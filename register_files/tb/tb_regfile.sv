`timescale 1ns/1ps


module tb_regfile #(
    localparam CLK_PERIOD = 20,
    localparam ADDR_WIDTH = 4,
    localparam DATA_WIDTH = 4
)(
);

// DUT Signals
logic clk;
logic nrst;

logic we;
logic [ADDR_WIDTH-1:0] addr;
logic [DATA_WIDTH-1:0] wdata;
logic [DATA_WIDTH-1:0] rdata;

// DUT Instance
regfile 
`ifndef GATE_LEVEL
#(
    .dataWidth(DATA_WIDTH),
    .addrWidth(ADDR_WIDTH)    
) 
`endif
u_regfile (
    .clk    (clk),
    .nrst   (nrst),

    .we     (we),
    .addr   (addr),
    .wdata  (wdata),
    .rdata  (rdata)
);

// Tasks

task write(
    input logic [ADDR_WIDTH-1:0] address,
    input logic [DATA_WIDTH-1:0] data
);

    begin
        @(negedge clk);
        we    = 1;
        addr  = address;
        wdata = data;
        @(negedge clk);
        we    = 0;
    end

endtask

task read(
    input logic [ADDR_WIDTH-1:0] address,
    output logic [DATA_WIDTH-1:0] data
);
    begin
        @(negedge clk);
        we    = 0;
        addr  = address;
        @(negedge clk);
        data  = rdata;
    end

endtask

// Simulation
always begin
    #(CLK_PERIOD/2);
    clk = ~clk;
end

// SDF annotate if IVerilog
`ifdef SDF_ANNOTATE
    initial begin
        $sdf_annotate("outputs/sdf/min_ss_100C_1v60/regfile__min_ss_100C_1v60.sdf", u_regfile);
    end
`endif


logic [DATA_WIDTH-1:0] written_data [0:2**ADDR_WIDTH-1];
logic [DATA_WIDTH-1:0] read_data ;
logic [ADDR_WIDTH-1:0] temp_addr;

initial begin
    nrst = 0;
    clk = 0;
    #(CLK_PERIOD/2);
    nrst = 1;
    #(CLK_PERIOD*10);

    // Write and Read Test
    for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
        temp_addr = i[ADDR_WIDTH-1:0];
        write(temp_addr, 5);
        written_data[temp_addr] = wdata;
    end

    for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
        temp_addr = i[ADDR_WIDTH-1:0];
        read(temp_addr, read_data);
        
        if (read_data !== written_data[temp_addr]) begin
            $display("Mismatch at address %0d: wrote %0d, read %0d", temp_addr, written_data[temp_addr], read_data);
        end else begin
            $display("Match at address %0d: data %0d", temp_addr, read_data);
        end
    end

    $finish;
end

// Waveform Dump
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_regfile);
end


endmodule
