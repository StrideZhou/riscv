`timescale 1 ps/ 1 ps
module memory_vlg_tst();
reg clk;
reg nrst;
reg [2:0] op_code;
reg [13:0] rwaddr;
reg stall;
reg [31:0] wdata;                                              
wire [31:0]  rdata;

// assign statements (if any)                          
memory i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.nrst(nrst),
	.op_code(op_code),
	.rdata(rdata),
	.rwaddr(rwaddr),
	.stall(stall),
	.wdata(wdata)
);

parameter CYCLE=20;

initial                                                
begin                                                  
#10;
clk=0;
nrst=1;
#10;
clk=1;
nrst=0;
#10;
clk=0;
nrst=1;
forever
#(CYCLE/2)
clk=~clk;
end                                                    

initial begin
    #20;
    op_code=3'b111;
    rwaddr=14'b00_01_11111111_00;
    stall=0;
    wdata=32'h0000_0001;
    #100;
    op_code=3'b010;
    rwaddr=14'b00_01_11111111_00;
    stall=0;
    wdata=32'h0000_0000;
    #100;
    op_code=3'b100;
    rwaddr=14'b01_10_11111110_00;
    stall=0;
    wdata=32'h0000_1111;
    #100;
    op_code=3'b000;
    rwaddr=14'b01_10_11111110_00;
    stall=0;
    wdata=32'h000_0001;
    #100;
    op_code=3'b101;
    rwaddr=14'b00_01_11111111_00;
    stall=0;
    wdata=32'h0000_1111;
    #100;
    op_code=3'b001;
    rwaddr=14'b00_01_11111111_00;
    stall=0;
    wdata=32'h0000_1111; 
end

endmodule
