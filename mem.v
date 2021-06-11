//author:梁,stride
module mem( clk,
            cen,
            wen,
            bwen,
            a,
            d,
            q);

input clk;
input cen;
input wen;
input[31:0]bwen;
input[7:0]a;
input[31:0]d;
output reg [31:0]q;

reg [31:0]mem[255:0];    //1KB memory;

always@ (posedge clk)begin
    if(cen == 1)begin
        q <= q;         //when not select, q maintain it's value
    end
    else if(wen == 1)begin // read
        q <= mem[a];
    end
    // else begin  // write
    //    q <= 32'h0000_0000;   // when write mode q = 0
    // end
end

genvar j;
generate for (j = 0; j < 32; j = j + 1) begin
    always @(posedge clk) begin:bitwrite
       if((cen == 0) && (wen == 0)) mem[a][j] = bwen[j] ? d[j] : mem[a][j];
    end
end
endgenerate

endmodule
