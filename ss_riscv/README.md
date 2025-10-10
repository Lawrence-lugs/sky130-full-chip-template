# Simple Single-Cycle RV32I CPU

Textbook single-cycle RV32I processor.

## Features
- RV32I base integer subset (common instructions):
  - R-type: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
  - I-type: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, JALR, loads (LB/LH/LW/LBU/LHU)
  - S-type: stores (SB/SH/SW)
  - B-type: branches (BEQ/BNE/BLT/BGE/BLTU/BGEU)
  - U-type: LUI, AUIPC
  - J-type: JAL
- Core exposes simple memory interfaces, no inferred memories inside core
- x0 hardwired to zero; regfile is resettable (no initial blocks)

## Layout
- `src/rv32i_single_cycle.v` — synthesizable core
- `src/alu.v, regfile.v, imm_gen.v, branch_comp.v, control_unit.v` — core units
- `src/sim_top.v` — simulation top wiring core to ROM/RAM
- `src/instr_mem.v` — `sim_instr_rom` (simulation only)
- `src/data_mem.v` — `sim_data_ram` (simulation only)
- `src/programs/add_store.hex` — sample program
- `src/tb/tb_single_cycle.v` — minimal testbench

## Simulation

```bash
cd ss_riscv/src
iverilog -g2012 -o sim_out \
  rv32i_defs.vh \
  alu.v regfile.v imm_gen.v branch_comp.v control_unit.v \
  rv32i_single_cycle.v instr_mem.v data_mem.v sim_top.v tb/tb_single_cycle.v && \
./sim_out
```

Expected: the sample program stores 12 to DMEM[0], and the testbench prints that value.