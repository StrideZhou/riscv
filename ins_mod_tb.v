`timescale 1ns / 1ps
`include "ins_mod.v"

module ins_mod_tb();
   reg clk = 1;
   reg nrst = 0;
   reg stall;
   reg br_en;
   reg  [31:0] br_addr;
   wire [31:0] PC;
   wire [31:0] ins_out;

   reg  exIns_valid = 0;
   reg  [31:0]exIns_in = 32'h5a5aFFFF;
   wire exIns_ren;
   wire [31:0]exIns_addr;

    ins_mod UUT(
        .clk(clk),
        .nrst(nrst),
        .stall(stall),
        .br_en(br_en),
        .br_addr(br_addr),
        .PC(PC),
        .ins_out(ins_out),

        .exIns_valid(exIns_valid),
        .exIns_in(exIns_in),
        .exIns_ren(exIns_ren),
        .exIns_addr(exIns_addr)
    );
 
initial begin
    $monitor($time,,"PC = %h  ins_out= %h",PC,ins_out);
    clk = 1;
    stall = 0;
    br_en = 0;
    br_addr = `IMEM_Size -12;
    #2 nrst = 1;
    #10 stall = 1;
    #10 stall = 0;
    #20
    #10 br_en = 1;
    #10 br_en = 0;
    
    #90 
    br_addr = 32'b0;
    br_en = 1;
    #10 br_en = 0;
    
    #40 $stop;

end

always @(posedge exIns_ren or exIns_addr) begin
    #0 exIns_valid = 0;
    if (exIns_ren) begin 
        #2
        if (exIns_ren) begin
            exIns_in = 32'h5a5a0000 + exIns_addr;
            exIns_valid = 1;
        end
    end
end

integer i;
initial
begin
    for (i = 0; i <= 256 -1; i = i + 1) begin
        UUT.imem.mem1.mem[i] = i * 4 + 32'h5a010000;
        UUT.imem.mem2.mem[i] = i * 4 + 32'h5a020000;
    end
end    

always #5 clk = ~clk;
    
endmodule