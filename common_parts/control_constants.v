/////////////////////////////////////////////////
// Instruction opcodes
/////////////////////////////////////////////////
`define OPCODE_OP       7'b0110011
`define OPCODE_OP_IMM   7'b0010011
`define OPCODE_LOAD     7'b0000011
`define OPCODE_STORE    7'b0100011
`define OPCODE_BRANCH   7'b1100011

/////////////////////////////////////////////////
// ALU operations
/////////////////////////////////////////////////
`define ALU_SLL     4'd1
`define ALU_SRL     4'd2
`define ALU_SRA     4'd3

`define ALU_ADD     4'd4 
`define ALU_SUB     4'd5

`define ALU_LUI     4'd6    //TODO: implemented in ALU?
`define ALU_SLT     4'd7
`define ALU_SLTU    4'd8
`define ALU_SEQ     4'd13   

`define ALU_XOR     4'd9
`define ALU_OR      4'd10
`define ALU_AND     4'd11
`define ALU_MUL     4'd12

/////////////////////////////////////////////////
// "funct3" field for branches
/////////////////////////////////////////////////
`define INST3_BEQ    3'b000
`define INST3_BNE    3'b001
`define INST3_BLT    3'b100
`define INST3_BGE    3'b101
`define INST3_BLTU   3'b110
`define INST3_BGEU   3'b111

/////////////////////////////////////////////////
// "funct3" field for alu ops
/////////////////////////////////////////////////
`define INST3_ALU_ADD_SUB  3'b000
`define INST3_ALU_SLL      3'b001
`define INST3_ALU_SLT      3'b010
`define INST3_ALU_SLTU     3'b011
`define INST3_ALU_XOR      3'b100
`define INST3_ALU_SRL_SRA  3'b101
`define INST3_ALU_OR       3'b110
`define INST3_ALU_AND      3'b111

/////////////////////////////////////////////////
// ALU operand source selects
/////////////////////////////////////////////////
`define CTL_ALU_A_RS1   1'b0
`define CTL_ALU_A_PC    1'b1

`define CTL_ALU_B_RS2   1'b0
`define CTL_ALU_B_IMM   1'b1

/////////////////////////////////////////////////
// ALU raw opcodes
/////////////////////////////////////////////////
`define CTL_ALU_OP_ADD      2'b00
`define CTL_ALU_OP_BRANCH   2'b01
`define CTL_ALU_OP_OP       2'b10
`define CTL_ALU_OP_OP_IMM   2'b11

/////////////////////////////////////////////////
// PC source
/////////////////////////////////////////////////
`define CTL_PC_PC4      1'b0
`define CTL_PC_PC_IMM   1'b1