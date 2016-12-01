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
mycpu.memcpu.mem_file[0] = 10;//a
mycpu.memcpu.mem_file[1] = 22;//b
mycpu.memcpu.mem_file[2] = 6;//c
end


always
#1 Clock = ~Clock;
//#30 Reset = ~Reset;
// d = a+b-c
initial
  begin
  //#1 Reset =1;
  //#1 Reset = 0;

  Instrword = 32'b10001100000000010000000000000000;    //load a to  r1, 35,0,0,0
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 1: %d",mycpu.registerfilecpu.regfile[1]);
  $display("Register 2: %d",mycpu.registerfilecpu.regfile[2]);
  Instrword = 32'b10001100000000100000000000000001; //load b
  #1 Reset = ~Reset;
  #1 Reset = ~Reset;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  Instrword = 32'b10001100000000110000000000000010;
  #1 Reset = ~Reset;
  #1 Reset = ~Reset;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 1: %d",mycpu.registerfilecpu.regfile[1]);
  $display("Register 2: %d",mycpu.registerfilecpu.regfile[2]);





  $finish;
end

initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(0,testybench);
 end
endmodule
