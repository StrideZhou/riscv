`define IMEM_AWidth   11
`define IMEM_Size     2 ** `IMEM_AWidth
`include "memory.v"
module ins_mod #(
   parameter     PC_init = 32'hfc
)(
    input  clk,
    input  nrst,
    input  stall,
    input  br_en,
    input  [31:0] br_addr,
    output [31:0] PC,
    output [31:0] ins_out,

    input  exIns_valid,
    input  [31:0]exIns_in,
    output exIns_ren,
    output reg [31:0]exIns_addr
    );
    
    wire [31:0]rdata;
    
    reg [31:0] exIns_in_r;
    reg [31:0] PC_reg = PC_init;
    reg ren;
    reg exIns_ren_r;
    wire Ins_ready;

    memory imem(
        .clk(clk),
        .nrst(nrst),
        .stall(stall),
        .op_code(`LoadWord),
        .rwaddr(PC[10:0]),
        .wdata(32'b0),
        .rdata(rdata)
    );

// PC + 4
always @ (posedge clk or negedge nrst)begin
    if(~nrst)                   PC_reg <= PC_init;
    else if(~stall & Ins_ready) PC_reg <= PC + 32'd4; 
end
assign PC = br_en ? br_addr:PC_reg;

// Ins_ready 
assign Ins_ready = ~(exIns_ren ^ exIns_valid) | ~exIns_ren;

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

// PC to Ins_addr decoder
always @(*) begin:PCdec
    if (PC > `IMEM_Size - 4) begin
        exIns_addr = PC - `IMEM_Size;
        ren = 1'b0;
    end
    else begin
        exIns_addr = 32'hffffffff;
        ren = 1'b1;
    end
end

assign exIns_ren = ~ren;//local means not extern

endmodule