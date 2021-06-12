module core (
    
    /* for DC */
    input   clk,
    input   nrst,
    
    input  exIns_valid,
    input  [31:0]exIns_in,
    output exIns_ren,
    output [31:0]exIns_addr,

    //!for debug
    /* pc */
    output   [31:0]  pc,
    /* 32-bits instruction  out*/
    output   [31:0]  inst
);

//* pip stage 1  ---------------------------------------
//ins_mod
    wire        br_en = 0;
    wire [32:0] br_addr = 0;
//  wire pc;
//  wire inst;

ins_mod ins_mod(
    .clk         ( clk         ),
    .nrst        ( nrst        ),

    .stall       ( 1'b0        ),

    .br_en       ( br_en       ),
    .br_addr     ( br_addr     ),

    .pc          ( pc          ),
    .ins_out     ( inst        ),

    .exIns_valid ( exIns_valid ),
    .exIns_in    ( exIns_in    ),
    .exIns_ren   ( exIns_ren   ),
    .exIns_addr  ( exIns_addr  )
);
syn_reg#(.W ( 32 ))       pc_reg1( clk,nrst,1,pc,pc_r1 );

//* pip stage 2  ---------------------------------------
inst_decoder inst_decoder1(
    .inst        ( inst        ),
    .inst_rs1    ( radd1       ),
    .inst_rs2    ( radd2       )
//    .mem_opcode  ( mem_opcode  )
);

regFile regFile(
    .nrst  ( nrst  ),
    .clk   ( clk   ),
    .radd1 ( radd1 ),
    .radd2 ( radd2 ),
    .wen   ( rf_wen   ),
    .wadd  ( rf_wadd  ),
    .wdata ( rf_wdata ),
    .rs1   ( rs1_data ),
    .rs2   ( rs2_data )
);

syn_reg#(.W ( 32 ))       pc_reg2( clk,nrst,1, pc_r1, pc_r2   );
syn_reg#(.W ( 32 ))     inst_reg2( clk,nrst,1, inst , inst_r2 );

//* pip stage 3  ---------------------------------------

alu_mod alu_mod(
    .inst     ( inst     ),
    .rs1_data ( rs1_data ),
    .rs2_data ( rs2_data ),
    .rd_data  ( alu_rd_data  ),
    .pc       ( pc       ),
    .br_en    ( br_en_x  )//! x preliminary
);

memory dmem(
    .clk     ( clk        ),
    .nrst    ( nrst       ),
    .stall   ( 1'b0       ),
    .op_code ( mem_opcode ),
    .rwaddr  ( alu_rd_data    ),
    .wdata   ( mem_wdata  ),
    .rdata   ( mem_rdata  )
);


endmodule