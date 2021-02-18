
`define NUMBER_OF_WORDS		2048		// number of words in data memory	

module data_memory(clk, reset, address, xfer_size, read_en, write_en, write_data, read_data);
	`include "constants.svh"

	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data;

	// data memory size in bytes
	localparam data_memory_size = `WORD_SIZE * `NUMBER_OF_WORDS;

	// initialize data memory
	logic [`WORD_SIZE - 1:0] data_memory [`NUMBER_OF_WORDS - 1:0];

	// set everything in data memory to 0
	integer i;
	initial begin
		for (i = 0; i < `NUMBER_OF_WORDS; i = i + 1) begin
			data_memory[i] = 32'd0;
		end
	end

	// aligning the address based on xfer_size
	// xfer_size are defined as follows
	logic [`WORD_SIZE - 1:0] aligned_address;
	always_comb begin
		if (xfer_size == XFER_BYTE) begin
		end
	end

	// DFF logic for read operation
	always_ff@(posedge clk) begin
		// make sure address is not out of bound
		assert(address <= data_memory_size);

		if (reset) begin
			// set everything in data memory to 0
			for (i = 0; i < `NUMBER_OF_WORDS; i = i + i) begin
				data_memory[i] <= 32'd0;
			end
		end else if (read_en) begin
			
		end

	end


endmodule
