
`define WORD_SIZE		32
// alu_branch signal is going to arrive two clock cycles later
// so control_branch has to be delayed for two clock cycles


// address_from_increment has to be delayed for three clock cycles
// address_from_branch has to be delayed for two clock cycles
module pc_mux(clk, address_from_increment, address_from_branch, alu_branch, control_branch, pc_out);
	input logic clk;
	input logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch;
	input logic alu_branch, control_branch;
	output logic [`WORD_SIZE - 1:0]pc_out;

	// manage all the delays
	logic control_branch_temp_1, control_branch_temp_2;
	logic [`WORD_SIZE - 1:0]address_from_increment_temp_1,
							address_from_increment_temp_2,
							address_from_increment_temp_3;
	logic [`WORD_SIZE - 1:0]address_from_branch_temp_1,
							address_from_branch_temp_2;
	always_ff@(posedge clk) begin
		control_branch_temp_1 <= control_branch;
		control_branch_temp_2 <= control_branch_temp_1;

		address_from_increment_temp_1 <= address_from_increment;
		address_from_increment_temp_2 <= address_from_increment_temp_1;
		address_from_increment_temp_3 <= address_from_increment_temp_2;

		address_from_branch_temp_1 <= address_from_branch;
		address_from_branch_temp_2 <= address_from_branch_temp_1;
	end


	always_comb begin
		if (alu_branch & control_branch_temp_2) pc_out = address_from_branch_temp_2;
		else pc_out = address_from_increment_temp_3;
	end

endmodule
