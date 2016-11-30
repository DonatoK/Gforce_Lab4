//Test Bench for CPU
//Runs clock, change register instructions, verify correct output
module testbenchGFORCE;
//input registers

//output reading register

mipscpu.memcpu.mem_file[0] = 10; //a = 10

always
begin
#1 clk = ~clk;
end

begin
//instructions for
end

endmodule
