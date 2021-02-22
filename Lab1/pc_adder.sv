
`define WORD_SIZE		32

module pc_adder(address_in, address_out);
	input logic [`WORD_SIZE - 1:0]address_in;
	output logic [`WORD_SIZE - 1:0]address_out;

	always_comb begin
		// if (!pc_en) address_out = address_in;
		address_out = address_in + 4;
	end

endmodule
