`include "alu.vh"
`include "opcode.vh"
// ALU raw opcodes
`define CTL_ALU_OP_ADD      2'b00
`define CTL_ALU_OP_BRANCH   2'b01
`define CTL_ALU_OP_OP       2'b10
`define CTL_ALU_OP_OP_IMM   2'b11

//*model which do all math work
module alu_mod (
    input        [31:0]  inst,

    input signed [31:0]  rs1_data,
    input signed [31:0]  rs2_data,
    output reg   [31:0]  rd_data, //contain all adress & all result to dmem

    input      [31:0]  pc,
    output reg         br_en
//*   output reg [31:0]  br_addr  //now contain in rd_data
);
//inst_decoder
    wire       [6:0]  inst_opcode;
    wire       [2:0]  inst_funct3;
    wire       [6:0]  inst_funct7;

    wire signed [31:0] imm;

inst_decoder alu_inst_decoder(
    .inst        ( inst        ),
    .inst_opcode ( inst_opcode ),
    .inst_funct3 ( inst_funct3 ),
    .inst_funct7 ( inst_funct7 ),
    .imm         ( imm         ),
    .imm_valid   ( imm_valid   )
);
//alu
reg    [ 3:0]  alu_op;
reg    [31:0]  alu_rs1;
reg    [31:0]  alu_rs2;
wire   [31:0]  alu_rd;
wire           alu_of;

alu u_alu(
    .op        ( alu_op  ),
    .rs1       ( alu_rs1 ),
    .rs2       ( alu_rs2 ),
    .rd        ( alu_rd  ),
    .overflow  ( alu_of  )
);


always @(*) begin
    alu_op = `ALU_ADD; //default op & others
    alu_rs1 = rs1_data;
    alu_rs2 = imm_valid ? imm : rs2_data;
    rd_data = alu_rd;
    br_en   = 1'b0;
    // br_addr = 32'd0;
    case(inst_opcode)
        `OPCODE_ALU:begin
            alu_op = {1'b0, inst_funct3}; //? magic refer alu.vh
            case(inst_funct3)
                `FUNC3_ADDx:begin
                    case (inst_funct7)
                        `FUNC7_SUB:  alu_op = `ALU_SUB;
                        `FUNC7_MUL:  alu_op = `ALU_MUL;
                    endcase
                end
                `FUNC3_SRx: begin
                    case (inst_funct7)
                        `FUNC7_SxA: alu_op = `ALU_SRA;
                    endcase
                end 
            endcase
        end

        `OPCODE_ALU_IMM:begin
            alu_op = {1'b0, inst_funct3}; //? magic refer alu.vh
            // alu_rs2 = imm;
            case(inst_funct3)
                // `FUNC3_SLTU: alu_rs2 = imm;//! unsigned immediate 
                `FUNC3_SRx: begin
                    // alu_rs2 = imm;         //! unsigned immediate 
                    case (inst_funct7)
                        `FUNC7_SxA: alu_op = `ALU_SRA;
                    endcase
                end 
            endcase
        end

        `OPCODE_LOAD,`OPCODE_STORE:begin //caculate dmem adress
            // alu_rs2 = imm;               //note:2021年6月11日06点28分
        end

        `OPCODE_BRANCH:begin
            alu_op = `ALU_SEQ;  //use alu caculate wiether equ or not
            alu_rs2 = rs2_data; //caculate rs1 rs2
            rd_data = imm + $signed({1'b0, pc});//caculate branch adress
            br_en   = alu_rd[0]; //branch if condition true 
            case(inst_funct3)
                `FUNC3_BEQ:  ;
                `FUNC3_BNE:  br_en   = ~alu_rd[0];
                `FUNC3_BLT:  alu_op  = `ALU_SLT;
                `FUNC3_BLTU: alu_op  = `ALU_SLTU;
                `FUNC3_BGE:  br_en   = alu_rd[0] | (rs1_data > rs2_data);
                `FUNC3_BGEU: br_en   = alu_rd[0] | ($unsigned(rs1_data) > $unsigned(rs2_data));
            endcase
        end

        `OPCODE_U:begin
            rd_data = imm;
        end
    endcase

end

endmodule
