`include "mem.vh"
`include "opcode.vh"
module dmem_mod (
	input        clk,
	input		 nrst,
	input		 stall,

	input [2:0]  inst_funct3,
    input [2:0]  mem_opcode,

	input [31:0] rwaddr, //caculate dmem adress in alu_mod
	input [31:0] wdata,
	output reg [31:0] rdata
	
);

wire  [31:0]  mem_rdata_r;
memory dmem(
    .clk     ( clk        ),
    .nrst    ( nrst       ),
    .stall   ( stall      ),

    .op_code ( mem_opcode ),

    .rwaddr  ( rwaddr[10:0]),
    .wdata   ( wdata      ),
    .rdata   ( mem_rdata_r  ) // always signed
);

wire [2:0]  inst_funct3_r;
syn_reg#(.W (  3 ))    inst_funct3_reg( clk,nrst,1'd1, inst_funct3, inst_funct3_r );
always @(*) begin
    rdata = mem_rdata_r; // mem_rdata always signed
    case(inst_funct3_r)  //! no need opcode
        `FUNC3_LBU: begin
			rdata = { 24'd0, mem_rdata_r[7:0] };
		end
        `FUNC3_LHU: begin
			rdata = { 16'd0, mem_rdata_r[15:0] };
		end
    endcase
end

endmodule