module alu(op1,op2,ctrl,result);

input [31:0] op1,op2;
input [3:0]  ctrl;
wire  [31:0] op1,op2;
wire  [3:0]  ctrl;
output[31:0] result;
reg   [31:0] result;



always@(op1 or op2 or ctrl)
begin

  case(ctrl)
  
  0: begin
		$display("and");
		result = op1 & op2;  // case 0 is for 0000 upcode for AND
		
	 end	
  1: begin 
		$display("or");
		result = op1 | op2;  // case 1 is for 0001 upcode for OR
		
	end	
  2: begin 
		$display("add");
		result = op1 + op2;  // case 2 is for 0010 upcode for add
		
	 end	
  
  6: begin
		$display("subtract");
		result = op1 - op2;  // case 6 is for 0110 upcode for sub
		
	 end	
  
  7:begin
		$display ("Set on Less Than");  
		result = op1 < op2;  // case 7 is for 0111 upcode for slt
		if (!(op1<op2))
		result = op2 < op1;
	end	
	
  12:begin 
		$display ("NOR");
		result = ~(op1 | op2); // case 12 is for 1100 upcode for NOR
     end

  endcase

end

endmodule



module twotoonemux(input1,input2,sel,outputval); 

input  [31:0] input1;
wire   [31:0] input1;
input  [31:0] input2;
wire   [31:0] input2;   
input  		  sel;
wire   		  sel;
output [31:0] outputval;
wire   [31:0] outputval;

assign outputval = (sel) ? input1 : input2 ; // if not selecting input 1 then select input 2 



endmodule

module registerfile(readReg1, readReg2, writeReg, writeData, regWrite, readData1, readData2 );

input [4:0]  readReg1;
wire  [4:0]  readReg1;
input [4:0]  readReg2;
wire  [4:0]  readReg2;
input [4:0]  writeReg;
wire  [4:0]  writeReg;
input [31:0] writeData;
wire  [31:0] writeData;
input		 regWrite;
wire         regWrite;
output[31:0] readData1;
reg  [31:0] readData1;
output[31:0] readData2;
reg  [31:0] readData2;

reg [31:0] registers [0:31]; // creating 32 registers of 32 bits 

always @ (*)
     begin
	 readData1 = registers[readReg1];  // connect read data to the 32 registers of 32 bits 
	 readData2 = registers[readReg2];  // and make them aware of the value of read registers 
	 end
always @(posedge regWrite)
  registers[writeReg] <= writeData;	

endmodule


module signextend(inputVal,outputVal);

input [15:0] inputVal;
wire  [15:0] inputVal;
output[31:0] outputVal;
wire  [31:0] outputVal;
 
assign outputVal = {{16{inputVal[15]}} , inputVal}; // 16 bit to 32 extension preserving the sign 

endmodule


/*********************************************************************************************************************************************/

module test;

// initialize the ALU variables insude the testbench
reg [31:0] Op1, Op2;
reg [3:0] Ctrl;
wire [31:0] Result;

alu t_alu(Op1,Op2,Ctrl,Result);

// initialize the MUX in the testbench
reg [31:0] Input1,Input2;
reg Sel;
wire [31:0] Outputval;

twotoonemux t_mux( Input1, Input2, Sel, Outputval);

// initialize the RegisterFile in the testbench
reg  [4:0] ReadReg1 , ReadReg2 , WriteReg;
reg  [31:0] WriteData;
reg RegWrite;
wire [31:0] ReadData1,ReadData2;


registerfile t_regfile (ReadReg1, ReadReg2, WriteReg, WriteData, RegWrite, ReadData1, ReadData2 );
 
// initialize the signed extend in the testbench
reg [15:0] InputVal;
wire [31:0] OutputVal;

signextend t_signex (InputVal, OutputVal);


initial
begin 
Ctrl = 0;
Op1  = 0;
Op2  = 0;
Sel  = 0;

Input1 = 0;
Input2 = 0; 
ReadReg1 = 0;
ReadReg2 = 0;
WriteReg = 0;
WriteData = 0;
RegWrite = 0;
InputVal = 0;

end



initial
begin
// test the modules to see if there is a connection
// testing ALU    
    #1 Ctrl = 0;
	#1 Op1  = 12;
	#1 Op2  = 11; 
	#1 if (Ctrl == 0)
	   $display(" result = %d ", Result);
// testing MUX	   
	#1 Sel  = 1;
	   if (Sel==1)
	     begin
	     Input1 = 1;
		 $display("input1 = %d", Input1);
		 end
	   else 
	     begin
         Input2 = 0;
		 $display("input2 = %d", Input2);
		 end
// testing 	registerfile	
        
		#1 RegWrite = 1; 
		
       if (RegWrite == 1)
         begin	   
			ReadReg1 = 15;
			ReadReg2 = 12;
			WriteReg = 10;
			WriteData =10;
			$display("1ReadData1 = %d , 1ReadData2 = %d ", ReadData1, ReadData2);
		 end
       else 
          begin
			ReadReg1 = 0;
			ReadReg2 = 0;
			WriteReg = 0;
			WriteData = 0;
			$display("0ReadData1 = %d , 0ReadData2 = %d ", ReadData1, ReadData2);
          end 		  
           			
  // testing sign extend
	   	#1  InputVal = 16'b1000001111000000;
		    $display("outputVal = %b", OutputVal);
		
     



end 

initial 
begin
		$dumpfile("Data_Path.vcd");
		$dumpvars;
	end


endmodule 
