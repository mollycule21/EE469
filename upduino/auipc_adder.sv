
// adder for auipc instruction
`define WORD_SIZE		32

module auipc_adder(pc, imm, pc_out);
	input logic [`WORD_SIZE - 1:0]pc;
	input logic [19:0]imm;
	output logic [`WORD_SIZE - 1:0]pc_out;

	// imm is the upper 20-bit
	logic [`WORD_SIZE - 1:0]temp;
	assign temp[`WORD_SIZE - 1:12] = imm;

	always_comb begin
		pc_out = pc + temp;		
	end

endmodule
