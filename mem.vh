//read operation: [2:0] == "funct3"
`define LoadByte      3'b100
`define LoadHalfWord  3'b101
`define LoadWord      3'b110
//write operation:[3:0] == "funct3"
`define StoreByte     3'b000
`define StoreHalfWord 3'b001
`define StoreWord     3'b010

`define MemDoNothing  3'b111

//! wen = [2]
