module mem( clk,
            cen,
            wen,
            bwen,
            a,
            d,
            q);

input clk;
input cen;
input wen;
input[31:0]bwen;
input[7:0]a;
input[31:0]d;
output[31:0]q;
reg [31:0]  q;

reg [31:0]mem[255:0];    //1KB memory;

always@ (posedge clk)begin
    if(cen==1)begin
        q<=32'b0000_0000;
    end
    else if(wen==1)begin
        q<=mem[a];
    end
    else begin
        q<=32'h0000_0000;
	 end
end

integer i;
	initial begin
	    for(i=0; i<256;i=i+1) begin
	        mem[i] = 32'h0000_0000;
	    end
	end

always@(posedge clk)begin
    if((cen==0)&&(wen==0))begin
        mem[a][0]<=bwen[0]?d[0]:mem[a][0];
        mem[a][1]<=bwen[1]?d[1]:mem[a][1];
        mem[a][2]<=bwen[2]?d[2]:mem[a][2];
        mem[a][3]<=bwen[3]?d[3]:mem[a][3];
        mem[a][4]<=bwen[4]?d[4]:mem[a][4];
        mem[a][5]<=bwen[5]?d[5]:mem[a][5];
        mem[a][6]<=bwen[6]?d[6]:mem[a][6];
        mem[a][7]<=bwen[7]?d[7]:mem[a][7];
        mem[a][8]<=bwen[8]?d[8]:mem[a][8];
        mem[a][9]<=bwen[9]?d[9]:mem[a][9];
        mem[a][10]<=bwen[10]?d[10]:mem[a][10];
        mem[a][11]<=bwen[11]?d[11]:mem[a][11];
        mem[a][12]<=bwen[12]?d[12]:mem[a][12];
        mem[a][13]<=bwen[13]?d[13]:mem[a][13];
        mem[a][14]<=bwen[14]?d[14]:mem[a][14];
        mem[a][15]<=bwen[15]?d[15]:mem[a][15];
        mem[a][16]<=bwen[16]?d[16]:mem[a][16];
        mem[a][17]<=bwen[17]?d[17]:mem[a][17];
        mem[a][18]<=bwen[18]?d[18]:mem[a][18];
        mem[a][19]<=bwen[19]?d[19]:mem[a][19];
        mem[a][20]<=bwen[20]?d[20]:mem[a][20];
        mem[a][21]<=bwen[21]?d[21]:mem[a][21];
        mem[a][22]<=bwen[22]?d[22]:mem[a][22];
        mem[a][23]<=bwen[23]?d[23]:mem[a][23];
        mem[a][24]<=bwen[24]?d[24]:mem[a][24];
        mem[a][25]<=bwen[25]?d[25]:mem[a][25];
        mem[a][26]<=bwen[26]?d[26]:mem[a][26];
        mem[a][27]<=bwen[27]?d[27]:mem[a][27];
        mem[a][28]<=bwen[28]?d[28]:mem[a][28];
        mem[a][29]<=bwen[29]?d[29]:mem[a][29];
        mem[a][30]<=bwen[30]?d[30]:mem[a][30];
        mem[a][31]<=bwen[31]?d[31]:mem[a][31];
    end
end

endmodule
