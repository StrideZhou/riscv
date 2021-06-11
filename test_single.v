module test;
    reg clk;
    reg rst;

    reg [31:0] inst;
    reg [31:0] pc;

    /* Init clk and nrst */
    initial begin
        rst = 1'b0;
        #5 rst = 1'b1;
        #2 rst = 1'b0;
    end

    initial begin
        clk = 1'b0;
        forever begin
            #1 clk = ~clk;
        end

    end

    initial begin
        inst = 31'b0;
        #15 inst = {7'b0000000, 5'b01010, 5'b10011, 3'b000, 5'b10010, 7'b0110011};
        #2 inst = 32'b0;

    end

    core_single core_single_tb (
        .clk    (clk),
        .rst    (rst),
        .inst   (inst),
        .pc     (pc)
    );
    
endmodule
