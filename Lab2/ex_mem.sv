module ex_mem (output logic [31:0] ex_mem_pc, ex_mem_instruction,  
						output logic [31:0] alu_output_final, 
						output logic take_branch_final, 
						input logic [31:0] id_ex_pc, id_ex_instruction, 
						input logic [31:0]alu_output, 
						input logic take_branch,
						input logic clk); 

	
	// Saving logics from decode to execute stage 
	always_ff @ (posedge clk) begin
		ex_mem_pc <= id_ex_pc; 
		ex_mem_instruction <= id_ex_instruction; // instruction 
		alu_output_final <= alu_output; // not sure how to implement 
		take_branch_final <= take_branch; // not sure how to implement 
	end 
	
	
	// thoughts : if take branch is true, maybe add another logic  to see if branch instruction holds and if so, 
	// input same logic in pc and tell cpu to get rid of next 2 instructions 
endmodule 