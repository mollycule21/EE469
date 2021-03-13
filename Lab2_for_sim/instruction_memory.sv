// module for clocked instruction memeory
// instruction memory is 4kiB, which is 32768 bits
// which holds 1024 32-bit instructions

// Upduino only has 1Mb SPRAM, 120Kb DPRAM
`define NUMBER_OF_INSTRUCTIONS	1024
`define WORD_SIZE				32
`define INPUT_FILE_INST				"../assets/code.hex"

module instruction_memory(clk, reset, stall, address, instruction);
	localparam address_size = $clog2(`NUMBER_OF_INSTRUCTIONS);

	input logic 	clk, reset;
	input logic 	[`WORD_SIZE - 1:0]address;		// 32-bit address
	input logic 	stall;
	output logic 	[`WORD_SIZE - 1:0]instruction;	// 4-byte instruction
	
	// instruction memeory
	logic [31:0] instruction_memory[`NUMBER_OF_INSTRUCTIONS - 1:0];

	// initialize binary memory file
	initial $display("Loading instruction memory...");
	initial $readmemb(`INPUT_FILE_INST, instruction_memory);

	// dff
	always_ff @(negedge clk) begin
		if (reset || stall) begin 
			instruction <= 32'd0;
		end else begin 
			// make sure address is not out of bound
			// assert(address <= `NUMBER_OF_INSTRUCTIONS);
			instruction <= instruction_memory[address/4];
		end
	end
endmodule
