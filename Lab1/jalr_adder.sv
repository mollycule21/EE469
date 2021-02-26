
`define WORD_SIZE		32

module jalr_adder(clk, register_value, imm, jalr_output);
	input logic clk;
	input logic [`WORD_SIZE - 1:0]register_value;
	input logic [11:0]imm;
	output logic [`WORD_SIZE - 1:0]jalr_output;

	logic [`WORD_SIZE - 1:0]imm_temp;

	// buffer the immediate value
	logic [11:0]imm_delayed;
	always_ff@(posedge clk) begin
		imm_delayed <= imm;
	end

	// combinational logic
	always_comb begin
		// sign extending imm
		if (imm_delayed[11]) imm_temp[`WORD_SIZE - 1:12] = 20'hfffff;
		else imm_temp[`WORD_SIZE - 1:12] = 20'b0;

		imm_temp[11:0] = imm_delayed;

		// add register value and immediate
		// last bit need to set to 0
		jalr_output = (imm_temp + register_value) & 32'hfffffffe;
	end


endmodule
