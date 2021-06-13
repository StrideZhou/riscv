module syn_reg #(
    parameter W = 32,
    parameter INITIAL = 0)(
    input clk,
    input nrst,
    input wr_en,
    input [W-1:0] next,
    output reg [W-1:0] value);
    
initial value = INITIAL;

always @ (posedge clk or negedge nrst) begin
    if (nrst == 1'b0) begin
        value <= INITIAL;
    end
    else if (wr_en) begin
        value <= next;
    end
end
endmodule
