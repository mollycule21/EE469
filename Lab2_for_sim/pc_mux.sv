
`define WORD_SIZE		32
// alu_branch signal is going to arrive two clock cycles later
// so control_branch has to be delayed for two clock cycles


// address_from_increment has to be delayed for three clock cycles
// address_from_branch has to be delayed for two clock cycles
module pc_mux(clk, address_from_increment, address_from_branch, address_from_jalr,
				alu_branch, control_branch, jalr_branch, pc_out);
	input logic clk;
	input logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch, address_from_jalr;
	input logic alu_branch, control_branch, jalr_branch;
	output logic [`WORD_SIZE - 1:0]pc_out;

	always_comb begin
		if (alu_branch & control_branch) pc_out = address_from_branch;
		else if (alu_branch & jalr_branch) pc_out = address_from_jalr;
		else pc_out = address_from_increment;
	end

endmodule
