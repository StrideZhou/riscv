module mux2 #(
    parameter WIDTH     = 32,
    parameter CHANNELS  = 2
) (
    input   [WIDTH-1:0] in0,
    input   [WIDTH-1:0] in1,
    input   sel,
    output  [WIDTH-1:0] out
);
    
    reg     [WIDTH-1:0] in_array [0:CHANNELS-1]; 
    
    assign  in_array[0] = in0;
    assign  in_array[1] = in1;    

    assign  out = in_array[sel];


endmodule