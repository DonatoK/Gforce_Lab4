module testing;


reg [5:0] sample_op;
wire regdst;
wire branch;
wire memtoread;
wire memtoreg;
wire [1:0] aluop;
wire memtowrite;
wire alusrc;
wire regwrite;

controls mycontrol(sample_op,regdst,branch,memtoread,memtoreg,aluop,memtowrite,alusrc,regwrite);

initial begin
#2 sample_op = 0;
#2 $display("%d,%d,%d,%d,%d,%d,%d,%d",regdst,branch,memtoread,memtoreg,aluop,memtowrite,alusrc,regwrite);
#2 sample_op = 35;
#2 $display("%d,%d,%d,%d,%d,%d,%d,%d",regdst,branch,memtoread,memtoreg,aluop,memtowrite,alusrc,regwrite);
#2 sample_op = 43;
#2 $display("%d,%d,%d,%d,%d,%d,%d,%d",regdst,branch,memtoread,memtoreg,aluop,memtowrite,alusrc,regwrite);

end



endmodule
