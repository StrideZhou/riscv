// Instruction opcodes
`define OPCODE_ALU      7'b0110011
`define OPCODE_ALU_IMM  7'b0010011
`define OPCODE_LOAD     7'b0000011
`define OPCODE_STORE    7'b0100011
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_U        7'b0110111

// "funct3" field for branches
`define FUNC3_BEQ    3'b000
`define FUNC3_BNE    3'b001
`define FUNC3_BLT    3'b100
`define FUNC3_BGE    3'b101
`define FUNC3_BLTU   3'b110
`define FUNC3_BGEU   3'b111

// "funct3" field for alu ops
`define FUNC3_ADDx     3'b000 //add,sub,mul
`define FUNC3_SLL      3'b001 //sll/i
`define FUNC3_SLT      3'b010
`define FUNC3_SLTU     3'b011
`define FUNC3_XOR      3'b100
`define FUNC3_SRx      3'b101 //srl/i,sra/i
`define FUNC3_OR       3'b110
`define FUNC3_AND      3'b111

// "funct7" field for alu ops
`define FUNC7_NONE     7'b0000000
`define FUNC7_MUL      7'b0000001
`define FUNC7_SUB      7'b0100000
`define FUNC7_SxA      7'b0100000

// "funct3" field for load store
`define FUNC3_SB     3'b000
`define FUNC3_SH     3'b001
`define FUNC3_SW     3'b010

`define FUNC3_LB     3'b000
`define FUNC3_LH     3'b001
`define FUNC3_LW     3'b010
`define FUNC3_LBU    3'b100
`define FUNC3_LHU    3'b101
`define FUNC3_LWU    3'b110
