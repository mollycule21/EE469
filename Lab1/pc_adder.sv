
`define WORD_SIZE		32

module pc_adder(pc_en, address_in, address_out);
	input logic pc_en;
	input logic [`WORD_SIZE - 1:0]address_in;
	output logic [`WORD_SIZE - 1:0]address_out;

	always begin
		if (!pc_en) address_out = address_in;
		else address_out = address_in + 4;
	end

endmodule
