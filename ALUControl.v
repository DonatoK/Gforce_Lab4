module ALUControl (ALUOp , Function , Output );

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


module tests;

reg [1:0] aluOp;
reg [5:0] Funct;
wire [3:0] Out;

ALUControl t_ALU (aluOp,Funct,Out);


initial 
begin 
aluOp = 0;
Funct = 0;
end 

initial 
begin
	#1 aluOp = 2;
	#1 Funct = 6'b101010;
	 $monitor($time,"Out = %b", Out);
	   
   

end


initial
	begin
		$dumpfile("ALUControl.vcd");
		$dumpvars;
	end



endmodule