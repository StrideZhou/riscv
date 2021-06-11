//* [2:0] equ "funct3"
`define ALU_ADD     4'b0_000
`define ALU_SUB     4'b1_000

`define ALU_XOR     4'b0_100
`define ALU_OR      4'b0_110
`define ALU_AND     4'b0_111


`define ALU_SLL     4'b0_001
`define ALU_SRL     4'b0_101
`define ALU_SRA     4'b1_101

`define ALU_SLT     4'b0_010
`define ALU_SLTU    4'b0_011

//* below not equ "funct3"
`define ALU_SEQ     4'b1_100

`define ALU_MUL     4'b1_111
