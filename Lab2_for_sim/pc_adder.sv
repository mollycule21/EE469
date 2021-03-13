
`define WORD_SIZE		32

module pc_adder(address_in, stall, address_out);
	input logic [`WORD_SIZE - 1:0]address_in;
	input logic stall;
	output logic [`WORD_SIZE - 1:0]address_out;

	always_comb begin
		if (stall) begin
			address_out = address_in;
		end else begin
		// if (!pc_en) address_out = address_in;
			address_out = address_in + 4;
		end
	end

endmodule
