module top_tb (
    input clk,
    input rst
);
    reg nrst = ~rst;

    reg  [31:0] inst = 0;
    reg  [31:0] pc = 0;

    reg         exIns_valid = 0;
    reg  [31:0] exIns_in = 32'h0;

    wire        exIns_ren;
    wire [31:0] exIns_addr;

    /* Init clk and nrst */
    initial begin
        nrst = 1'b1;
    //     #0 nrst = 1'b0;
    //     #1 nrst = 1'b1;
    end

    // initial begin
    //     clk = 1'b1;
    //     forever begin
    //         #1 clk = ~clk;
    //     end
    // end

    reg [31:0] reg_file [0:31]; // the register file
    integer i,j,k;
    initial begin

        $readmemh( "riscv.hex", u_core.ins_mod.imem.mem1.mem );
        for (i=0; i<256; i=i+1) begin
            u_core.dmem_mod.dmem.mem1.mem[i] = 32'b0;
            u_core.dmem_mod.dmem.mem2.mem[i] = 32'b0;
        end

        // #530 $finish; 
    end

    reg [31:0] checkpoint[0:2];
    assign checkpoint[0] = 32'h0000_00fc + 32'h8;
    assign checkpoint[1] = 32'h0000_0174 + 32'h8;
    assign checkpoint[2] = 32'h0000_0328 + 32'h8;
    integer errflag = 0;

    always @(posedge clk ) begin
        for (k=0; k<3; k=k+1) begin
            if (u_core.pc_r2 == checkpoint[k])begin 
                $readmemh( $sformatf("regfile%0d.mem", k+1), reg_file );

                $display("%0t ns\n==PC=0x%H-begin==================", $time, pc);
                for (i=0; i<8; i=i+1) begin
                    $write("@%H:\t", i*4 );
                    for (j=0; j<4; j=j+1) begin
                        $write("%H ",u_core.regFile.reg_file[ i*4 + j ]);
                        errflag += (u_core.regFile.reg_file[ i*4 + j ] != reg_file[ i*4 + j]);
                    end
                    $write("\n");
                end
                $display("==PC=0x%H-end====================", pc);
                $display("ERROR = %d", errflag);
                if(k == 2 && errflag == 0) $display(
" *******      **      ********  ********\n",
"/**////**    ****    **//////  **////// \n",
"/**   /**   **//**  /**       /**       \n",
"/*******   **  //** /*********/*********\n",
"/**////   **********////////**////////**\n",
"/**      /**//////**       /**       /**\n",
"/**      /**     /** ********  ******** \n",
"//       //      // ////////  ////////  \n\n");
            end
        end
        if (u_core.pc_r2 == 32'h033c) $finish;
    end

    initial begin
        $display("%0t ns\n==mem-begin==================", $time);
        for (i=0; i<32; i=i+1) begin
            $write("@%H:\t", i*8 );
            for (j=0; j<8; j=j+1) begin
                $write("%H ",u_core.ins_mod.imem.mem1.mem [ i*8 + j ]);
            end
            $write("\n");
        end
        $display("==mem-end====================");
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
