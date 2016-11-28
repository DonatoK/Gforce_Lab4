module instructmem(
  input wire  [31:0]  inputVal,
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
