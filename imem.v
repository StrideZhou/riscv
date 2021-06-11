`define LoadByte      3
`define LoadHalfWord  2 
`define LoadWord      3
`define StoreByte     4 
`define StoreHalfWord 5 
`define StoreWord     6 
`define IMEM_AWidth   11
`define IMEM_Size     2 ** `IMEM_AWidth
module imem #(
        parameter ADDR_Width = 11
    )(
    input clk,
    input nrst,
    input stall,
    input [2:0] op_code,
    input [ADDR_Width-1:0]RWaddr,
    input [31:0]wdata,
    output reg [31:0]rdata
    );
 
    reg [31:0]mem[2**ADDR_Width-1:0];
 
// initial $readmemh("1.hex", mem);
// reg i;
// initial
// begin
//     for (i = 0; i <= 2^ADDR_Width-1; i = i + 1) begin
//         mem[i] = 0;
//     end
// end

always @ (posedge clk or negedge nrst)begin
    if (~nrst) begin
        rdata <= 32'b0;
    end
    else if (~stall) begin
        case (op_code)
            `LoadWord: rdata <= RWaddr+32'h5a000000;
            default: rdata <= 32'ha5fa115a;
        endcase
    end  
 end
endmodule