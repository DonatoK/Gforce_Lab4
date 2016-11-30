
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
//

    end
    endmodule

 module RegisterFiConn;
    // wires that go to the registerfile
	wire [25:21] readReg1cpu;         // inputs of read register 1
    wire [20:16] readReg2cpu;         // inputs of read register 2
	wire [4:0]MuxRegDstOuttoWritereg; // wire that goes from the mux register destination to write register
	wire [31:0] outputtowriteData;    // mem to reg  mux's output to write data
	wire regWritecpu;                 // register write
    wire [31:0]  readData1cpu;        // outputs of read data 1
	wire [31:0]  readData2cpu;        // outputs of read data2


 registerfile Registerfilecpu (readReg1cpu ,
							  readReg2cpu ,
							  MuxRegDstOuttoWritereg,
							  outputtowriteData ,
							  regWritecpu,
							  readData1cpu,
							  readData2cpu);

 endmodule
