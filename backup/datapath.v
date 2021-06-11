`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/15 09:31:18
// Design Name:
// Module Name: datapath
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module datapath(input clk,
                input [19:0] bitimm,
                input [3:0] op,
                input [31:0] rs1,
                input [31:0] rs2,
                output reg[31:0] rd,
                output reg overflow);
    
    always@(posedge clk)
    begin
        case(op)
            4'b0000: rd <= rs1 << rs2 ;
            4'b0001: rd <= rs1 >> rs2 ;
            4'b0010: rd <= rs1 >>> rs2 ;
            4'b0011:
            begin
                {overflow,rd} <= rs1 + rs2 ;
            end
            4'b0100:
            begin
                {overflow,rd} <= rs1 - rs2 ;
            end
            4'b0101: rd <= {bitimm,12'b0} ;
            4'b0110:
            begin
                case({rs1[31],rs2[31]})
                    2'b01: rd   <= 0 ;
                    2'b10: rd   <= 1 ;
                    default: rd <= (rs1<rs2)?1:0 ;
                endcase
            end
            4'b0111: rd <= (rs1<rs2)?1:0 ;
            4'b1000: rd <= rs1 ^ rs2 ;
            4'b1001: rd <= rs1 | rs2 ;
            4'b1010: rd <= rs1 & rs2 ;
            4'b1011: rd <= (rs1*rs2) ;
            default: rd <= 32'b0;
        endcase
    end
    
endmodule
