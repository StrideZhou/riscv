module syn_reg #(
    parameter W = 32,
    parameter INITIAL = 0)(
    input clk,
    input rst,
    input wr_en,
    input [W-1:0] next,
    output reg [W-1:0] value);
    
initial value = INITIAL;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        value <= INITIAL;
    end
    else if (wr_en) begin
        value <= next;
    end
end
endmodule
