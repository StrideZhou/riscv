`include "opcode.vh"

`define CTL_PC_PC4      1'b0
`define CTL_PC_PC_IMM   1'b1

// ALU operand source selects
`define CTL_ALU_A_RS1   1'b0
`define CTL_ALU_A_PC    1'b1

`define CTL_ALU_B_RS2   1'b0
`define CTL_ALU_B_IMM   1'b1

module datapath_single(

    /* clk and rst */
    input   clk,
    input   rst,

    /* instruction decoder */
    input   [31:0]  inst,
    output  [6:0]   inst_opcode, // 7-bits opcode
    output  [6:0]   inst_funct7,
    output  [2:0]   inst_funct3,

    /* memory interface, for load/store */
    input   [31:0]  mem_rddata,
    output  [31:0]  mem_addr,
    output  [31:0]  mem_wrdata,
    
    /* control signals */
    input   pc_wren,
    input   sel_next_pc,
    output  [31:0]  pc,

    input   reg_file_wen,

    input   [3:0] alu_op,   // ? currently only add?
    input   alu_op_a_sel,   // ! currently no branching, should always be 0
    input   alu_op_b_sel,   
    output  alu_rd_equals_zero,
    output  alu_overflow

);
wire    [31:0]  rd_data;
wire    [31:0]  rs1_data;
wire    [31:0]  rs2_data;
wire    [4:0]   inst_waddr;
wire    [4:0]   inst_raddr1;
wire    [4:0]   inst_raddr2;
wire    [31:0]  inst_wdata;

wire    [31:0]  alu_op_a;
wire    [31:0]  alu_op_b;
wire    [31:0]  alu_out;

wire    [31:0]  immediate;

wire nrst;
assign nrst = ~rst;

/* RegFile: Register File */
// mux4 #(.WIDTH(32)) mux_regfile_wdata (  //write-back path
//     .in0 (alu_out),
//     .in1 (32'b0),
//     .in2 (32'b0),
//     .in3 (32'b0),
//     .sel (2'b00),
//     .out (inst_wdata)
// );
assign inst_wdata = alu_out;

inst_decoder inst_decoder(
    .inst        ( inst        ),
    .inst_opcode ( inst_opcode ),
    .inst_funct3 ( inst_funct3 ),
    .inst_funct7 ( inst_funct7 ),
    .inst_rd     ( inst_rd     ),
    .inst_rs1    ( inst_rs1    ),
    .inst_rs2    ( inst_rs2    ),
    .imm         ( imm         ),
    .imm_u       ( imm_u       )
);


regFile reg_file(
    .clk            (clk),
    .nrst           (nrst),
    .radd1          (inst_raddr1),
    .radd2          (inst_raddr2),
    .wen            (reg_file_wen),    
    .wadd           (inst_waddr),
    .wdata          (inst_wdata),
    .rs1            (rs1_data),
    .rs2            (rs2_data)
);

/* ALU */

assign  alu_rd_equals_zero = (alu_out == 32'b0);

mux2 #(.WIDTH(32)) mux_alu_op_a (
    .in0 (rs1_data),
    .in1 (pc),
    .sel (alu_op_a_sel),
    .out (alu_op_a)
);

mux2 #(.WIDTH(32)) mux_alu_op_b (
    .in0 (rs2_data),
    .in1 (immediate),
    .sel (alu_op_b_sel),
    .out (alu_op_b)
);


alu alu(
    .op         (alu_op),    //currently only add?
    .rs1        (alu_op_a),
    .rs2        (alu_op_b),
    .rd         (alu_out),
    .overflow   (alu_overflow)
);

/* PC: Program Controller */
reg [31:0]  pc_next;
reg [31:0]  pc_plus_4;
reg [31:0]  pc_plus_imm;

syn_reg #(.WIDTH(32)) pc_reg ( // PC register
    .clk    (clk),
    .rst    (rst),
    .wr_en  (pc_wren),
    .next   (pc_next),
    .value  (pc)
);

assign pc_plus_4 = pc + 4;
assign pc_next = (sel_next_pc == `CTL_PC_PC4) ? pc_plus_4 : pc_plus_imm;

