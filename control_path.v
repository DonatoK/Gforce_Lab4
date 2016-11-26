module controls(
  input wire [5:0]  Opcode,
  output reg RegDst,
  output reg Branch,
  output reg MemtoRead,
  output reg MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemtoWrite,
  output reg ALUSrc,
  output reg RegWrite);

  always@(Opcode) begin
      case (Opcode)
        0 : begin RegDst = 1;
            Branch = 0;
            MemtoRead = 0;
            MemtoReg = 0;
            ALUOp = 2;
            MemtoWrite = 0;
            ALUSrc = 0;
            RegWrite = 1;
            end
        35:begin
            RegDst = 0;
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemtoRead = 1;
            MemtoWrite = 0;
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
endmodule
