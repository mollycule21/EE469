// module for clocked instruction memeory
// this instruction memory is single port

// Upduino only has 1Mb SPRAM, 120Kb DPRAM
`define NUMBER_OF_INSTRUCTIONS	64

module instruction_memory(clk, reset, address, instruction);
	localparam address_size;
	assign address_size = $clog2(`NUMBER_OF_INSTRUCTIONS);

	input logic 	clk;
	input logic 	[address_size - 1:0]address;
	output logic 	[31:0]instruction;				// 4-byte instruction
	
	// instruction memeory
	logic instruction_memory[`NUMBER_OF_INSTRUCTIONS - 1:0][31:0];

	// initialize binary memory file
	$display("Loading instruction memory...");
	initial $readmemb("rv32i-instruction.bin", instruction_memory);


	// dff
	always_ff@(posedge clk) begin
		if (reset) begin
			// set instruction to all 0
			instruction <= 32'b0;
		end else begin
			instruction <= instruction_memory[address];
		end
	end
endmodule
