module regfile #(
    parameter dataWidth = 4,
    parameter addrWidth = 4,
    parameter memDepth = 1 << addrWidth
)(
    input logic clk,
    input logic nrst,
    input logic we,
    input logic [addrWidth-1:0] addr,
    input logic [dataWidth-1:0] wdata,
    output logic [dataWidth-1:0] rdata
);

    logic [dataWidth-1:0] regs [0:memDepth-1];

    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            for (int i = 0; i < memDepth; i++) begin
                regs[i] <= '0;
            end
            rdata <= 0; // Registered data read
        end else begin 
            if (we) begin
                regs[addr] <= wdata;
            end else begin
                rdata <= regs[addr];
            end
        end
    end

endmodule
