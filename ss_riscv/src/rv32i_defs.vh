`ifndef RV32I_DEFS_VH
`define RV32I_DEFS_VH

// Opcodes
`define OPC_LUI       7'b0110111
`define OPC_AUIPC     7'b0010111
`define OPC_JAL       7'b1101111
`define OPC_JALR      7'b1100111
`define OPC_BRANCH    7'b1100011
`define OPC_LOAD      7'b0000011
`define OPC_STORE     7'b0100011
`define OPC_OPIMM     7'b0010011
`define OPC_OP        7'b0110011
`define OPC_MISC_MEM  7'b0001111
`define OPC_SYSTEM    7'b1110011

// funct3 for ALU ops
`define F3_ADD_SUB  3'b000
`define F3_SLL      3'b001
`define F3_SLT      3'b010
`define F3_SLTU     3'b011
`define F3_XOR      3'b100
`define F3_SRL_SRA  3'b101
`define F3_OR       3'b110
`define F3_AND      3'b111

// Branch funct3
`define F3_BEQ  3'b000
`define F3_BNE  3'b001
`define F3_BLT  3'b100
`define F3_BGE  3'b101
`define F3_BLTU 3'b110
`define F3_BGEU 3'b111

// Load funct3
`define F3_LB   3'b000
`define F3_LH   3'b001
`define F3_LW   3'b010
`define F3_LBU  3'b100
`define F3_LHU  3'b101

// Store funct3
`define F3_SB   3'b000
`define F3_SH   3'b001
`define F3_SW   3'b010

// ALU operation encoding
`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_SLL  4'b0010
`define ALU_SLT  4'b0011
`define ALU_SLTU 4'b0100
`define ALU_XOR  4'b0101
`define ALU_SRL  4'b0110
`define ALU_SRA  4'b0111
`define ALU_OR   4'b1000
`define ALU_AND  4'b1001

// Immediate select encoding
`define IMM_I 3'b000
`define IMM_S 3'b001
`define IMM_B 3'b010
`define IMM_U 3'b011
`define IMM_J 3'b100

`endif // RV32I_DEFS_VH
