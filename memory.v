//author:梁根源
//存储器读写模块
module memory (clk,
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
input [13:0] rwaddr;
input [31:0] wdata;
output[31:0] rdata;

reg [31:0]rdata;
wire [31:0]q_1;       //q_1,q_2为两个寄存器上输出信号
wire [31:0]q_2;
reg [31:0]q_all;         //q_all为从q_1,q_2中选择出的信号
reg [31:0]d_1;
reg [31:0]d_2;
reg [31:0]d_all;        //d_all为从wdata得到的信号，再经过选择信号输给对应mem
reg [31:0]bwen;
wire      wen;
reg      cen_1;
reg      cen_2;

//read operation:
//Load Byte=000
//Load half word=001
//Load word=010

//write operation:
//Store Byte=100
//Store half word=101
//Store word=111

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


always@(*)begin
    if(op_code==3'b100)begin
        bwen=32'h0000_0011;
    end
    else if(op_code==3'b101)begin
        bwen=32'h0000_1111;
    end
    else if(op_code==3'b111)begin
        bwen=32'h1111_1111;
    end
    else begin
        bwen=32'h0000_0000;
    end
end
always@(posedge clk or negedge nrst) begin
	if(!nrst)begin
		rdata<=32'b0;
	end
	else begin
    case(op_code)
    	3'b000:begin//load_byte
					case(rwaddr[1:0])
        			2'b00:rdata<={{24{q_all[7]}},{q_all[7:0]}};
        			2'b01:rdata<={{24{q_all[15]}},{q_all[15:8]}};
        			2'b10:rdata<={{24{q_all[23]}},{q_all[23:16]}};
        			2'b11:rdata<={{24{q_all[31]}},{q_all[31:24]}};
					endcase
				 end
    	3'b001:begin//load_halfword
        		if (rwaddr[1]==0) 
					rdata <={{16{q_all[15]}},q_all[15:0]};	 
        		else 		
					rdata <={{16{q_all[31]}},q_all[31:16]};
				 end
    	3'b010:begin//load word
        	      rdata <= q_all;
				 end
	 endcase
	end
end
	
				 
always@(posedge clk or negedge nrst) begin
	if(!nrst)begin
		d_all<=32'b0;
	end
	else begin
		case(op_code)
		3'b100:begin//store byte
					case(rwaddr[1:0])
					2'b00:d_all[7:0]  <=wdata[7:0];
					2'b01:d_all[15:8] <=wdata[7:0];
					2'b10:d_all[23:15]<=wdata[7:0];
					2'b11:d_all[31:24]<=wdata[7:0];
					endcase
				 end
		3'b101:begin//store half byte
					if(rwaddr[1]==0)
						d_all[15:0]<=wdata[15:0];
					else
						d_all[31:16]<=wdata[15:0];
				end
		3'b111:begin//store word
					d_all<=wdata;
				 end
	   default:d_all<=32'h00000000;
		endcase
	end
end



always@(posedge clk or negedge nrst)begin        
    if(!nrst)begin
		  q_all<=32'h00000000;
	 end
	 else begin
		if(rwaddr[12]==0)begin      //rwaddr[12]=0选择第一片memory，rwaddr[12]=1选择第二片memory
			q_all<=q_1;
		end
		else begin
			q_all<=q_2;
		end
	 end
end

always@(posedge clk or negedge nrst)begin        
    if(!nrst)begin
        d_1<=32'h00000000;
		  d_2<=32'h00000000;
	 end
	 else begin
		if(rwaddr[12]==0)begin      //rwaddr[12]=0选择第一片memory，rwaddr[12]=1选择第二片memory
			d_1<=d_all;
		end
		else begin
			d_2<=d_all;
		end
	 end
end


always@(*)begin
	if(stall)begin   //stall为1时不进行读写操作
		cen_1=1;
		cen_2=1;
	end
	if((rwaddr[10]==1)&&(rwaddr[11]==0))begin        //rwaddr[10]=1选中cen_1,rwaddr[11]=1选中cen_2
			cen_1=0;
		end
		else if((rwaddr[10]==0)&&(rwaddr[11]==1))begin
			cen_2=0;
		end
		else begin
			cen_1=1;
			cen_2=1;
		end
end


	
endmodule
