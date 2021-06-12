//author:梁根源,stride
//存储器读写模块
`include "mem.vh"
module memory (
			clk,
			nrst,
			stall,
			op_code,
			rwaddr,
			wdata,
			rdata);
input clk;
input nrst;
input stall;
input [2:0]  op_code;
input [10:0] rwaddr;
input [31:0] wdata;
output[31:0] rdata;

reg  [31:0] rdata;
wire [31:0] q_1;   //2 mem output
wire [31:0] q_2;
reg  [31:0] q;     //choose form q1,q2
reg  [31:0] d;     //d get from wdata
reg  [31:0] bwen;
wire        wen;
reg         cen_1;
reg         cen_2;

reg [10:0] rwaddr_r;

assign  wen = op_code[2]; // wen == 0 ,write

 mem  mem1( .clk (clk),
            .cen (cen_1),
            .wen (wen),
            .bwen(bwen),
            .a   (rwaddr[9:2]),
            .d   (d),
            .q   (q_1)
			 );

 mem  mem2( .clk (clk),
            .cen (cen_2),
            .wen (wen),
            .bwen(bwen),
            .a   (rwaddr[9:2]),
            .d   (d),
            .q   (q_2)
			 );

always @(*) begin
	case(op_code)
    	`LoadByte:begin
			case(rwaddr[1:0])
				2'b00:rdata = {{24{q[ 7]}},{q[ 7: 0]}};
				2'b01:rdata = {{24{q[15]}},{q[15: 8]}};
				2'b10:rdata = {{24{q[23]}},{q[23:16]}};
				2'b11:rdata = {{24{q[31]}},{q[31:24]}};
			endcase
		end
    	`LoadHalfWord:begin
			if (rwaddr[1]==0)	rdata = {{16{q[15]}},q[15: 0]};	 
			else				rdata = {{16{q[31]}},q[31:16]};
		end
    	`LoadWord:	rdata = q;
		default:	rdata = q;
	endcase
	
//store
	case(op_code)
		`StoreByte:begin
			case(rwaddr[1:0])
				2'b00:begin 
					d[ 7: 0] = wdata[7:0];
					bwen = 32'h0000_0011;
				end
				2'b01:begin
					d[15: 8] = wdata[7:0];
					bwen = 32'h0000_1100;
				end
				2'b10:begin 
					d[23:15] = wdata[7:0];
					bwen = 32'h0011_0000;
				end 
				2'b11:begin 
					d[31:24] = wdata[7:0];
					bwen = 32'h1100_0000;
				end
			endcase
		end
		`StoreHalfWord:begin
			if(rwaddr[1]==0)begin
				d[15: 0] = wdata[15:0];
				bwen = 32'h0000_1111;
			end
			else begin
				d[31:16] = wdata[15:0];
				bwen = 32'h1111_0000;
			end
		end
		`StoreWord:begin 
			d = wdata;
			bwen = 32'h1111_1111;
		end
		default:begin 
			d = wdata;
			bwen = 32'h0000_0000; // looks like do nothing
		end
	endcase
end

//output MUX
always@(posedge clk or negedge nrst)begin 
	if (~nrst)	rwaddr_r <= 11'b0;       
	else 		rwaddr_r <= rwaddr;  
end
always@(*)begin		//rwaddr_r[10]==0 choose mem1, rwaddr_r[10]==1 choose mem2
	if(rwaddr_r[10] == 0)	q = q_1;
	else					q = q_2;
end

always@(*)begin
	cen_1 = 1;
	cen_2 = 1;
	if(stall) ;	    //stall == 1, do nothing, maintain cen = 1
	else begin		//rwaddr[10]==0 choose mem1, rwaddr[10]==1 choose mem2
		if(rwaddr[10] == 0)	cen_1 = 0;
		else				cen_2 = 0;
	end
end

endmodule