/* Memory interface */
assign mem_waddr = alu_out;
assign mem_wrdata = rs2_data;    //for store




// TODO ---------------------------------------
// TODO ---------------------------------------
// TODO ---------------------------------------
// TODO ---------------------------------------

    /* memory interface, for load/store */
   reg     mem_rd_en;
   reg     mem_wr_en;


/* Branch judging */
wire take_branch;
assign take_branch =
    (inst_funct3 == `FUNC3_BEQ) & (!alu_rd_equals_zero) |
    (inst_funct3 == `FUNC3_BNE) & (alu_rd_equals_zero) |
    (inst_funct3 == `FUNC3_BLT) & (!alu_rd_equals_zero) |
    (inst_funct3 == `FUNC3_BGE) & (alu_rd_equals_zero) |
    (inst_funct3 == `FUNC3_BLTU) & (!alu_rd_equals_zero) |
    (inst_funct3 == `FUNC3_BGEU) & (alu_rd_equals_zero) ;

/* Next PC */
always @(*) begin
    case (inst_opcode)
        `OPCODE_BRANCH: sel_next_pc = take_branch ? `CTL_PC_PC_IMM : `CTL_PC_PC4;
        default:    sel_next_pc = `CTL_PC_PC4;
    endcase
end

/* ALU operation generator */
reg [1:0] alu_op_raw;

alu_op_gen alu_op_gen(
    .alu_op_raw     (alu_op_raw),
    .inst_funct3    (inst_funct3),
    .inst_funct7    (inst_funct7),    
    .alu_op         (alu_op)
);

/* Control path */
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

/****alu_op_mod

reg [3:0] alu_branches;
reg [3:0] alu_ops;
reg [3:0] alu_imm_ops;

// always @(*) begin
//     case (alu_op_raw)
//         `CTL_ALU_OP_ADD:    alu_op = `ALU_ADD;
//         `CTL_ALU_OP_BRANCH: alu_op = alu_branches;
//         `CTL_ALU_OP_OP:     alu_op = alu_ops;
//         `CTL_ALU_OP_OP_IMM: alu_op = alu_imm_ops;
//         default: alu_op = 4'bx;
//     endcase 
// end

reg [3:0] alu_ops1;
reg [3:0] alu_ops2;

assign alu_ops1 = 
    {4{inst_funct3 == `FUNC3_ADDx}}   & (`ALU_SUB) |
    {4{inst_funct3 == `FUNC3_SRx}}    & (`ALU_SRA);
assign alu_ops2 =
    {4{inst_funct3 == `FUNC3_ADDx}}   & (`ALU_ADD) |
    {4{inst_funct3 == `FUNC3_SLL}}    & (`ALU_SLL) |
    {4{inst_funct3 == `FUNC3_SLT}}    & (`ALU_SLT) |
    {4{inst_funct3 == `FUNC3_SLTU}}   & (`ALU_SLTU)|
    {4{inst_funct3 == `FUNC3_XOR}}    & (`ALU_XOR) |
    {4{inst_funct3 == `FUNC3_SRx}}    & (`ALU_SRL) |
    {4{inst_funct3 == `FUNC3_OR}}     & (`ALU_OR)  |
    {4{inst_funct3 == `FUNC3_AND}}    & (`ALU_AND) ;

// alu immediate ops
always @(*) begin
    if(inst_funct7[5] && inst_funct3[1:0] == 2'b01) begin //ALU-IMM-SRA
        alu_imm_ops = alu_ops1;      
    end
    else begin
        alu_ops = alu_ops2;
    end
end

// alu ops
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

// branches
assign alu_branches = 
    {4{inst_funct3 == `FUNC3_BEQ}}  & (`ALU_SEQ) | 
    {4{inst_funct3 == `FUNC3_BNE}}  & (`ALU_SEQ) | 
    {4{inst_funct3 == `FUNC3_BLT}}  & (`ALU_SLT) |
    {4{inst_funct3 == `FUNC3_BGE}}  & (`ALU_SLT) |
    {4{inst_funct3 == `FUNC3_BLTU}} & (`ALU_SLTU)|
    {4{inst_funct3 == `FUNC3_BGEU}} & (`ALU_SLTU);
*/


endmodule