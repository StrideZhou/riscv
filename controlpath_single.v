`include "E:/EDA/RISC/SingleCycle/common_parts/control_constants.v"

module controlpath_single(

    /* instruction decoder */
    input   [6:0]   inst_opcode,
    input   [6:0]   inst_funct7,
    input   [2:0]   inst_funct3,

    /* control signals */
    input           alu_overflow,
    input           alu_rd_equals_zero,
    output  [3:0]   alu_op,         // currently only add
    output  reg     alu_op_a_sel,   // currently no branching, should always be 0
    output  reg     alu_op_b_sel,

    output  reg     pc_wren,
    output  reg     sel_next_pc,

    output  reg     reg_file_wen,

    /* memory interface, for load/store */
    output  reg     mem_rd_en,
    output  reg     mem_wr_en
);

//////////////////////////////////////////////////////////////////
/* Branch judging */
//////////////////////////////////////////////////////////////////
wire take_branch;

assign take_branch =
    (inst_funct3 == `INST3_BEQ) & (!alu_rd_equals_zero) |
    (inst_funct3 == `INST3_BNE) & (alu_rd_equals_zero) |
    (inst_funct3 == `INST3_BLT) & (!alu_rd_equals_zero) |
    (inst_funct3 == `INST3_BGE) & (alu_rd_equals_zero) |
    (inst_funct3 == `INST3_BLTU) & (!alu_rd_equals_zero) |
    (inst_funct3 == `INST3_BGEU) & (alu_rd_equals_zero) ;

//////////////////////////////////////////////////////////////////
/* Next PC */
//////////////////////////////////////////////////////////////////
always @(*) begin
    case (inst_opcode)
        `OPCODE_BRANCH: sel_next_pc = take_branch ? `CTL_PC_PC_IMM : `CTL_PC_PC4;
        default:    sel_next_pc = `CTL_PC_PC4;
    endcase
end

//////////////////////////////////////////////////////////////////
/* ALU operation generator */
//////////////////////////////////////////////////////////////////
reg [1:0] alu_op_raw;

alu_op_gen alu_op_gen(
    .alu_op_raw     (alu_op_raw),
    .inst_funct3    (inst_funct3),
    .inst_funct7    (inst_funct7),    
    .alu_op         (alu_op)
);

//////////////////////////////////////////////////////////////////
/* Control path */
//////////////////////////////////////////////////////////////////
always @(*) begin
    pc_wren         = 1'b0;
    reg_file_wen    = 1'b0;

    alu_op_raw      = 2'bx;
    alu_op_a_sel    = 1'bx;
    alu_op_b_sel    = 1'bx;

    mem_rd_en       = 1'b0;
    mem_wr_en       = 1'b0;

    case (inst_opcode)
        // Load
        `OPCODE_LOAD: begin
            reg_file_wen    = 1'b1;
            alu_op_a_sel    = `CTL_ALU_A_RS1;
            alu_op_b_sel    = `CTL_ALU_B_IMM;
            alu_op_raw      = `CTL_ALU_OP_ADD;
            mem_rd_en       = 1'b1;
        end 

        // Store
        `OPCODE_STORE: begin
            alu_op_a_sel    = `CTL_ALU_A_RS1;
            alu_op_b_sel    = `CTL_ALU_B_IMM;
            alu_op_raw      = `CTL_ALU_OP_ADD;
            mem_wr_en       = 1'b1;
        end 

        // Add and add-like ops
        `OPCODE_OP: begin
            reg_file_wen    = 1'b1;
            alu_op_a_sel    = `CTL_ALU_A_RS1;
            alu_op_b_sel    = `CTL_ALU_B_RS2;
            alu_op_raw      = `CTL_ALU_OP_OP;
        end

        // Addi and addi-like ops
        `OPCODE_OP_IMM: begin
            reg_file_wen    = 1'b1;
            alu_op_a_sel    = `CTL_ALU_A_RS1;
            alu_op_b_sel    = `CTL_ALU_B_IMM;
            alu_op_raw      = `CTL_ALU_OP_OP_IMM;
        end

        // Branch
        `OPCODE_BRANCH: begin
            alu_op_a_sel    = `CTL_ALU_A_RS1;
            alu_op_b_sel    = `CTL_ALU_B_RS2;
            alu_op_raw      = `CTL_ALU_OP_BRANCH;
        end

        default: begin
            pc_wren         = 1'bx;
            reg_file_wen    = 1'bx;
            mem_wr_en       = 1'bx;
            mem_rd_en       = 1'bx;            
        end
    endcase
   end
endmodule