
`define WORD_SIZE		32

module pc_mux(address_from_increment, address_from_branch, alu_branch, control_branch, pc_out);
	input logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch;
	input logic alu_branch, control_branch;
	output logic [`WORD_SIZE - 1:0]pc_out;

	always_comb begin
		if (alu_branch && control_branch) pc_out = address_from_branch;
		else pc_out = address_from_increment;
	end

endmodule
