`include "rv32i_defs.vh"

module control_unit(
    input  [31:0] instr,
    output reg [2:0]  imm_sel,
    output reg [3:0]  alu_op,
    output reg        a_sel_pc,
    output reg        a_sel_zero,
    output reg        b_sel_imm,
    output reg        branch,
    output reg        jal,
    output reg        jalr,
    output reg        mem_read,
    output reg        mem_write,
    output reg [1:0]  wb_sel,   // 00 ALU, 01 MEM, 10 PC+4
    output reg        reg_write
);
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    always @* begin
        // defaults (NOP)
        imm_sel   = `IMM_I;
        alu_op    = `ALU_ADD;
        a_sel_pc  = 1'b0;
        a_sel_zero= 1'b0;
        b_sel_imm = 1'b0;
        branch    = 1'b0;
        jal       = 1'b0;
        jalr      = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        wb_sel    = 2'b00;
        reg_write = 1'b0;

        case (opcode)
            `OPC_LUI: begin
                imm_sel   = `IMM_U;
                a_sel_zero= 1'b1; // 0 + imm
                b_sel_imm = 1'b1;
                alu_op    = `ALU_ADD;
                wb_sel    = 2'b00; // ALU result = imm
                reg_write = 1'b1;
            end
            `OPC_AUIPC: begin
                imm_sel   = `IMM_U;
                a_sel_pc  = 1'b1; // PC + imm
                b_sel_imm = 1'b1;
                alu_op    = `ALU_ADD;
                wb_sel    = 2'b00;
                reg_write = 1'b1;
            end
            `OPC_JAL: begin
                imm_sel   = `IMM_J;
                jal       = 1'b1;
                wb_sel    = 2'b10; // PC+4
                reg_write = 1'b1;
            end
            `OPC_JALR: begin
                imm_sel   = `IMM_I;
                jalr      = 1'b1;
                wb_sel    = 2'b10; // PC+4
                reg_write = 1'b1;
            end
            `OPC_BRANCH: begin
                imm_sel   = `IMM_B;
                branch    = 1'b1;
                // ALU not used for PC calculation; comparator uses rs1/rs2
            end
            `OPC_LOAD: begin
                imm_sel   = `IMM_I;
                a_sel_pc  = 1'b0;
                b_sel_imm = 1'b1; // rs1 + imm
                alu_op    = `ALU_ADD;
                mem_read  = 1'b1;
                wb_sel    = 2'b01; // MEM
                reg_write = 1'b1;
            end
            `OPC_STORE: begin
                imm_sel   = `IMM_S;
                b_sel_imm = 1'b1;
                alu_op    = `ALU_ADD; // addr = rs1 + imm
                mem_write = 1'b1;
            end
            `OPC_OPIMM: begin
                imm_sel   = `IMM_I;
                b_sel_imm = 1'b1;
                reg_write = 1'b1;
                wb_sel    = 2'b00;
                // ALU op by funct3/funct7
                case (funct3)
                    `F3_ADD_SUB: alu_op = `ALU_ADD; // ADDI
                    `F3_SLL:     alu_op = `ALU_SLL; // SLLI
                    `F3_SLT:     alu_op = `ALU_SLT; // SLTI
                    `F3_SLTU:    alu_op = `ALU_SLTU; // SLTIU
                    `F3_XOR:     alu_op = `ALU_XOR; // XORI
                    `F3_SRL_SRA: alu_op = (funct7[5]) ? `ALU_SRA : `ALU_SRL; // SRAI/SRLI
                    `F3_OR:      alu_op = `ALU_OR;  // ORI
                    `F3_AND:     alu_op = `ALU_AND; // ANDI
                    default:     alu_op = `ALU_ADD;
                endcase
            end
            `OPC_OP: begin
                reg_write = 1'b1;
                wb_sel    = 2'b00;
                // Determine ALU op from funct3 and bit30
                case (funct3)
                    `F3_ADD_SUB: alu_op = (funct7[5]) ? `ALU_SUB : `ALU_ADD;
                    `F3_SLL:     alu_op = `ALU_SLL;
                    `F3_SLT:     alu_op = `ALU_SLT;
                    `F3_SLTU:    alu_op = `ALU_SLTU;
                    `F3_XOR:     alu_op = `ALU_XOR;
                    `F3_SRL_SRA: alu_op = (funct7[5]) ? `ALU_SRA : `ALU_SRL;
                    `F3_OR:      alu_op = `ALU_OR;
                    `F3_AND:     alu_op = `ALU_AND;
                    default:     alu_op = `ALU_ADD;
                endcase
            end
            default: begin
                // NOP / SYSTEM not implemented
            end
        endcase
    end
endmodule
