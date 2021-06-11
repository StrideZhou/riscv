`include "control_constants.v"

module immediate_gen (
    input       [31:0] inst,
    output reg  [31:0] immediate
);

    
always@(*) begin
    immediate = 32'b0;
    case (inst[6:0]) // Opcode
        `OPCODE_STORE:  // S-type immediate
            immediate = { {21{inst[31]}}, inst[30:25], inst[11:7] };
        default: immediate = 32'b0;
    endcase
end

endmodule