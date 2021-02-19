 // control signal mapping are in constants.svh

// alu_signal from regfile_datapath.sv inputs alu_signal as control 
// register inputs read_out_1 and in_2 as in_1 and in_2


// TODO: add an enable signal, alu is not running @ every clock cycle

`define WORD_SIZE	32

module alu(clk, reset, control, in_1, in_2, imm, imm_U_J, imm_en, out, take_branch);
	`include "constants.svh"

	input logic clk, reset;

	input logic [3:0]control;							// 3-bit control signal for ALU 
	input logic [`WORD_SIZE - 1:0]in_1, in_2;			// signed inputs
	input logic [1:0]imm_en;
	input logic [11:0]imm;
	input logic [19:0]imm_U_J;
	output logic [`WORD_SIZE - 1:0]out; 
	output logic take_branch;

	logic [`WORD_SIZE - 1:0]sorted_in_2;
	// this combinational logic act as the mux
	always_comb begin
		case(imm_en)
		ALU_READ_RS2:		sorted_in_2 = in_2;	
		ALU_READ_IMM: begin
			sorted_in_2[`WORD_SIZE - 1:12] = 20'd0;
			sorted_in_2[11:0] = imm;
		end
		ALU_READ_IMM_U_J: begin
			sorted_in_2[`WORD_SIZE - 1:20] = 12'd0;
			sorted_in_2[19:0] = imm_U_J;
		end
		endcase
	end


	logic [`WORD_SIZE - 1:0]less_than_temp;
	always_comb begin
		less_than_temp = in_1 - in_2;
	end

	// dff logic
	always_ff@(posedge clk) begin
		if (reset) begin
			out <= 32'd0;
			take_branch <= 0;
		end else begin
			case(control) 
			ALU_ADD_I: begin
				out 		<= in_1 + sorted_in_2;
				take_branch <= 0;
			end
			ALU_SUB_I: begin
				out 		<= in_1 - sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_AND_I: begin
				out 		<= in_1 & sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_OR_I: begin
				out 		<= in_1 | sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_XOR_I: begin
				out 		<= in_1 ^ sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_SLL_I: begin  
				out 		<= in_1 << sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_SRL_I: begin 
				out 		<= in_1 >> sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_SRA_I: begin 
				out 		<= in_1 >>> sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_BEQ: begin	
				out <= 32'd0;
				if (in_1 == sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BNE: begin
				out <= 32'd0;
				if (in_1 != sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end
			ALU_BLT: begin 
				out <= 32'd0; 	
				if (less_than_temp[31])		take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BGE: begin
				out <= 32'd0;
				if (less_than_temp[31])		take_branch <= 0;
				else						take_branch <= 1;
			end 
			ALU_BLT_U: begin
				out <= 32'd0;
				if (in_1 < sorted_in_2)		take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BGE_U: begin
				out <= 32'd0;
				if (in_1 >= sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_SLT_I: begin 
				take_branch <= 0;
				if (less_than_temp[31])		out <= 32'd1;
				else						out <= 32'd0;
			end 
			ALU_SLT_I_U: begin
				take_branch <= 0;
				if (in_1 < sorted_in_2)		out <= 32'd1;
				else						out <= 32'd0;
			end
			endcase
		end
	end

endmodule
