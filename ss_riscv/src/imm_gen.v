`include "rv32i_defs.vh"

module imm_gen(
    input  [31:0] instr,
    input  [2:0]  imm_sel,
    output reg [31:0] imm
);
    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
    wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    wire [31:0] imm_b = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    wire [31:0] imm_u = {instr[31:12], 12'b0};
    wire [31:0] imm_j = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

    always @* begin
        case (imm_sel)
            `IMM_I: imm = imm_i;
            `IMM_S: imm = imm_s;
            `IMM_B: imm = imm_b;
            `IMM_U: imm = imm_u;
            `IMM_J: imm = imm_j;
            default: imm = 32'b0;
        endcase
    end
endmodule
