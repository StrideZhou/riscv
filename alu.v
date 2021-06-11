`include "alu.vh"
module alu(
    input           [3:0]   op,
    input   signed  [31:0]  rs1,
    input   signed  [31:0]  rs2,
    output  reg     [31:0]  rd,
    output  reg             overflow
);

always @(*) begin
    case (op)
        `ALU_SLL:   rd = rs1 << $unsigned(rs2);
        `ALU_SRL:   rd = rs1 >> $unsigned(rs2);
        `ALU_SRA:   rd = rs1 >>> $unsigned(rs2);
        `ALU_ADD:   {overflow,rd} = rs1 + rs2;
        `ALU_SUB:   {overflow,rd} = rs1 - rs2;
        `ALU_SLT:   rd = {31'b0, rs1 < rs2};
        `ALU_SLTU:  rd = {31'b0,  $unsigned(rs1) < $unsigned(rs2)};
        `ALU_SEQ:   rd = {31'b0, rs1 == rs2};
        `ALU_XOR:   rd = rs1 ^ rs2;
        `ALU_OR:    rd = rs1 | rs2;
        `ALU_AND:   rd = rs1 & rs2;
        `ALU_MUL:   rd = rs1 * rs2;

        default:    rd = 32'hxxxx_xxxx;
    endcase
end

endmodule

