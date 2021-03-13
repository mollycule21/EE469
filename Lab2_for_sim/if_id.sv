// Fetch: read the instruction from code memory
// Read instruction from instruction memory module before inputting into control signal 
`define WORD_SIZE		32

module if_id (	output logic [`WORD_SIZE -1:0] if_id_pc, 
					output logic [`WORD_SIZE -1:0] if_id_instruction, 
						input logic clk,reset, 
						input logic [`WORD_SIZE -1:0] address,
						input logic [31:0]instruction
						);
										
	// Saving logics from fetch to decode 
	always_ff @ (posedge clk) begin 
		if (reset) begin 
		if_id_pc <= address;
		if_id_instruction <= 32'd0; 
		end 
		if_id_pc <= address;
		if_id_instruction <= instruction; 
	end 
	
	 
endmodule
			
