`include "mem.vh"
`define IMEM_AWidth   11
`define IMEM_Size     2 ** `IMEM_AWidth

module ins_mod #(
    parameter     pc_init = 32'h0000_0000
)(
    input  clk,
    input  nrst,
    input  stall,
    input  br_en,
    input  [31:0] br_addr,
    output [31:0] pc,
    output [31:0] ins_out,

    input  exIns_valid,
    input  [31:0]exIns_in,
    output exIns_ren,
    output reg [31:0]exIns_addr
    );
    
    wire [31:0]rdata;
    
    reg [31:0] exIns_in_r;
    reg [31:0] pc_reg = pc_init;
    reg ren;
    reg exIns_ren_r;
    wire Ins_ready;

    memory imem(
        .clk(clk),
        .nrst(nrst),
        .stall(stall),
        .op_code(`LoadWord),
        .rwaddr(pc[10:0]),
        .wdata(32'b0),
        .rdata(rdata)
    );

// pc + 4
always @ (posedge clk or negedge nrst)begin
    if(~nrst)                   pc_reg <= pc_init;
    else if(~stall & Ins_ready) pc_reg <= pc + 32'd4; 
end
assign pc = br_en ? br_addr : pc_reg;

// Ins_ready 
assign Ins_ready = (exIns_ren & exIns_valid) | ren;

// exIns_in_r: store vaild exIns
always @ (posedge clk or negedge nrst)begin
    if(~nrst) exIns_in_r <= 32'b0;
    else if( exIns_valid & exIns_ren) exIns_in_r <= exIns_in;
    else if(~exIns_valid & exIns_ren) exIns_in_r <= 32'b0;
end

// reg exIns_ren
always @(posedge clk or negedge nrst) begin
    if(~nrst)   exIns_ren_r <= 1'b0;
    else        exIns_ren_r <= exIns_ren;
end

// ins_out MUX
assign ins_out = exIns_ren_r ? exIns_in_r : rdata;

// pc to Ins_addr decoder
always @(*) begin:pcdec
    if (pc > `IMEM_Size - 4) begin
        exIns_addr = pc - `IMEM_Size;
        ren = 1'b0;
    end
    else begin
        exIns_addr = 32'hffff_ffff;
        ren = 1'b1;
    end
end

assign exIns_ren = ~ren;//local means not extern

endmodule