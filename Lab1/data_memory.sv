// alu.sv  output out -> input address 
// register_file.sv  output read_out_1 = input write_data 
// 

`define NUMBER_OF_WORDS		2048		// number of words in data memory	
`define WORD_SIZE			32
`define HALF_WORD			16

module data_memory(clk, reset, read_en, address, xfer_size, write_en, write_data, read_data);
	`include "constants.svh"

	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic [2:0]xfer_size;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data;

	// data memory size in bytes
	localparam data_memory_size = `WORD_SIZE * `NUMBER_OF_WORDS;

	// initialize data memory
	logic [7:0] data_memory [data_memory_size - 1:0];

	// set everything in data memory to 0
	integer i;
	initial begin
		for (i = 0; i < `NUMBER_OF_WORDS; i = i + 1) begin
			data_memory[i] = 32'd0;
		end
	end

	// DFF logic for read operation
	always_ff@(posedge clk) begin
		// make sure address is not out of bound
		assert(address <= data_memory_size);

		if (reset) begin
			// set everything in data memory to 0
			for (i = 0; i < `NUMBER_OF_WORDS; i = i + i) begin
				data_memory[i] <= 8'd0;
			end
		end else if (read_en && xfer_size == XFER_BYTE) begin
			read_data[`WORD_SIZE - 1:8] <= 24'd0;
			read_data[7:0] 				<= data_memory[address];
		end else if (read_en && xfer_size == XFER_HALF) begin
			read_data[`WORD_SIZE - 1:0]	<= 16'd0;
			read_data[15:0] 			<= {data_memory[address + 32'd1], data_memory[address]};
		end else if (read_en && xfer_size == XFER_WORD) begin
			read_data					<= {data_memory[address + 32'd3],
											data_memory[address + 32'd2],
											data_memory[address + 32'd1],
											data_memory[address]};
		end else if (write_en && xfer_size == XFER_BYTE) begin
			data_memory[address]		<= write_data[7:0];
			read_data					<= 32'bx;
		end else if (write_en && xfer_size == XFER_HALF) begin
			data_memory[address]			<= write_data[7:0];
			data_memory[address + 32'd1]	<= write_data[15:8];
			read_data					<= 32'bx;
		end else begin
			data_memory[address]			<= write_data[7:0];
			data_memory[address + 32'd1]	<= write_data[15:8];
			data_memory[address + 32'd2]	<= write_data[24:16];
		end
	end


endmodule
