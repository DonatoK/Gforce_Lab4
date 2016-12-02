/*

G-Force CPU Test Bench

Test bench will operate the following C statement: d = a+b-c

where a,b,c are in memory and the result d will be stored in memory.

*/

module CPU_tb();

reg Reset, Clock, Newinstr;
reg [31:0] Instrword;


mipscpu mycpu(
  Reset,
  Clock,
  Instrword,
	Newinstr);


//Initialize inputs and memory
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

//Initialize the Clock
always #1 Clock = ~Clock;

initial
  begin

  //  lw $1,0($0)
  Instrword = 32'b10001100000000010000000000000000;
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 1: %d",mycpu.registerfilecpu.regfile[1]);

  // lw $2,1($0)
  Instrword = 32'b10001100000000100000000000000001; //load b to r2 32,0,1,1
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 2: %d",mycpu.registerfilecpu.regfile[2]);


  // lw $3,2($0)
  Instrword = 32'b10001100000000110000000000000010;//load c to r3 32,0,2,2
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 3: %d",mycpu.registerfilecpu.regfile[3]);

  // add $4,$1,$2
  Instrword = 32'b00000000001000100010000000100000;  //Instructions for r1+r3 = R4
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;

  $display("Register 4: %d",mycpu.registerfilecpu.regfile[4]);

  // sub $5,$4,$3
  Instrword = 32'b00000000100000110010100000100010;  //Instructions for r4-r2=r5
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;
  $display("Register 5: %d",mycpu.registerfilecpu.regfile[5]); //


  // sw $5,3($0)
  #1Instrword = 32'b10101100000001010000000000000011; //Stores 26 to d in memort
  Newinstr = 0;
  #1 Newinstr = 1;
  #1 Newinstr = 0;
  #10;

  $display("Memory value d: %d",mycpu.memcpu.mem_file[3]);


  $finish;
end

initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(0,CPU_tb);
 end
endmodule
