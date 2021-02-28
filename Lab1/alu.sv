 // control signal mapping are in constants.svh

// alu_signal from regfile_datapath.sv inputs alu_signal as control 
// register inputs read_out_1 and in_2 as in_1 and in_2


// TODO: add an enable signal, alu is not running @ every clock cycle

`define WORD_SIZE	32

module alu(clk, reset, pc, control, in_1, in_2, imm, imm_U_J, imm_en, out, take_branch);
	`include "constants.svh"

	input logic clk, reset;

	input logic [4:0]control;							// 3-bit control signal for ALU 
	input logic [`WORD_SIZE - 1:0]in_1, in_2;			// signed inputs
	input logic [`WORD_SIZE - 1:0]pc;
	input logic [1:0]imm_en;
	input logic [11:0]imm;
	input logic [19:0]imm_U_J;
	output logic [`WORD_SIZE - 1:0]out; 
	output logic take_branch;

	// logics for buffering
	logic [4:0]control_delay;							// 3-bit control signal for ALU 
	logic [`WORD_SIZE - 1:0]pc_delay;
	logic [1:0]imm_en_delay;
	logic [11:0]imm_delay;
	logic [19:0]imm_U_J_delay;
	
	// dff delay
	always_ff@(posedge clk) begin
		control_delay <= control;

		pc_delay <= pc;
		
		imm_en_delay <= imm_en;

		imm_delay <= imm;

		imm_U_J_delay <= imm_U_J;
	end



	logic sign;
	logic [`WORD_SIZE - 1:0]sorted_in_2;
	// this combinational logic act as the mux
	always_comb begin
		case(imm_en_delay)
		ALU_READ_RS2:		sorted_in_2 = in_2;	
		ALU_READ_IMM: begin
			// sign extenting the immediate
			sign = imm_delay[11];		// sign of the immediate
			if (sign) sorted_in_2[`WORD_SIZE - 1:12] = 20'hfffff;
			else sorted_in_2[`WORD_SIZE - 1:12] = 20'b0;

			sorted_in_2[11:0] = imm_delay;
		end
		ALU_READ_IMM_U: begin
			sorted_in_2[`WORD_SIZE - 1:12] = imm_U_J_delay; 
			sorted_in_2[11:0] = 12'd0;
		end
		default: begin
			sorted_in_2 = 32'b0;
		end
		endcase
	end

	// temp variable for less than operations
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
			case(control_delay) 
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
				out 		<= in_1 << sorted_in_2[4:0];
				take_branch <= 0; 
			end 
			ALU_SRL_I: begin 
				out 		<= in_1 >> sorted_in_2[4:0];
				take_branch <= 0; 
			end 
			ALU_SRA_I: begin 
				out 		<= in_1 >>> sorted_in_2[4:0];
				take_branch <= 0; 
			end 
			ALU_BEQ: begin	
				out <= 32'dx;
				if (in_1 == sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BNE: begin
				out <= 32'dx;
				if (in_1 != sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end
			ALU_BLT: begin 
				out <= 32'dx; 	
				if (less_than_temp[31])		take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BGE: begin
				out <= 32'dx;
				if (less_than_temp[31])		take_branch <= 0;
				else						take_branch <= 1;
			end 
			ALU_BLT_U: begin
				out <= 32'dx;
				if (in_1 < sorted_in_2)		take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BGE_U: begin
				out <= 32'dx;
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
			ALU_JAL_R: begin
				take_branch <= 1;
				out <= pc_delay + 32'd4;
			end
			ALU_LUI: begin
				take_branch <= 0;
				out <= sorted_in_2;
			end
			ALU_AUIPC: begin
				take_branch <= 1;
				out <= pc_delay + sorted_in_2;
			end
			default: begin
				take_branch <= 1'bx;
				out <= 32'bx;
			end
			endcase
		end
	end

endmodule
