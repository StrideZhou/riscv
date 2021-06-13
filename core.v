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
    wire        ins_br_en = 0;
    wire [31:0] ins_br_addr = 0;
    wire [31:0] pc_r1;
//  wire pc;
//  wire inst;

ins_mod ins_mod(
    .clk         ( clk         ),
    .nrst        ( nrst        ),

    .stall       ( 1'b0        ),

    .br_en       ( ins_br_en   ),
    .br_addr     ( ins_br_addr ),

    .pc          ( pc          ),
    .ins_out     ( inst        ),

    .exIns_valid ( exIns_valid ),
    .exIns_in    ( exIns_in    ),
    .exIns_ren   ( exIns_ren   ),
    .exIns_addr  ( exIns_addr  )
);
syn_reg#(.W ( 32 ))       pc_reg1( clk,nrst,1'd1,pc,pc_r1 );

//* pip stage 2  ---------------------------------------
wire  rf_wen;
wire  [4:0] radd1,radd2,rf_wadd;
wire  [31:0] rf_wdata,rs1_data,rs2_data,pc_r2,inst_r2;
inst_decoder regfile_inst_decoder(
    .inst        ( inst        ),
    .inst_rs1    ( radd1       ),
    .inst_rs2    ( radd2       )
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

syn_reg#(.W ( 32 ))       pc_reg2( clk,nrst,1'd1, pc_r1, pc_r2   );
syn_reg#(.W ( 32 ))     inst_reg2( clk,nrst,1'd1, inst , inst_r2 );

//* pip stage 3  ---------------------------------------
wire         br_en_r3,rd_wen;
wire  [31:0] alu_rd_data,rdata;
wire  [2:0]  inst_funct3,mem_opcode;
alu_mod alu_mod(
    .inst     ( inst_r2    ),
    .rs1_data ( rs1_data   ),
    .rs2_data ( rs2_data   ),
    .rd_data  ( alu_rd_data),
    .pc       ( pc_r2      ),
    .br_en    ( br_en_r3   )
);

inst_decoder mem_inst_decoder(
    .inst        ( inst_r2     ),
    .rd_wen      ( rd_wen      ),
    .inst_funct3 ( inst_funct3 ),
    .mem_opcode  ( mem_opcode  )
);


dmem_mod dmem_mod(
    .clk         ( clk         ),
    .nrst        ( nrst        ),
    .stall       ( stall       ),

    .inst_funct3 ( inst_funct3 ),
    .mem_opcode  ( mem_opcode  ),

    .rwaddr      ( alu_rd_data > 11'b1 ? 11'b1 : alu_rd_data[11:0]),
    .wdata       ( rs2_data    ),
    .rdata       ( rdata       )
);


assign ins_br_en   = br_en_r3;
assign ins_br_addr = alu_rd_data;

assign rf_wen   = rd_wen;
assign rf_wdata = rdata;
assign rf_wadd  = alu_rd_data;

endmodule