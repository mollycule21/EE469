// Fetch: read the instruction from code memory
// Read instruction from instruction memory module before inputting into control signal 

module if_id (	output logic [`WORD_SIZE -1:0] if_id_pc, 
					output logic [`WORD_SIZE -1:0] if_id_instruction, 
						input logic clk, reset, 
						input logic [`WORD_SIZE -1:0] address, instruction
						);
										
	// Saving logics from fetch to decode 
	always_ff @ (posedge clk) begin 
		if_id_pc <= address;
		if_id_instruction <= instruction; 
	end 
	
	always_comb begin 
		
	
	end 
	 
endmodule
			
