`include "control_constants.v"

module alu_op_gen (
    input       [1:0]   alu_op_raw,
    input       [6:0]   inst_funct7,
    input       [2:0]   inst_funct3,

    output  reg [3:0]   alu_op
);

reg [3:0] alu_branches;
reg [3:0] alu_ops;
reg [3:0] alu_imm_ops;

always @(*) begin
    case (alu_op_raw)
        `CTL_ALU_OP_ADD:    alu_op = `ALU_ADD;
        `CTL_ALU_OP_BRANCH: alu_op = alu_branches;
        `CTL_ALU_OP_OP:     alu_op = alu_ops;
        `CTL_ALU_OP_OP_IMM: alu_op = alu_imm_ops;
        default: alu_op = 4'bx;
    endcase 
end

reg [3:0] alu_ops1;
reg [3:0] alu_ops2;

assign alu_ops1 = 
    {4{inst_funct3 == `INST3_ALU_ADD_SUB}}  & (`ALU_SUB) |
    {4{inst_funct3 == `INST3_ALU_SRL_SRA}}  & (`ALU_SRA);

assign alu_ops2 = 
    {4{inst_funct3 == `INST3_ALU_ADD_SUB}}  & (`ALU_ADD) |
    {4{inst_funct3 == `INST3_ALU_SLL}}      & (`ALU_SLL) |
    {4{inst_funct3 == `INST3_ALU_SLT}}      & (`ALU_SLT) |
    {4{inst_funct3 == `INST3_ALU_SLTU}}     & (`ALU_SLTU) |
    {4{inst_funct3 == `INST3_ALU_XOR}}      & (`ALU_XOR) |
    {4{inst_funct3 == `INST3_ALU_SRL_SRA}}  & (`ALU_SRL) |
    {4{inst_funct3 == `INST3_ALU_OR}}       & (`ALU_OR) |
    {4{inst_funct3 == `INST3_ALU_AND}}      & (`ALU_AND) ;

///////////////////////////////////////////////////////////////////
// alu immediate ops
///////////////////////////////////////////////////////////////////
always @(*) begin
    if(inst_funct7[5] && inst_funct3[1:0] == 2'b01) begin //ALU-IMM-SRA
        alu_imm_ops = alu_ops1;      
    end
    else begin
        alu_ops = alu_ops2;
    end
end

///////////////////////////////////////////////////////////////////
// alu ops
///////////////////////////////////////////////////////////////////
always @(*) begin
    if(inst_funct7[0]) begin    //ALU-MUL
        alu_imm_ops = `ALU_MUL;
    end 
    else if(inst_funct7[5]) begin //ALU-SUB, SRA
        alu_ops = alu_ops1;      
    end
    else begin
        alu_ops = alu_ops2;
    end
end

///////////////////////////////////////////////////////////////////
// branches
///////////////////////////////////////////////////////////////////
assign alu_branches = 
    {4{inst_funct3 == `INST3_BEQ}}  & (`ALU_SEQ) | 
    {4{inst_funct3 == `INST3_BNE}}  & (`ALU_SEQ) | 
    {4{inst_funct3 == `INST3_BLT}}  & (`ALU_SLT) |
    {4{inst_funct3 == `INST3_BGE}}  & (`ALU_SLT) |
    {4{inst_funct3 == `INST3_BLTU}} & (`ALU_SLTU) |
    {4{inst_funct3 == `INST3_BGEU}} & (`ALU_SLTU);

endmodule