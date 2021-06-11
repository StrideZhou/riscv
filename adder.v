module adder #(
    parameter  WIDTH = 32
) (
    input  [WIDTH-1:0] op_a,
    input  [WIDTH-1:0] op_b,
    output [WIDTH-1:0] result
);

    assign result = op_a + op_b;

endmodule