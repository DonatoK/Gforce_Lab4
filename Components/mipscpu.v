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

module ALUControl ();

//*******************************************************************************************************************************************/
//
//
// test benches  
module testEverything;
// multiplexer for Register destination
reg [5:0] Input1,Input2;
reg RegDestination;
wire [5:0] Outputval;
 
    muxRegDestination t_mux1( Input1, Input2, RegDestination, Outputval);
// multiplexer for ALU source
 
reg [31:0] Result,Result2;
reg aluSRC;
wire [31:0] Outputval2;	
	
	muxALUSrc t_mux2 (Result, Result2, aluSRC, Outputval2); 
// multiplexer for MemtoReg
	
reg [31:0] Solution, Solution2;
reg MemtoReg;
wire [31:0] Outputval3;	
     muxMemtoReg t_mux3 (Solution, Solution2, MemtoReg, Outputval3 );	
	
	initial 
	begin
	Input1 = 0;
	Input2 = 0;
	Result = 0;
	Result2 = 0;
	Solution = 0;
	Solution2 = 0;
	MemtoReg = 0;
	aluSRC = 0;
	RegDestination = 0;
	end
	
	initial 
	begin
     #1  RegDestination = 1;
	 
	   if (RegDestination==1)
			begin
			Input1 = 1;
			$display("input1 = %d", Input1);
		 end
	   else 
			begin 
			Input2 = 0;
			$display("input2 = %d", Input2);
			end 
/*********************************************************************************************************************************************/
	
	 #1 aluSRC = 1;
		if (aluSRC == 1)
			begin 
			Result =1;
			$display("Result = %d", Result);
			end
		else 
			begin
			Result2= 0;
			$display("Result2 = %d", Result2);
			end
/***********************************************************************************************************************************************/			
	#1 MemtoReg = 1;
		if (MemtoReg == 1)
			begin 
			Solution =1;
			$display("Solution = %d", Solution);
			end
		else 
			begin
			Solution2= 0;
			$display("Solution2 = %d", Solution2);
			end
	 end
	 
	 initial 
	begin
		$dumpfile("mipscpu.vcd");
		$dumpvars;
	end
endmodule