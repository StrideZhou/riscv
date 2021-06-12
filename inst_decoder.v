`include "opcode.vh"
`include "mem.vh"
module inst_decoder(
    input   [31:0]  inst,

    output  [6:0]  inst_opcode,
    output  [2:0]  inst_funct3,
    output  [6:0]  inst_funct7,
    output  [4:0]  inst_rd,
    output  [4:0]  inst_rs1,
    output  [4:0]  inst_rs2,
    output reg     rd_wen, //rd exist (write enable)

    output reg signed [31:0] imm,   //! maybe signed immediate 
 // output reg        [31:0] imm_u, //unsign immediate
    output reg               imm_valid,

    output reg        [2:0]  mem_opcode
);

    assign inst_opcode = inst[ 6: 0];
    assign inst_funct3 = inst[14:12];
    assign inst_funct7 = inst[31:25];
    assign inst_rd     = inst[11: 7];
    assign inst_rs1    = inst[19:15];
    assign inst_rs2    = inst[24:20];

    always@(*) begin
        imm   = 32'd0;
        // imm_u = 32'd0;
        imm_valid = 1'b1;
        rd_wen = 1'b1;
        mem_opcode = `MemDoNothing;
        case (inst_opcode)
            `OPCODE_STORE:begin  //  S-type immediate
                imm   = { {21{inst[31]}}, inst[30:25], inst[11:7] };
                ////imm_u = { 20'd0, inst[31:25], inst[11:7] };
                rd_wen = 1'b0;
                mem_opcode = { 1'b0, inst_funct3[1:0]}; //? magic refer to mem.vh
            end
            `OPCODE_LOAD:begin   //  I-type immediate (partial)  
                imm   = { {21{inst[31]}}, inst[30:20] };
                ////imm_u = { 20'd0, inst[31:20] };
                mem_opcode = { 1'b1, inst_funct3[1:0]}; //? magic refer to mem.vh
            end
            `OPCODE_BRANCH:begin //  B-type immediate
                imm   = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
                ////imm_u = { 19'd0, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };
                rd_wen = 1'b0;
            end
            `OPCODE_U:begin      //  U-type immediate
                imm   = { inst[31:12], 10'b0};//! unsigned immediate 
            end
            `OPCODE_ALU_IMM:begin
                imm   = { {21{inst[31]}}, inst[30:20] };
                case (inst_funct3)
                    `FUNC3_SLL,`FUNC3_SRx: imm = { 27'd0, inst[24:20] };//! unsigned immediate
                    `FUNC3_SLTU:           imm = { 20'b0, inst[31:20] };//! unsigned immediate
                endcase
            end
            `OPCODE_ALU: imm_valid = 1'b0;
        endcase
    end

endmodule