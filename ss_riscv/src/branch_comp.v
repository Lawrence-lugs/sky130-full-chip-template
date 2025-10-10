`include "rv32i_defs.vh"

module branch_comp(
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0]  funct3,
    output reg    take
);
    wire signed [31:0] as = a;
    wire signed [31:0] bs = b;
    always @* begin
        case (funct3)
            `F3_BEQ:  take = (a == b);
            `F3_BNE:  take = (a != b);
            `F3_BLT:  take = (as < bs);
            `F3_BGE:  take = (as >= bs);
            `F3_BLTU: take = (a < b);
            `F3_BGEU: take = (a >= b);
            default:  take = 1'b0;
        endcase
    end
endmodule
