`include "rv32i_defs.vh"

module rv32i_alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0]  alu_op,
    output reg [31:0] y
);
    wire signed [31:0] as = a;
    wire signed [31:0] bs = b;
    always @* begin
        case (alu_op)
            `ALU_ADD:  y = a + b;
            `ALU_SUB:  y = a - b;
            `ALU_SLL:  y = a << b[4:0];
            `ALU_SLT:  y = (as < bs) ? 32'd1 : 32'd0;
            `ALU_SLTU: y = (a < b)  ? 32'd1 : 32'd0;
            `ALU_XOR:  y = a ^ b;
            `ALU_SRL:  y = a >> b[4:0];
            `ALU_SRA:  y = as >>> b[4:0];
            `ALU_OR:   y = a | b;
            `ALU_AND:  y = a & b;
            default:   y = 32'b0;
        endcase
    end
endmodule
