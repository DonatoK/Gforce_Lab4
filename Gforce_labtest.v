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


always #1 Clock = ~Clock;
always #2 Reset = ~Reset;
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
  Instrword = 32'b10001100000000100000000000000001; //load b to r2 32,0,1,1
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 2: %d",mycpu.registerfilecpu.regfile[2]); //load c to r3 32,0,2,2
  Instrword = 32'b10001100000000110000000000000010;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
$display("Register 3: %d",mycpu.registerfilecpu.regfile[3]);

  //add 22 + 10 = 32
  Instrword = 32'b00000000001000100010000000100000;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;

  $display("Register 4: %d",mycpu.registerfilecpu.regfile[4]);
  Instrword = 32'b00000000001000100010000000100000;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 4: %d",mycpu.registerfilecpu.regfile[4]);

  /*
  #1Instrword = 32'b00000000100000110010100000100010;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;

  $display("Register 5: %d",mycpu.registerfilecpu.regfile[5]);
  */

  $finish;
end

initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(0,testybench);
 end
endmodule
