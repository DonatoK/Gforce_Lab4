/*
G-Force CPU component files


Contains:
    ALU - Does add,sub,or,lw,sw
    control - control mux signals
    ALUControl - takes signal from control and function field and output alu op code
    muxALUSrc - chooses the second operator for the ALU
    muxMemtoReg - chooses either the output of the memory or alu to send to registerfile for writing
    muxRegDestination - chooses either rt field or rd field to write in register file
    memory - contains values of alu result if written into
    registerfile - contains registers
    signextend - makes 16 bit input to 32 bit result
    instructmem - Will split the instructions work to difference sizes
*/

/* ALU Control - by Kevin Valdez
 Takes ALUOp code from control and read function instruction and sets out
 Alu control code to tell alu which operation to do. */
module ALUControl (ALUOp , Function , Output);

  input  wire  [1:0] ALUOp;
  input  wire  [5:0] Function;
  output reg   [3:0] Output;

  always @(ALUOp)
  begin
    #3;
  	case(ALUOp)

  	0: begin
  		 Output = 4'b0010;
  	   end
  	2: begin

  		 if (Function == 6'b100000)
  		    begin
  			Output = 4'b0010; // add

  			end
  		 else if(Function == 6'b100010)
  			begin
  			Output = 4'b0110; // subtract

  			end
  		 else if(Function == 6'b100100)
  		    begin
  			Output = 4'b0000; // and

  			end

  		 else if(Function == 6'b100101)
  		    begin
  			Output = 4'b0001; // or
  			end
  		 else if(Function == 6'b101010)
  		    begin
  			Output = 4'b0111; // SLT (set less than)
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
  input wire [4:0] input1;
  input wire [4:0] input2;
  output wire[4:0] outputval;
  input wire RegDestination;

  assign outputval = (RegDestination)? input2 : input1;

  endmodule
  /******************************************************************************************************************************************/
module muxALUSrc (result, result2, ALUSrc , outputval2 );

  input wire [31:0] result;
  input wire [31:0] result2; //offset
  output wire[31:0] outputval2;
  input wire ALUSrc;

  assign outputval2 = (ALUSrc)? result2: result;

  endmodule
  /********************************************************************************************************************************************/
module muxMemtoReg (solution, solution2 , memtoReg , outputval3);
  input wire  [31:0] solution;
  input wire  [31:0] solution2;
  input wire memtoReg;
  output wire [31:0] outputval3;

    reg [31:0] inoutpu;
  always@(solution or solution2) begin
     inoutpu = (memtoReg) ? solution2:solution;
  end

  assign outputval3 = inoutpu;

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
    output wire [5:0]   instruct6,
    input wire newinstruction
    );

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

    always@(negedge newinstruction)
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

/* Control - started by Luis Santos
    Finished by the whole group

   Takes the Opcode sent to it and sends
   output signals dependant of the Opcode.
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
  output reg RegWrite,
  input wire newinstr,
  input wire rst);

  always@(posedge rst or posedge newinstr) begin
  #1MemtoRead = 0;
  #1MemtoWrite = 0;
  #1RegWrite = 0;
  #1RegDst = 0;
  #1Branch = 0;
  #1MemtoReg = 0;
  #1ALUOp = 0;
  #1ALUSrc = 0;
  end

  always@(posedge clock) begin
      case (Opcode)
        0 : begin
        RegDst = 1;
        Branch = 0;
        MemtoReg = 1;
        ALUOp = 2;
        ALUSrc = 0;
            end
      35:begin
            RegDst = 0;
            ALUSrc = 1;
            MemtoReg = 0;
            Branch = 0;
            ALUOp = 0;

            end
      43:begin
            ALUSrc = 1;
            Branch = 0;
            ALUOp = 0;
           end

        endcase
      end

  always@(posedge clock) begin
        case(Opcode)
          0: begin
              MemtoRead <= 0;
              RegWrite<=1;
              end
          35: begin
              MemtoRead <= 1;
              RegWrite <= 1;
              end
          43: begin
              MemtoRead <= 0;
              RegWrite <= 0;
              end
          endcase
        end

  always@(negedge clock) begin
    case(Opcode)
    0: begin
      MemtoWrite<=0;

      end
    35: begin
      MemtoWrite<=0;

      end
    43: begin
      #5;
      MemtoWrite <= 1;
        end
    endcase
  end
endmodule

/* Data Memory - Eberado Sanchez*/
module Memory (wrctrl,rdctrl,addr,wrdata,rddata,rst);

    	input wire wrctrl,rdctrl;
    	input wire [31:0] addr;
      input wire [31:0] wrdata;
      output reg [31:0] rddata;
      input rst;
    	reg [31:0] mem_file[0:127];
      integer i;

  initial begin
      for(i=0;i<128;i=i+1)
        begin
          mem_file[i] = 32'b0;
        end
  end

  always@(posedge rst) begin
    for(i=0;i<128;i=i+1)
      begin
        mem_file[i] = 32'b0;
      end
    end

  always @(posedge rdctrl) begin
    rddata = (rdctrl) ? mem_file[addr][31:0]:0;

 end

  always @(posedge wrctrl) begin
      mem_file[addr] = (wrctrl) ? wrdata:0;
   end
   endmodule

/* ALU */
module alu(
      input wire [31:0] op1,
      input wire [31:0] op2,
      input wire [3:0] ctrl,
      output reg [31:0] result3
      );

      //Trigger when ctrl changes values
      //Can change the blocking statements to nonblocking statements
      //However changes in the testbench will be required(remove #'s , except for the op1)

      always@(*) begin
        case(ctrl)
          //Instructions as shown in table in pg 259
          0 : result3 = op1 & op2;
          1 : result3 = op1 | op2;
          2 : result3 = op1 + op2;
          6 : result3 = op1 - op2;
          7 : result3 = op1 < op2;
          12: result3 = ~(op1|op2);
          default: result3 = 0;  //Read that most ALUs have a 0 when
                                // no valid operation was chosen
        endcase
      end
    endmodule

/*Register File*/
module registerfile(
      input wire [4:0] readReg1,
      input wire [4:0] readReg2,
      input wire [4:0] writeReg,
      input wire [31:0] writeData,
      input wire regWrite,
      output reg [31:0] readData1,
      output reg [31:0] readData2,
      input wire rst
      );

    //used to make a array of 32 32-bit registers
    reg [31:0] regfile[31:0];
    integer i;
    //Registerfile will always read registers but will only write to them when
    //regWrite is set.

    initial begin
        for(i=0;i<32;i=i+1)
          begin
            regfile[i] = 32'b0;
          end
    end

    always@(posedge rst) begin
      for(i=0;i<32;i=i+1)
        begin
          regfile[i] = 32'b0;
        end
      end

      always@(readReg1 or readReg2) begin
        readData1 = regfile[readReg1];
        readData2 = regfile[readReg2];
      end

    always@(*) begin
      if(regWrite) regfile[writeReg] = writeData;

    end
    endmodule



//Sign Extend
module signextend(inputVal,outputVal);

    input [15:0] inputVal;
    output [31:0] outputVal;

    assign outputVal = {{16{inputVal[15]}} , inputVal}; // 16 bit to 32 extension preserving the sign

    endmodule

/*Main mipscpu*/
module mipscpu(
    input wire reset,
    input wire clk,
    input wire [31:0] instrword,
    input wire newinstr);


    // Instructmem outpus
    wire [31:26] opcodecpu;  //to control
    wire [25:21] readReg1cpu; //to register file readReg1
    wire [20:16] readReg2cpu; //to register file readReg2 and muxRegDestcpu
    wire [15:11] mux1rdcpu;   //to muxRegDestcpu
    wire [15:0] signExtendercpu; //to signextend
    wire [5:0] alufunctioncpu; //to ALUControl

    //Control Signal outputs
    wire regdstcpu; //to muxRegDestcpu
    wire branchcpu; //unused signal
    wire memreadcpu;  // to memory MemtoRead port
    wire memwritecpu; // to memort MemtoRead port
    wire memtoregcpu; // to muxMemtoReg
    wire [1:0] aluopcpu; //to ALUControl
    wire alusrccpu; //to muxALUSrc
    wire regwritecpu; //to registerfile


    //List of wires that interconnect to eachother

    wire [31:0] op2alu;         // from muxALUSrc to ALU port 2
    wire [31:0] outputtoregwrite; //from muxMemtoReg to Registerfile port 4
    wire [3:0] aluctrltoalu;   // from ALUControl to ALU port 3
    wire [31:0] aluresultcpu;     //from alu to memory port 3 and muxMemtoReg port 2
    wire [31:0] readdata1cpu;  //from registerfile to ALU port 1
    wire [31:0] readdata2cpu;      //from registerfile to muxALUSrc port 1
    wire [31:0] signextresultcpu;//from signexted to muxALUsrc port 2
    wire [31:0] readdata;           //from memory to muxMemtoReg port1
    wire [4:0] towriteregistercpu;     //from muxMemtoReg to registerfile port 3
    wire [15:0] signextedcpu;     //from Instructmem to signextend



  instructmem insmemcpu(
          instrword,
          opcodecpu,
          readReg1cpu,
          readReg2cpu,
          mux1rdcpu,
          signExtendercpu,
          alufunctioncpu,
          newinstr);


  control controlcpu(
    clk,
    opcodecpu,
    regdstcpu,
    branchcpu,
    memreadcpu,
    memtoregcpu,
    aluopcpu,
    memwritecpu,
    alusrccpu,
    regwritecpu,
    newinstr,
    reset);

  muxRegDestination muxRegDestcpu(
    readReg2cpu,
    mux1rdcpu,
    regdstcpu,
    towriteregistercpu);

  muxALUSrc muxAlusrccpu(
    readdata2cpu,
    signextresultcpu,
    alusrccpu,
    op2alu);

  muxMemtoReg muxmemtoregcpu(
    readdata,
    aluresultcpu,
    memtoregcpu,
    outputtoregwrite
    );

  ALUControl alucontrolcpu(
    aluopcpu,
    alufunctioncpu,
    aluctrltoalu);

  alu alucpu(
    readdata1cpu,
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
    readdata2cpu,
    reset);

  signextend cpusignextender(
    signExtendercpu,
    signextresultcpu
    );

  Memory memcpu(
    memwritecpu,
    memreadcpu,
    aluresultcpu,
    readdata2cpu,
    readdata,
    reset
    );

endmodule
