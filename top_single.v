module core_single (
    
    /* clk and rst */
    input   clk,
    input   rst,

    /* 32-bits instruction in */
    input   [31:0]  inst,          

    /* Memory in & outs*/
    /*
    input   [31:0]  bus_data_rd,   
        
    output          bus_rd_en,
    output          bus_wr_en,
    output  [31:0]  bus_addr,
    output  [31:0]  bus_data_wr,
    output  [3:0]   bus_byte_en,
    */

    /* PC */
    output  [31:0]  pc
   
);

wire    [6:0]   inst_opcode;
wire    [6:0]   inst_funct7;
wire    [2:0]   inst_funct3;

wire    [31:0]  mem_rddata;
wire    [31:0]  mem_addr;
wire    [31:0]  mem_wrdata;

wire            pc_wren;
wire            sel_next_pc;
wire            reg_file_wen;

wire    [3:0]   alu_op;
wire            alu_op_a_sel;
wire            alu_op_b_sel;
wire            alu_rd_equals_zero;
wire            alu_overflow;

datapath_single datapath_single(
    .clk                (clk),
    .rst                (rst),

    .inst               (inst),
    .inst_opcode        (inst_opcode),
    .inst_funct7        (inst_funct7),
    .inst_funct3        (inst_funct3),

    .mem_rddata         (mem_rddata),
    .mem_addr           (mem_addr),
    .mem_wrdata         (mem_wrdata),

    .pc_wren            (pc_wren),
    .sel_next_pc        (sel_next_pc),
    .pc                 (pc),

    .reg_file_wen       (reg_file_wen),

    .alu_op             (alu_op),
    .alu_op_a_sel       (alu_op_a_sel),
    .alu_op_b_sel       (alu_op_b_sel),
    .alu_rd_equals_zero (alu_rd_equals_zero),
    .alu_overflow       (alu_overflow)
    
);

controlpath_single controlpath_single (
    .inst_opcode        (inst_opcode),
    .inst_funct7        (inst_funct7),
    .inst_funct3        (inst_funct3),

    .alu_op             (alu_op),
    .alu_op_a_sel       (alu_op_a_sel),
    .alu_op_b_sel       (alu_op_b_sel),
    .alu_overflow       (alu_overflow),
    .alu_rd_equals_zero (alu_rd_equals_zero),

    .pc_wren            (pc_wren),
    .sel_next_pc        (sel_next_pc),

    .reg_file_wen       (reg_file_wen),

    .mem_rd_en          (mem_rd_en),
    .mem_wr_en          (mem_wr_en)

);

/*
data_memory data_memory (
    .clk                (clk),
    .rd_en              (mem_rd_en),
    .wr_en              (mem_wr_en),
    .address            (mem_addr),
    .wr_data            (mem_wrdata),
    .rd_data            (mem_rddata),

    .bus_data_rd        (bus_data_rd),
    .bus_rd_en          (bus_rd_en),
    .bus_wr_en          (bus_wr_en),
    .bus_addr           (bus_addr),
    .bus_data_wr        (bus_data_wr),
    .bus_byte_en        (bus_byte_en)
 );

*/
endmodule