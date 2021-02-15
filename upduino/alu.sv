// alu performs the following operations
// - add
// - sub
// - and
// - or
// - xor 
// - shift left
// - shift right logical
// - shift right arithmetic

// control signal mapping:
// ALU_ADD -- 000
// ALU_SUB -- 001
// ALU_AND -- 010
// ALU_OR  -- 011
// ALU_XOR -- 100
// ALU_SL  -- 101
// ALU_SRL -- 110
// ALU_SRA -- 111


`include "alu_signal.svh"
`define WORD_SIZE	32

module alu(clk, reset, control, in_1, in_2, out);
	input logic clk, reset;
	input logic [2:0]control;							// 3-bit control signal for ALU operation
	input logic signed [`WORD_SIZE - 1:0]in_1, in_2;	// signed inputs

	output logic signed [`WORD_SIZE - 1:0]out;



	// dff logic
	always_ff@(posedge clk) begin
		if (reset) begin
			out <= 32'd0;
		end else if (control == ALU_ADD) begin
			out <= in_1 + in_2;
		end else if (control == ALU_SUB) begin
			out <= in_1 - in_2;
		end else if (control == ALU_AND) begin
			out <= in_1 & in_2;
		end else if (control == ALU_OR) begin
			out <= in_1 | in_2;
		end else if (control == ALU_XOR) begin
			out <= in_1 ^ in_2;
		end else if (control == ALU_SL) begin
			// shift left in_1 by in_2 bits
			out <= in_1 << in_2;
		end else if (control == ALU_SRL) begin
			// logical shift right in_1 by in_2 bits
			out <= in_1 >> in_2;
		end else begin
			// arithmetic shift right in_1 by in_2 bits
			out <= in_1 >>> in_2;
		end
	end

endmodule
