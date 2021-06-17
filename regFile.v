module regFile(
    input           nrst,   //asynchronous reset, low effective
    input           clk,

    input      [4:0]   radd1, 
    input      [4:0]   radd2,

    input              wen,    //write enable
    input      [4:0]   wadd,
    input      [31:0] wdata,

    output reg [31:0] rs1,    //output register values
    output reg [31:0] rs2
);

reg [31:0] reg_file [1:31]; // the register file

always @(posedge clk or negedge nrst) begin 
    if (~nrst) begin
        reg_file[1] <= 32'b0;
        reg_file[2] <= 32'b0;
        reg_file[3] <= 32'b0;
        reg_file[4] <= 32'b0;
        reg_file[5] <= 32'b0;
        reg_file[6] <= 32'b0;
        reg_file[7] <= 32'b0;
        reg_file[8] <= 32'b0;
        reg_file[9] <= 32'b0;
        reg_file[10] <= 32'b0;
        reg_file[11] <= 32'b0;
        reg_file[12] <= 32'b0;
        reg_file[13] <= 32'b0;
        reg_file[14] <= 32'b0;
        reg_file[15] <= 32'b0;
        reg_file[16] <= 32'b0;
        reg_file[17] <= 32'b0;
        reg_file[18] <= 32'b0;
        reg_file[19] <= 32'b0;
        reg_file[20] <= 32'b0;
        reg_file[21] <= 32'b0;
        reg_file[22] <= 32'b0;
        reg_file[23] <= 32'b0;
        reg_file[24] <= 32'b0;
        reg_file[25] <= 32'b0;
        reg_file[26] <= 32'b0;
        reg_file[27] <= 32'b0;
        reg_file[28] <= 32'b0;
        reg_file[29] <= 32'b0;
        reg_file[30] <= 32'b0;
        reg_file[31] <= 32'b0;
    end
    else begin
        if (wen && (wadd != 5'b0)) begin // not write to reg0
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
        rs1 <= (radd1 == 5'b0) ? 5'b0 : reg_file[radd1];
        rs2 <= (radd2 == 5'b0) ? 5'b0 : reg_file[radd2];
    end
end

endmodule