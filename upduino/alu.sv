// alu performs the following operations

// - add
// - sub
// - and
// - or
// - xor 

// - shift left
// - shift left (unsigned) 
// - shift right logical
// - shift right arithmetic

// - branch equal to (BEQ) 
// - branch not equal (BNE) 
// - branch less than (BLT) 
// - branch less than unsigned (BLTU)
// - branch greater than (BGE) 
// - branch greater than unsigned (BGEU) 

// - load byte (LB)
// - load byte unsigned (LBU)
// - load hex (LH) 
// - load hex unsigned (LHU) 
// - load word (LW) 

// - store byte (SB)
// - store byte unsigned (SBU)
// - store hex (SH) 
// - store hex unsigned (SHU) 
// - store word (SW) 


// control signal mapping:
// ALU_ADD -- 000
// ALU_SUB -- 001
// ALU_AND -- 010
// ALU_OR  -- 011
// ALU_XOR -- 100
// ALU_SL  -- 101
// ALU_SRL -- 110
// ALU_SRA -- 111

// alu_signal from regfile_datapath.sv inputs alu_signal as control 
// register inputs read_out_1 and read_out_2 as in_1 and in_2

`include "alu_signal.svh"
`define WORD_SIZE	32

module alu(clk, reset, control, in_1, in_2, out);
	input logic clk, reset;
	input logic [3:0]control;							// 3-bit control signal for ALU operation
	input logic signed [`WORD_SIZE - 1:0]in_1, in_2;	// signed inputs

	output logic signed [`WORD_SIZE - 1:0]out;
	output true; 
	
	logic [`WORD_SIZE - 1:0];

	logic in1_g_in_2;
	logic in1_e_in_2; 
	
	always_comb begin 
		if (in_1 > in2) begin 
			in_1_g_in_2 = 1'b1;
			in_1_e_in_2 = 1'b0;
		end else if (in_1 == in_2) begin 
			in_1_e_in_2 = 1'b1;
			in_1_g_in_2 = 1'b0;
		end 
	end 

	// dff logic
	always_ff@(posedge clk) begin
		if (reset) begin
			out <= 32'd0;
		end else if (control == ALU_ADD) begin
			out <= in_1 + in_2;
			true <= 0; 
		end else if (control == ALU_SUB) begin
			out <= in_1 - in_2;
			true <= 0; 
		end else if (control == ALU_AND) begin
			out <= in_1 & in_2;
			true <= 0; 
		end else if (control == ALU_OR) begin
			out <= in_1 | in_2;
			true <= 0; 
		end else if (control == ALU_XOR) begin
			out <= in_1 ^ in_2;
			true <= 0; 
		end else if (control == ALU_SL) begin // also takes care of SLU 
			// shift left in_1 by in_2 bits
			out <= in_1 << in_2;
			true <= 0; 
		end else if (control == ALU_SRL) begin // also takes care of SRLU
			// logical shift right in_1 by in_2 bits
			out <= in_1 >> in_2;
			true <= 0; 
		end else if (control == ALU_SRA) begin // also takes care of SRAU
			// arithmetic shift right in_1 by in_2 bits
			out <= in_1 >>> in_2;
			true <= 0; 
		end else if (control == SLT && in_1_g_in_2 = 1'b0) begin 
			out <= 32'd1; 	
		end else if (control == SLT && in_1_g_in_2 = 1'b1) begin 
			out <= 32'd0 
		end else if 
	end

endmodule
