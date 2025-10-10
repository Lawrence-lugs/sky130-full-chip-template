// Simulation-only instruction ROM with hex initialization
module sim_instr_rom #(
    parameter MEM_WORDS = 1024,
    parameter INIT_HEX  = "programs/add_store.hex"
) (
    input  [31:0] addr,
    output [31:0] rdata
);
    reg [31:0] mem [0:MEM_WORDS-1];

    initial begin
        integer i;
        for (i = 0; i < MEM_WORDS; i = i + 1) mem[i] = 32'h00000013; // NOPs
        $readmemh(INIT_HEX, mem);
    end

    wire [31:0] idx = addr[31:2];
    assign rdata = (idx < MEM_WORDS) ? mem[idx] : 32'h00000013; // NOP if OOB
endmodule
