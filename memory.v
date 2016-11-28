module Memory (CS, WE, ClK, ADDR, Mem_Bus);

	input CS, WE, ClK;
	input [31:0] ADDR;
	inout[31:0] Mem_Bus;

	reg [31:0] data_out;
	reg [31:0] RAM [0:127];

	integer i;
	reg [6:0] counter;

	initial begin
		for(i=0; i<128; i=i+1)
			begin
				RAM[i] = 32'd0;
			end

	end

	assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out;

	always @(negedge ClK)
	begin
		if ((CS == 1'b1) && (WE == 1'b1))
			RAM[ADDR] <= Mem_Bus[31:0];
		data_out <= RAM[ADDR];
	end

endmodule






module test_memori;

reg cs, we, clk;
reg [31:0] addr;
reg [31:0] mem_bus;

Memory testing1 (cs, we, clk, addr, mem_bus);
initial

	begin

	end


endmodule
