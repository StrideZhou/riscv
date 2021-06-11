module mux4 #(
    parameter WIDTH     = 32,
    parameter CHANNELS  = 4
) (
    input   [WIDTH-1:0] in0,
    input   [WIDTH-1:0] in1,
    input   [WIDTH-1:0] in2,
    input   [WIDTH-1:0] in3,

    input   [1:0] sel,
    output  [WIDTH-1:0] out
);
    
    reg     [WIDTH-1:0] in_array [0:CHANNELS-1]; 
    
    assign  in_array[0] = in0;
    assign  in_array[1] = in1;    
    assign  in_array[2] = in2;
    assign  in_array[3] = in3;

    assign  out = in_array[sel];


endmodule