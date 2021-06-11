module test;
    reg clk;
    reg nrst;

    reg  [31:0] inst;
    reg  [31:0] pc;

    reg         exIns_valid = 0;
    reg  [31:0] exIns_in = 32'hx;

    wire        exIns_ren;
    wire [31:0] exIns_addr;

    /* Init clk and nrst */
    initial begin
        nrst = 1'b1;
        #1 nrst = 1'b0;
        #2 nrst = 1'b1;
    end

    initial begin
        clk = 1'b0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        $readmemh( "riscv.hex", u_core.ins_mod.imem.mem1.mem );
        #470 $stop; 
    end
    
core u_core(
    .clk          ( clk         ),
    .nrst         ( nrst        ),

    .exIns_valid  ( exIns_valid ),
    .exIns_in     ( exIns_in    ),
    .exIns_ren    ( exIns_ren   ),
    .exIns_addr   ( exIns_addr  ),

    .pc           ( pc          ),
    .inst         ( inst        )
);


endmodule
