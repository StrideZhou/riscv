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

regFile regFile(
    .nrst  ( nrst  ),
    .clk   ( clk   ),
    .radd1 ( radd1 ),
    .radd2 ( radd2 ),
    .wen   ( wen   ),
    .wadd  ( wadd  ),
    .wdata ( wdata ),
    .rs1   ( rs1   ),
    .rs2   ( rs2   )
);
syn_reg#(.W ( 32 ))     u_syn_reg( clk,nrst,1,next,value );


alu_mod alu_mod(
    .inst     ( inst     ),
    .rs1_data ( rs1_data ),
    .rs2_data ( rs2_data ),
    .rd_data  ( rd_data  ),
    .pc       ( pc       ),
    .br_en    ( br_en_x  )//! x preliminary
);

memory dmem(
    .clk     ( clk     ),
    .nrst    ( nrst    ),
    .stall   ( stall   ),
    .op_code ( op_code ),
    .rwaddr  ( rwaddr  ),
    .wdata   ( wdata   ),
    .rdata   ( rdata   )
);


endmodule