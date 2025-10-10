`include "rv32i_defs.vh"

// Synthesizable single-cycle RV32I core with external instruction and data memory interfaces.
module rv32i_single_cycle(
    input         clk,
    input         reset,

    // Instruction fetch interface (combinational read)
    output [31:0] imem_addr,
    input  [31:0] imem_rdata,

    // Data memory interface (combinational read, sync write)
    output        dmem_read,
    output        dmem_write,
    output [2:0]  dmem_funct3,
    output [31:0] dmem_addr,
    output [31:0] dmem_wdata,
    input  [31:0] dmem_rdata
);
    // Program counter
    reg [31:0] pc;
    wire [31:0] pc4 = pc + 32'd4;

    // Fetch
    assign imem_addr = pc;
    wire [31:0] instr = imem_rdata;

    // Decode fields
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];

    // Control
    wire [2:0] imm_sel;
    wire [3:0] alu_op;
    wire       a_sel_pc, a_sel_zero, b_sel_imm;
    wire       branch, jal, jalr;
    wire       mem_read, mem_write;
    wire [1:0] wb_sel;
    wire       reg_write;

    control_unit ctrl(
        .instr(instr),
        .imm_sel(imm_sel),
        .alu_op(alu_op),
        .a_sel_pc(a_sel_pc),
        .a_sel_zero(a_sel_zero),
        .b_sel_imm(b_sel_imm),
        .branch(branch),
        .jal(jal),
        .jalr(jalr),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .wb_sel(wb_sel),
        .reg_write(reg_write)
    );

    // Register file
    wire [31:0] rs1_val, rs2_val;
    wire [31:0] wb_data;
    regfile rf(
        .clk(clk),
        .reset(reset),
        .we(reg_write),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wd(wb_data),
        .rd1(rs1_val), .rd2(rs2_val)
    );

    // Immediates
    wire [31:0] imm;
    imm_gen ig(
        .instr(instr),
        .imm_sel(imm_sel),
        .imm(imm)
    );

    // ALU
    wire [31:0] alu_a = a_sel_zero ? 32'b0 : (a_sel_pc ? pc : rs1_val);
    wire [31:0] alu_b = b_sel_imm ? imm : rs2_val;
    wire [31:0] alu_y;
    rv32i_alu alu(
        .a(alu_a), .b(alu_b), .alu_op(alu_op), .y(alu_y)
    );

    // Data memory wires
    assign dmem_read  = mem_read;
    assign dmem_write = mem_write;
    assign dmem_funct3= funct3;
    assign dmem_addr  = alu_y;
    assign dmem_wdata = rs2_val;
    wire [31:0] load_data = dmem_rdata;

    // Branch compare
    wire br_take;
    branch_comp bc(
        .a(rs1_val), .b(rs2_val), .funct3(funct3), .take(br_take)
    );

    // Next PC logic
    wire [31:0] jalr_target = (rs1_val + imm) & ~32'd1;
    wire [31:0] br_target   = pc + imm;
    wire [31:0] jal_target  = pc + imm;

    wire take_branch = branch & br_take;

    wire [31:0] pc_next = jal  ? jal_target  :
                          jalr ? jalr_target :
                          take_branch ? br_target :
                          pc4;

    // Writeback mux
    assign wb_data = (wb_sel == 2'b00) ? alu_y :
                     (wb_sel == 2'b01) ? load_data :
                     (wb_sel == 2'b10) ? pc4 : 32'b0;

    // PC register
    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 32'b0;
        else       pc <= pc_next;
    end
endmodule
