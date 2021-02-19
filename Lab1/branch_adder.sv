
// adder for auipc and branch instructions
`define WORD_SIZE		32

module branch_adder(pc, imm, imm_U_J, imm_en, pc_out);
	`include "constants.svh"
	input logic [`WORD_SIZE - 1:0]pc;
	input logic [11:0]imm;			// for branch operations
	input logic [19:0]imm_U_J;		// for lui operations
	input logic [1:0]imm_en;		// tells us which immediate value to take
	output logic [`WORD_SIZE - 1:0]pc_out;

	logic [`WORD_SIZE - 1:0]temp;
	always_comb begin
		case(imm_en) begin
		ALU_READ_IMM: begin
			temp[12:1]				= imm;
			temp[0]					= 1'b0;
		end
		ALU_READ_IMM_U_J: begin
			temp[`WORD_SIZE - 1:12] = imm;
		end
	end

	always_comb begin
		pc_out = pc + temp;		
	end

endmodule
