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
    wire        ins_br_en;
    wire [31:0] ins_br_addr;
    wire [31:0] pc_r1,inst_r1;
    wire        stall = 0;
//  wire pc;
//  wire inst;

ins_mod ins_mod(
    .clk         ( clk         ),
    .nrst        ( nrst        ),

    .stall       ( stall       ),

    .br_en       ( ins_br_en   ),
    .br_addr     ( ins_br_addr ),

    .pc          ( pc          ),
    .ins_out     ( inst_r1     ),

    .exIns_valid ( exIns_valid ),
    .exIns_in    ( exIns_in    ),
    .exIns_ren   ( exIns_ren   ),
    .exIns_addr  ( exIns_addr  )
);
assign inst = inst_r1; //for debug output
syn_reg#(.W ( 32 ))       pc_reg1( clk,nrst,1'd1,pc,pc_r1 );

//* pip stage 2  ---------------------------------------
wire  rf_wen;
wire  [4:0] radd1_r1,radd2_r1,rf_waddr;
wire  [31:0] rf_wdata,rs1_data_r2,rs2_data_r2,pc_r2,inst_r2;
inst_decoder regfile_inst_decoder(
    .inst        ( inst_r1     ),
    .inst_rs1    ( radd1_r1    ),
    .inst_rs2    ( radd2_r1    )
);

regFile regFile(
    .nrst  ( nrst  ),
    .clk   ( clk   ),
    .radd1 ( radd1_r1  ),
    .radd2 ( radd2_r1  ),
    .wen   ( rf_wen    ),
    .wadd  ( rf_waddr   ),
    .wdata ( rf_wdata  ),
    .rs1   ( rs1_data_r2 ),
    .rs2   ( rs2_data_r2 )
);

syn_reg#(.W ( 32 ))       pc_reg2( clk,nrst,1'd1, pc_r1   , pc_r2   );
syn_reg#(.W ( 32 ))     inst_reg2( clk,nrst,1'd1, inst_r1 , inst_r2 );

//* pip stage 3  ---------------------------------------
wire        br_en_r2,br_en_r3,
            rd_wen_r2,rd_wen_r3,
            mem_rdata_valid_r2,mem_rdata_valid_r3;
wire [31:0] alu_rd_data_r2,mem_rdata_r3,dmem_rwaddr,
            br_addr_r2,br_addr_r3;
wire [2:0]  inst_funct3_r2,mem_opcode_r2;
wire [4:0]  rd_addr_r2,rd_addr_r3;
alu_mod alu_mod(
    .inst     ( inst_r2    ),
    .rs1_data ( rs1_data_r2   ),
    .rs2_data ( rs2_data_r2   ),
    .rd_data  ( alu_rd_data_r2),
    .pc       ( pc_r2      ),
    .br_en    ( br_en_r2   )
);

inst_decoder mem_inst_decoder(
    .inst        ( inst_r2        ),
    .inst_rd     ( rd_addr_r2     ),
    .rd_wen      ( rd_wen_r2     ),
    .inst_funct3 ( inst_funct3_r2 ),
    .mem_opcode  ( mem_opcode_r2 ),
    .mem_rdata_valid(mem_rdata_valid_r2)
);

assign dmem_rwaddr = alu_rd_data_r2 > {21'b0, 11'b1} ? 32'b1 : alu_rd_data_r2;
dmem_mod dmem_mod(
    .clk         ( clk         ),
    .nrst        ( nrst        ),
    .stall       ( stall       ),

    .inst_funct3 ( inst_funct3_r2 ),
    .mem_opcode  ( mem_opcode_r2  ),

    .rwaddr      ( dmem_rwaddr    ),
    .wdata       ( rs2_data_r2    ),
    .rdata       ( mem_rdata_r3   )
);

assign br_addr_r2 = alu_rd_data_r2; // alu_rd_data contain all(branch) adress 

syn_reg#(.W (  1 ))     br_en_reg3  ( clk,nrst,1'd1, br_en_r2  , br_en_r3   );
syn_reg#(.W ( 32 ))     br_addr_reg3( clk,nrst,1'd1, br_addr_r2, br_addr_r3 );
syn_reg#(.W (  5 ))     rd_addr_reg3( clk,nrst,1'd1, rd_addr_r2, rd_addr_r3 );
syn_reg#(.W (  1 ))     rd_wen_reg3 ( clk,nrst,1'd1, rd_wen_r2 , rd_wen_r3   );
syn_reg#(.W (  1 ))     mem_rdata_valid_reg3 ( clk,nrst,1'd1, mem_rdata_valid_r2 , mem_rdata_valid_r3   );

//*pip stage ----------write back---------------------
assign ins_br_en    = br_en_r3;
assign ins_br_addr  = br_addr_r3;

assign rf_waddr  = rd_addr_r3; 
assign rf_wen   = rd_wen_r3;

// br_addr  = alu_rd_data contain rd_data
assign rf_wdata = mem_rdata_valid_r3 ? mem_rdata_r3 : br_addr_r3;


endmodule