`timescale 1ns/1ps

module sim_top;
    reg clk = 0;
    reg reset = 1;

    always #5 clk = ~clk;

    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    wire        dmem_read;
    wire        dmem_write;
    wire [2:0]  dmem_funct3;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [31:0] dmem_rdata;

    rv32i_single_cycle core(
        .clk(clk), .reset(reset),
        .imem_addr(imem_addr), .imem_rdata(imem_rdata),
        .dmem_read(dmem_read), .dmem_write(dmem_write), .dmem_funct3(dmem_funct3),
        .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata), .dmem_rdata(dmem_rdata)
    );

    sim_instr_rom #(.MEM_WORDS(64), .INIT_HEX("programs/add_store.hex")) rom(
        .addr(imem_addr),
        .rdata(imem_rdata)
    );

    sim_data_ram #(.MEM_WORDS(64)) ram(
        .clk(clk),
        .mem_read(dmem_read), .mem_write(dmem_write), .funct3(dmem_funct3),
        .addr(dmem_addr), .wdata(dmem_wdata), .rdata(dmem_rdata)
    );

endmodule
