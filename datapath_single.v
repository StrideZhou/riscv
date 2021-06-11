`include "E:/EDA/RISC/SingleCycle/common_parts/control_constants.v"

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

    input   [3:0] alu_op,   // currently only add?
    input   alu_op_a_sel,   // currently no branching, should always be 0
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

//////////////////////////////////////////////////////////////////
/* RegFile: Register File */
//////////////////////////////////////////////////////////////////
mux4 #(.WIDTH(32)) mux_regfile_wdata (  //write-back path
    .in0 (alu_out),
    .in1 (32'b0),
    .in2 (32'b0),
    .in3 (32'b0),
    .sel (2'b00),
    .out (inst_wdata)
);

inst_decoder inst_decoder(

    .inst           (inst),
    .inst_opcode    (inst_opcode),
    .inst_funct7    (inst_funct7),
    .inst_funct3    (inst_funct3),
    .inst_rd        (inst_waddr),
    .inst_rs1       (inst_raddr1),
    .inst_rs2       (inst_raddr2)
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

//////////////////////////////////////////////////////////////////
/* ALU */
//////////////////////////////////////////////////////////////////

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

immediate_gen immediate_gen (
    .inst (inst),
    .immediate (immediate)
);

alu alu(
    .op         (alu_op),    //currently only add?
    .rs1        (alu_op_a),
    .rs2        (alu_op_b),
    .rd         (alu_out),
    .overflow   (alu_overflow)
);

//////////////////////////////////////////////////////////////////
/* PC: Program Controller */
//////////////////////////////////////////////////////////////////
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

adder #(.WIDTH(32)) adder_pc_plus4 (    // Adder: PC + 4
    .op_a   (32'h4),
    .op_b   (pc),
    .result (pc_plus_4)
);

assign pc_next = (sel_next_pc == `CTL_PC_PC4) ? pc_plus_4 : pc_plus_imm;

//////////////////////////////////////////////////////////////////
/* Memory interface */
//////////////////////////////////////////////////////////////////
assign mem_waddr = alu_out;
assign mem_wrdata = rs2_data;    //for store

endmodule