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
  output reg RegWrite);
/*
*This module sets the control signals for the control Path
*
*The Signals are dependant on the opcode given


*/

  always@(Opcode) begin
      case (Opcode)
        0 : begin
            RegDst = 1;
            Branch = 0;
            MemtoReg = 0;
            ALUOp = 2;
            ALUSrc = 0;
            end
        35:begin
            RegDst = 0;
            ALUSrc = 1;
            MemtoReg = 1;
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

  always@(posedge clock) begin
        case(Opcode)
          0: begin
              MemtoRead <= 0;
              MemtoWrite <= 0;
              RegWrite <= 1;
              end
          35: begin
              MemtoRead <= 1;
              MemtoWrite <= 0;
              RegWrite <= 1;
              end
          43: begin
              MemtoRead <= 0;
              MemtoWrite <= 1;
              RegWrite <= 0;
              end
          endcase
        end
endmodule
