
`define WORD_SIZE		32


module pc(clk, reset, imm, imm_U_J, imm_en,
					alu_branch, control_branch, address_out);
	`include "constants.svh"
	
	input logic clk, reset;
	input logic [11:0]imm;
	input logic [19:0]imm_U_J;
	input logic [1:0]imm_en;
	input logic alu_branch, control_branch;
	output logic [`WORD_SIZE - 1:0]address_out;

	logic [`WORD_SIZE - 1:0]address_in;
	logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch;


	pc_in_out pc_i_o (.clk(clk), .reset(reset), .address_in(address_in), .address_out(address_out));
	
	pc_adder p_adder(.address_in(address_out), 
					.address_out(address_from_increment));

	branch_adder b_adder(.clk(clk), .pc(address_out), .imm(imm), .imm_U_J(imm_U_J), 
						.imm_en(imm_en), .pc_out(address_from_branch));

	pc_mux p_mux(.clk(clk), .address_from_increment(address_from_increment), 
					.address_from_branch(address_from_branch), .alu_branch(alu_branch),
					.control_branch(control_branch), .pc_out(address_in));

endmodule
