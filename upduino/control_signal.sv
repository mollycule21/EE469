// handles intructions
// outputs control signals

`include "constants.svh"

`define WORD_SIZE	32


module control_signal(opcode, funct3, funct7, mem_write, reg_write, branch, alu_signal);
	input logic [6:0]opcode, funct7;
	input logic [2:0]funct3;
	input logic mem_write, reg_write, branch; 	// if need to write to memory or register
	input logic [2:0]alu_signal;				// control signal for alu

	logic [9:0]funct7_3;						// funct7 and funct3 concated
	assign funct7_3 = {funct7, funct3};

	// understanding the instruction
	always_comb begin
		case(opcode)
		op: if (funct7_3 == ADD) begin
				alu_signal = ALU_ADD;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == SUB) begin
				alu_signal = ALU_SUB;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == SLL) begin
				alu_signal = ALU_SL;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == SLT) begin
				// need work here
				alu_signal = ;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == SLTU) begin
				// need work here
			end else if (funct7_3 == XOR) begin
				alu_signal = ALU_XOR;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == SRL) begin
				alu_signal = ALU_SRL;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == SRA) begin
				alu_signal = ALU_SRA;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else if (funct7_3 == OR) begin
				alu_signal = ALU_OR;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end else begin 		// AND CASE
				alu_signal = ALU_AND;
				mem_write = 1'b0;
				reg_write = 1'b1;
			end
		op-imm: if (funct3 == ADDI)

		endcase
	end

endmodule
