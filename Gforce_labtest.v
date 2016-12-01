module testybench();
//input registers

//output reading register
reg Reset, Clock, Newinstr;
reg [31:0] Instrword;


mipscpu mycpu(
  Reset,
  Clock,
  Instrword,
	Newinstr);

 //mipscpu.mycpu.mem_file[0] = 10; //a = 10



initial
begin
Reset = 0;
Clock = 0;
Instrword = 0;
Newinstr = 0;
end


always
 #1 Clock = ~Clock;
// d = a+b-c
initial
  begin
  //#1 Reset =1;
  //#1 Reset = 0;
  #30;

  mycpu.memcpu.mem_file[0] = 10;//a

  mycpu.memcpu.mem_file[1] = 22;//b
  mycpu.memcpu.mem_file[2] = 6;//c

  Instrword = 32'b10001100000000010000000000000000;    //load a to  r1, 35,0,0,0
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("REG %h",mycpu.registerfilecpu.writeReg);
  $display("REG %h",mycpu.registerfilecpu.regfile[1]);
  #1 Reset =1;
  #1 Reset = 0;
  Instrword = 32'b10001100000000100000000000000001; //load b
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #1 $display("OP1",mycpu.alucpu.op1);
  #1 $display("OP1",mycpu.insmemcpu.instruct2);
  #10;
  $display("REG %h",mycpu.registerfilecpu.regfile[1]);
  #1 Reset =1;
  #1 Reset = 0;
  Instrword = 32'b10001100000000110000000000000010;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("REG %h",mycpu.registerfilecpu.regfile[2]);




  $finish;
end

initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(0,testybench);
 end


endmodule
