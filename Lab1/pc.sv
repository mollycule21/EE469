<<<<<<< HEAD
`define WORD_SIZE		32


module pc (clk, reset, pc_en, address_in, imm, imm_U_J, imm_en,
								alu_branch, control_branch, address_out);
	`include "constants.svh"
	
	input logic clk, reset, pc_en;
	input logic [`WORD_SIZE - 1:0]address_in;
	input logic [11:0]imm;
	input logic [19:0]imm_U_J;
	input logic [1:0]imm_en;
	input logic alu_branch, control_branch;
	output logic [`WORD_SIZE - 1:0]address_out;

	logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch;
	
	// if reset then address_out is set to 0, else address_out is address_in 
	// inputs: clk, reset, address_in 
	// outputs: address_out 
	pc_in_out pc_i_o (.clk(clk), .reset(reset), .address_in(address_in), 
								.address_out(address_out));
	
	// if pc_en then address_out = address_in + 4, else address_out = address_in 
	// inputs = pc_en, address_in
	// outputs = address_out 
	pc_adder p_adder(.pc_en(pc_en), .address_in(address_out), 
								.address_out(address_from_increment));

	// imm_en tells whether it is a imm or imm_U_J 						
	branch_adder b_adder(.pc(address_out), .imm(imm), .imm_U_J(imm_U_J), 
									.imm_en(imm_en), .pc_out(address_from_branch));

	pc_mux p_mux(.address_from_increment(address_from_increment), 
					.address_from_branch(address_from_branch), .alu_branch(alu_branch),
					.control_branch(control_branch), .pc_out(address_in));

endmodule
=======
// program counter

module pc(clk, reset, address_in, address_out);
	input logic clk, reset, pc_en;
	input logic [31:0]address_in;
	output logic [31:0]address_out;
	

	// DFF logic
	always@(posedge clk) begin
		if (reset) begin 
			address_out <= 32'd0;
		end else  begin 
			address_out <= address_in;
		end
	end

endmodule

>>>>>>> 87a68024dc4cc71812ce6563ccefe90a5c547843
