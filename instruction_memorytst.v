//Instruction memory Testbench//
module testBenchInstMem;
// set up test input instruction//
wire [31:26] Instruct1;
wire [25:21] Instruct2;
wire [20:16] Instruct3;
wire [15:11] Instruct4;
wire [15:0]  Instruct5;
wire [5:0]  Instruct6;
reg [31:0]  InputVal;

instructmem Myinstructmem( 
InputVal, Instruct1, Instruct2, 
Instruct3, Instruct4, Instruct5,
Instruct6);

initial
begin
#1 InputVal = 32'h5FAF6FBF;
#4 $display("\n***Instmem test 1***\n");
#4 $display("Inputval[31:0]   is  %b\n", InputVal);
#4 $display("Instruct1[31:26] is  %b\n", Instruct1);
#4 $display("Instruct2[25:21] is  %b\n", Instruct2);
#4 $display("Instruct3[20:16] is  %b\n", Instruct3);
#4 $display("Instruct4[15:11] is  %b\n", Instruct4);
#4 $display("Instruct5[15:0]  is  %b\n", Instruct5);
#4 $display("Instruct6[5:0]   is  %b\n", Instruct6);


#1 InputVal = 32'h0F0F0F0F;
#4 $display("***Instmem test 2***\n ");
#4 $display("Inputval[31:0]   is  %b\n", InputVal);
#4 $display("Instruct1[31:26] is  %b\n", Instruct1);
#4 $display("Instruct2[25:21] is  %b\n", Instruct2);
#4 $display("Instruct3[20:16] is  %b\n", Instruct3);
#4 $display("Instruct4[15:11] is  %b\n", Instruct4);
#4 $display("Instruct5[15:0]  is  %b\n", Instruct5);
#4 $display("Instruct6[5:0]   is  %b\n", Instruct6);

 
 
#1 InputVal = 32'h00000000;
#4 $display("***Instmem test 3***\n ");
#4 $display("Inputval[31:0]   is  %b\n", InputVal);
#4 $display("Instruct1[31:26] is  %b\n", Instruct1);
#4 $display("Instruct2[25:21] is  %b\n", Instruct2);
#4 $display("Instruct3[20:16] is  %b\n", Instruct3);
#4 $display("Instruct4[15:11] is  %b\n", Instruct4);
#4 $display("Instruct5[15:0]  is  %b\n", Instruct5);
#4 $display("Instruct6[5:0]   is  %b\n", Instruct6);

#5 InputVal = 32'hFFFFFFFF;
#4 $display("***Instmem test 4*** \n ");
#4 $display("Inputval[31:0]   is  %b\n", InputVal);
#4 $display("Instruct1[31:26] is  %b\n", Instruct1);
#4 $display("Instruct2[25:21] is  %b\n", Instruct2);
#4 $display("Instruct3[20:16] is  %b\n", Instruct3);
#4 $display("Instruct4[15:11] is  %b\n", Instruct4);
#4 $display("Instruct5[15:0]  is  %b\n", Instruct5);
#4 $display("Instruct6[5:0]   is  %b\n", Instruct6);
#102 $finish; //ends simulation. annoying repeats if missing. 
end 

endmodule