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
        #0 nrst = 1'b0;
        #1 nrst = 1'b1;
    end

    initial begin
        clk = 1'b1;
        forever begin
            #1 clk = ~clk;
        end
    end

defparam u_core.ins_mod.imem.mem1.xpm_memory_spram_inst.MEMORY_INIT_FILE = "riscv-imem.mem";
    // integer i;
    initial begin
        // $readmemh( "riscv.hex", u_core.ins_mod.imem.mem1.mem );
        // for (i=0; i<256; i=i+1) begin
        //     u_core.dmem_mod.dmem.mem1.mem[i] = 32'b0;
        //     u_core.dmem_mod.dmem.mem2.mem[i] = 32'b0;
        // end

        #530 $stop; 
    end

    always @(posedge clk ) begin
        if (pc == 32'h0000_0328) 
        // if (pc == 32'h0000_0174) 
        // if (pc == 32'h0000_00fc) 
        #7 $stop;
    end
core u_core(
    .clk          ( clk         ),
    .nrst         ( nrst        ),

    .exIns_valid  ( exIns_valid ),
    .exIns_in     ( exIns_in    ),
    .exIns_ren    ( exIns_ren   ),
    .exIns_addr   ( exIns_addr  )

//    .pc           ( pc          ),
//    .inst         ( inst        )
);


endmodule
