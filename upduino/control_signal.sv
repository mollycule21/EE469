// handles intructions
// outputs control signals

`include "constants.svh"
`include "alu_signal.svh" 	// alu operation signals
`define WORD_SIZE	32


module control_signal(instruction, mem_write, reg_write, alu_signal);
	input logic [`WORD_SIZE - 1:0]instruction;
	input logic mem_write, reg_write; 	// if need to write to memory or register
	input logic [2:0]alu_signal;		// control signal for alu

	always_comb begin
	

	end

endmodule
