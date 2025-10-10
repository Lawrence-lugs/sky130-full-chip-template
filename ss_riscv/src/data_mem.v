`include "rv32i_defs.vh"

// Simulation-only data RAM
module sim_data_ram #(
    parameter MEM_WORDS = 1024
) (
    input              clk,
    input              mem_read,
    input              mem_write,
    input      [2:0]   funct3,
    input      [31:0]  addr,
    input      [31:0]  wdata,
    output reg [31:0]  rdata
);
    reg [31:0] mem [0:MEM_WORDS-1];

    integer i;
    initial begin
        for (i = 0; i < MEM_WORDS; i = i + 1) mem[i] = 32'b0;
    end

    wire [31:0] widx = addr[31:2];
    wire [1:0]  byte_off = addr[1:0];

    // Combinational read
    always @* begin
        if (mem_read && widx < MEM_WORDS) begin
            case (funct3)
                `F3_LB: begin
                    case (byte_off)
                        2'd0: rdata = {{24{mem[widx][7]}},  mem[widx][7:0]};
                        2'd1: rdata = {{24{mem[widx][15]}}, mem[widx][15:8]};
                        2'd2: rdata = {{24{mem[widx][23]}}, mem[widx][23:16]};
                        2'd3: rdata = {{24{mem[widx][31]}}, mem[widx][31:24]};
                    endcase
                end
                `F3_LBU: begin
                    case (byte_off)
                        2'd0: rdata = {24'b0, mem[widx][7:0]};
                        2'd1: rdata = {24'b0, mem[widx][15:8]};
                        2'd2: rdata = {24'b0, mem[widx][23:16]};
                        2'd3: rdata = {24'b0, mem[widx][31:24]};
                    endcase
                end
                `F3_LH: begin
                    case (byte_off[1]) // aligned 0 or 2
                        1'b0: rdata = {{16{mem[widx][15]}}, mem[widx][15:0]};
                        1'b1: rdata = {{16{mem[widx][31]}}, mem[widx][31:16]};
                    endcase
                end
                `F3_LHU: begin
                    case (byte_off[1])
                        1'b0: rdata = {16'b0, mem[widx][15:0]};
                        1'b1: rdata = {16'b0, mem[widx][31:16]};
                    endcase
                end
                `F3_LW: begin
                    if (byte_off == 2'b00) rdata = mem[widx];
                    else rdata = 32'b0; // misaligned -> 0
                end
                default: rdata = 32'b0;
            endcase
        end else begin
            rdata = 32'b0;
        end
    end

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write && widx < MEM_WORDS) begin
            case (funct3)
                `F3_SB: begin
                    case (byte_off)
                        2'd0: mem[widx][7:0]   <= wdata[7:0];
                        2'd1: mem[widx][15:8]  <= wdata[7:0];
                        2'd2: mem[widx][23:16] <= wdata[7:0];
                        2'd3: mem[widx][31:24] <= wdata[7:0];
                    endcase
                end
                `F3_SH: begin
                    case (byte_off[1])
                        1'b0: mem[widx][15:0]  <= wdata[15:0];
                        1'b1: mem[widx][31:16] <= wdata[15:0];
                    endcase
                end
                `F3_SW: begin
                    if (byte_off == 2'b00) mem[widx] <= wdata;
                end
                default: ;
            endcase
        end
    end
endmodule
