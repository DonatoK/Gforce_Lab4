/*
This files will contain all components that the CPU has inside of it
It will also be used to start putting things to gether.

*/


/* ALU Control - by Kevin Valdez
 Takes ALUOp code from control and read function instruction and sets out
 Alu control code to tell alu which operation to do. */
module ALUControl (ALUOp , Function , Output);

  input  wire  [1:0] ALUOp;
  input  wire  [5:0] Function;
  output reg   [3:0] Output;

  always @(ALUOp or Function)
  begin
  	case(ALUOp)

  	0: begin
  		 $display("ALUOp = 00");
  		 Output = 4'b0010;
  	   end
  	1: begin
  		 $display("AlUOp = 01");
  		 Output = 4'b0110;
         end
  	2: begin
  		 $display("ALUOp = 10");
  		 if (Function == 6'b100000)
  		    begin
  			Output = 4'b0010; // add
  			$display("add");
  			end
  		 else if(Function == 6'b100010)
  			begin
  			Output = 4'b0110; // subtract
  			$display("sub");
  			end
  		 else if(Function == 6'b100100)
  		    begin
  			Output = 4'b0000; // and
  			$display("and");
  			end

  		 else if(Function == 6'b100101)
  		    begin
  			Output = 4'b0001; // or
  			$display("or");
  			end
  		 else if(Function == 6'b101010)
  		    begin
  			Output = 4'b0111; // SLT (set less than)
  			$display("slt");
  			end
         end

  	endcase

  end

  endmodule

/* Data Path Muxes - by Kevin Valdez
   Multiplexers that are part of the cpu datapah that are controlled by
   the control signals RegDst, ALUSrc, MemtoReg.
*/
module muxRegDestination(input1,input2, RegDestination ,outputval);
  input wire [5:0] input1;
  input wire [5:0] input2;
  output wire[5:0] outputval;
  input wire RegDestination;

  assign outputval = (RegDestination)? input1 : input2;

  endmodule
  /******************************************************************************************************************************************/
module muxALUSrc (result, result2, ALUSrc , outputval2 );

  input wire [31:0] result;
  input wire [31:0] result2;
  output wire[31:0] outputval2;
  input wire ALUSrc;

  assign outputval2 = (ALUSrc)? result: result2;

  endmodule
  /********************************************************************************************************************************************/
module muxMemtoReg (solution, solution2 , memtoReg , outputval3);
  input wire  [31:0] solution;
  input wire  [31:0] solution2;
  input wire memtoReg;
  output wire [31:0] outputval3;


  assign outputval3 = (memtoReg)? solution: solution2;

  endmodule

/*Instruction Memory - by Donato Kava
  Slices up the instruction we give to cpu into 6 parts.*/
module instructmem(
    input wire [31:0]  inputVal,
    output wire [31:26] instruct1,
    output wire [25:21] instruct2,
    output wire [20:16] instruct3,
    output wire [15:11] instruct4,
    output wire [15:0]  instruct5,
    output wire [5:0]   instruct6);
    //instruction mememory, takes register input(program instruction)
    //and splits it up 6 parts

    //registers to hold wire data
    reg [5:0]  inInstruct1;
    reg [4:0]  inInstruct2;
    reg [4:0]  inInstruct3;
    reg [4:0]  inInstruct4;
    reg [15:0] inInstruct5;
    reg [5:0]  inInstruct6;
    //always sets inputval bits to their internal regs
    always
    begin
    #1
    inInstruct1 = inputVal[31:26];
    inInstruct2 = inputVal[25:21];
    inInstruct3 = inputVal[20:16];
    inInstruct4 = inputVal[15:11];
    inInstruct5 = inputVal[15:0];
    inInstruct6 = inputVal[5:0];
    end
    //set wires to internal registers
    assign  instruct1 = inInstruct1;
    assign  instruct2 = inInstruct2;
    assign  instruct3 = inInstruct3;
    assign  instruct4 = inInstruct4;
    assign  instruct5 = inInstruct5;
    assign  instruct6 = inInstruct6;

    endmodule

/* Control - by Luis Santos

   Takes the Opcode sent to it and sends
   output signals dependant for the Opcode.
*/
module control(
  input wire clock,
  input wire [5:0]  Opcode,
  output reg RegDst,
  output reg Branch,
  output reg MemtoRead,
  output reg MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemtoWrite,
  output reg ALUSrc,
  output reg RegWrite);
/*
*This module sets the control signals for the control Path
*
*The Signals are dependant on the opcode given


*/

  always@(Opcode) begin
      case (Opcode)
        0 : begin
            RegDst = 1;
            Branch = 0;
            MemtoReg = 0;
            ALUOp = 2;
            ALUSrc = 0;
            end
        35:begin
            RegDst = 0;
            ALUSrc = 1;
            MemtoReg = 1;
            Branch = 0;
            ALUOp = 0;
            end
        43:begin
            ALUSrc = 1;
            RegWrite = 0;
            MemtoRead = 0;
            MemtoWrite = 1;
            Branch = 0;
            ALUOp = 0;
           end

        endcase
      end

  always@(posedge clock) begin
        case(Opcode)
          0: begin
              MemtoRead <= 0;
              MemtoWrite <= 0;
              RegWrite <= 1;
              end
          35: begin
              MemtoRead <= 1;
              MemtoWrite <= 0;
              RegWrite <= 1;
              end
          43: begin
              MemtoRead <= 0;
              MemtoWrite <= 1;
              RegWrite <= 0;
              end
          endcase
        end
endmodule

/* Data Memory - Eberado Sanchez*/

module Memory (wrctrl,rdctrl,addr,wrdata,rddata);

    	input wire wrctrl,rdctrl;
    	input wire [31:0] addr;
      input wire [31:0] wrdata;
      output reg [31:0] rddata;

    	reg [31:0] mem_file[0:127];



  always @(posedge wrctrl or posedge rdctrl) begin
    rddata = (rdctrl) ? mem_file[addr]:0;
    mem_file[addr] = (wrctrl) ? wrdata:0;

 end

    endmodule

/* ALU component*/
module alu(
      input wire [31:0] op1,
      input wire [31:0] op2,
      input wire [3:0] ctrl,
      output reg [31:0] result
      );

      //Trigger when ctrl changes values
      //Can change the blocking statements to nonblocking statements
      //However changes in the testbench will be required(remove #'s , except for the op1)
      always@(ctrl) begin
        case(ctrl)
          //Instructions as shown in table in pg 259
          0 : result = op1 & op2;
          1 : result = op1 | op2;
          2 : result = op1 + op2;
          6 : result = op1 - op2;
          7 : result = op1 < op2;
          12: result = ~(op1|op2);
          default: result = 0;  //Read that most ALUs have a 0 when
                                // no valid operation was chosen
        endcase
      end
    endmodule

/*Register file component*/
module registerfile(
      input wire [4:0] readReg1,
      input wire [4:0] readReg2,
      input wire [4:0] writeReg,
      input wire [31:0] writeData,
      input wire regWrite,
      output reg [31:0] readData1,
      output reg [31:0] readData2);

    //used to make a array of 32 32-bit registers
    reg [31:0] regfile[31:0];

    //Registerfile will always read registers but will only write to them when
    //regWrite is set.
    always @ (readReg1,readReg2,regWrite) begin
      readData1 = regfile[readReg1];
      readData2 = regfile[readReg2];
      if(regWrite == 1)
        regfile[writeReg] = writeData;


    end
    endmodule

//Sign extend component
module signextend(inputVal,outputVal);

    input [15:0] inputVal;
    wire  [15:0] inputVal;
    output[31:0] outputVal;
    wire  [31:0] outputVal;

    assign outputVal = {{16{inputVal[15]}} , inputVal}; // 16 bit to 32 extension preserving the sign

    endmodule

/*Main mipscpu*/
module mipscpu(
    input wire reset,
    input wire clock,
    input wire [31:0] instrword,
    input wire newinstr);

// Made wires to store the output signals
    wire [31:26] opcodecpu;
    wire [25:21] readReg1cpu;
    wire [20:16] readReg2cpu;
    wire [15:11] mux1rdcpu;
    wire [15:0] signExtendercpu;
    wire [5:0] alufunctioncpu;
    // Made some output wires for the control signals
    wire regdstcpu;
    wire branchcpu;
    wire memreadcpu;
    wire memtoregcpu;
    wire [1:0] aluopcpu;
    wire memwritecpu;
    wire alusrccpu;
    wire regwritecpu;
    wire [31:0] op2alu;
    wire [31:0] outputtoregwrite;
    wire [3:0] aluctrltoalu;
    wire [31:0] aluresultcpu;

//Connecting instruction to instruction memory
instructmem insmemcpu(
        instrword,  //From testbench
        opcodecpu,  //Goes to control
        readReg1cpu, //Goes to register file
        readReg2cpu, //Goes to register file and mux
        mux1rdcpu,   //Rd address to mux
        signExtendercpu, //
        alufunctioncpu);



/*Inputs opcode made by instructmem and assign signals based on opcode
Signal names can be used on other devices to connect them together*/
control controlcpu(
  clock,
  opcodecpu,
  regdstcpu,
  branchcpu,
  memreadcpu,
  memtoregcpu,
  aluopcpu,
  memwritecpu,
  alusrccpu,
  regwritecpu);


/*Connect RegDest signal from control and the other parts of instruction word to mux
that later connects to register file*/
muxRegDestination muxRegDestcpu(
  readReg2cpu,
  mux1rdcpu,
  regdstcpu,
  towriteregistercpu);




//Decides if wether or not alu will use offset .
muxALUSrc muxAlusrccpu(
  readdata2cpu,
  signextresultcpu,
  alusrccpu,
  op2alu);


/*This mux will decide if either the value to be written back to register file
is either the result from alu, or from memory.*/
muxMemtoReg muxmemtoregcpu(
  readdata,
  aluresult,
  memtoregcpu,
  outputtoregwrite
  );



ALUControl alucontrolcpu(
  aluopcpu,
  alufunctioncpu,
  aluctrltoalu);


//In here replace readdata1cpu with register file read data 1 output name
alu alucpu(
  readdata1c0pu,
  op2alu,
  aluctrltoalu,
  aluresultcpu);



registerfile registerfilecpu(
  readReg1cpu,
  readReg2cpu,
  towriteregistercpu,
  outputtoregwrite,
  regwritecpu,
  readdata1cpu,
  readdata2cpu
  );


signextend cpusignextende(
  signextedcpu,
  signextresultcpu
  );

Memory memcpu(
  memwritecpu,
  memreadcpu,
  aluresultcpu,
  readdata2cpu,
  readdata
  );




endmodule
