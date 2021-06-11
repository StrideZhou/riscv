//author:梁根源,stride
//存储器读写模块
//read operation:
`define LoadByte      (3'b000)
`define LoadHalfWord  (3'b001)
`define LoadWord      (3'b010)
//write operation:
`define StoreByte     (3'b100)
`define StoreHalfWord (3'b101)
`define StoreWord     (3'b110)

`include "mem.v"
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
wire [31:0] q_1;       //q_1,q_2为两个寄存器上输出信号
wire [31:0] q_2;
reg [31:0] q_all;         //q_all为从q_1,q_2中选择出的信号
reg [31:0] d_1;
reg [31:0] d_2;
reg [31:0] d_all;        //d_all为从wdata得到的信号，再经过选择信号输给对应mem
reg [31:0] bwen;
wire      wen;
reg      cen_1;
reg      cen_2;

reg [10:0] rwaddr_r;

assign  wen=~op_code[2]; //wen低电平有效，进入写过程

 mem  mem1( .clk (clk),
            .cen (cen_1),
            .wen (wen),
            .bwen(bwen),
            .a   (rwaddr[9:2]),
            .d   (d_1),
            .q   (q_1)
			 );

 mem  mem2( .clk (clk),
            .cen (cen_2),
            .wen (wen),
            .bwen(bwen),
            .a   (rwaddr[9:2]),
            .d   (d_2),
            .q   (q_2)
			 );

always @(*) begin
	case(op_code)
    	`LoadByte:begin
			case(rwaddr[1:0])
				2'b00:rdata = {{24{q_all[ 7]}},{q_all[ 7: 0]}};
				2'b01:rdata = {{24{q_all[15]}},{q_all[15: 8]}};
				2'b10:rdata = {{24{q_all[23]}},{q_all[23:16]}};
				2'b11:rdata = {{24{q_all[31]}},{q_all[31:24]}};
			endcase
		end
    	`LoadHalfWord:begin
			if (rwaddr[1]==0)	rdata = {{16{q_all[15]}},q_all[15: 0]};	 
			else				rdata = {{16{q_all[31]}},q_all[31:16]};
		end
    	`LoadWord:	rdata = q_all;
		default:	rdata = q_all;
	endcase
	
//store
	case(op_code)
		`StoreByte:begin
			case(rwaddr[1:0])
				2'b00:begin 
					d_all[ 7: 0] = wdata[7:0];
					bwen = 32'h0000_0011;
				end
				2'b01:begin
					d_all[15: 8] = wdata[7:0];
					bwen = 32'h0000_1100;
				end
				2'b10:begin 
					d_all[23:15] = wdata[7:0];
					bwen = 32'h0011_0000;
				end 
				2'b11:begin 
					d_all[31:24] = wdata[7:0];
					bwen = 32'h1100_0000;
				end
			endcase
		end
		`StoreHalfWord:begin
			if(rwaddr[1]==0)begin
				d_all[15: 0] = wdata[15:0];
				bwen = 32'h0000_1111;
			end
			else begin
				d_all[31:16] = wdata[15:0];
				bwen = 32'h1111_0000;
			end
		end
		`StoreWord:begin 
			d_all = wdata;
			bwen = 32'h1111_1111;
		end
		default:begin 
			d_all = wdata;
			bwen = 32'h0000_0000;
		end
	endcase
end

//输入MUX
always@(*)begin		//rwaddr[10]=0选择第一片memory，rwaddr[10]=1选择第二片memory
	if(rwaddr[10] == 0)	d_1 = d_all;
	else 				d_2 = d_all;
end
//输出MUX
always@(posedge clk or negedge nrst)begin 
	if (~nrst)	rwaddr_r <= 11'b0;       
	else 		rwaddr_r <= rwaddr;  
end
always@(*)begin		//rwaddr_r[10]=0选择第一片memory，rwaddr_r[10]=1选择第二片memory
	if(rwaddr_r[10] == 0)	q_all = q_1;
	else					q_all = q_2;
end

always@(*)begin
	if(stall)begin	//stall为1时不进行读写操作
		cen_1 = 1;
		cen_2 = 1;
	end
	else begin		//rwaddr[10]=0选中cen_1 = 0,rwaddr[10]=1选中cen_2 = 0
		if(rwaddr[10] == 0)begin     
			cen_1 = 0;
			cen_2 = 1;
		end
		else begin
			cen_1 = 1;
			cen_2 = 0;
		end
	end
end

endmodule
