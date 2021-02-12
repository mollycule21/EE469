// module for clocked instruction memeory
// this instruction memory is single port

// Upduino only has 1Mb SPRAM, 120Kb DPRAM
`define NUMBER_OF_INSTRUCTIONS	64

module instruction_memory(clk, reset, address, instruction);
	input logic 	clk;
	input logic 	[31:0]address;			// 4-byte address pointer
	output logic 	[31:0]instruction;		// 4-byte instruction
	
	// instruction memeory
	logic instruction_memory[`NUMBER_OF_INSTRUCTIONS - 1:0][31:0];

	// initialize binary memory file
	initial $readmemb("rv32i-instruction.bin", instruction_memory);


	// dff
	always_ff@(posedge clk) begin
		if (reset) begin
			
		end else begin
			instruction <= 
		end
	end
endmodule
