module regFile #(
    parameter W = 32, N = 32 //Width = 32, Number of regs = 32
)(
    input           nrst,   //asynchronous reset, low effective
    input           clk,

    input      [4:0]   radd1, 
    input      [4:0]   radd2,

    input              wen,    //write enable
    input      [4:0]   wadd,
    input      [W-1:0] wdata,

    output reg [W-1:0] rs1,    //output register values
    output reg [W-1:0] rs2
);

reg [W-1:0] reg_file [0:N-1]; // the register file

integer i;
always @(posedge clk or negedge nrst) begin 
    if (~nrst) begin
            for (i = 0; i < N; i = i + 1) reg_file[i] = 32'b0;
    end
    else if (wen) begin // not write to reg0
        if(wadd != 5'b0) begin
            reg_file[wadd] <= wdata;
        end
    end
end

always @(posedge clk or negedge nrst) begin 
    if (~nrst) begin
        rs1 <= 1'b0;
        rs2 <= 1'b0;
    end
    else begin 
        rs1 <= reg_file[radd1];
        rs2 <= reg_file[radd2];
    end
end

endmodule