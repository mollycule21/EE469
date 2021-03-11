module ex_mem (output logic [4:0] MEM_Rd, 
						output logic [31:0] ex_mem_pc, ex_mem_instruction, MEM_out_1, MEM_out_2, 
						input logic [4:0] EX_Rd, 
						input logic [31:0] id_ex_pc, id_ex_instruction, EX_out_1, EX_out_2,
						input logic [31:0]alu_output, 
						input logic take_branch
						input clk; 

	
	// Saving logics from decode to execute stage 
	always_ff @ (posedge clk) begin
		ex_mem_pc <= id_ex_pc; 
		ex_mem_instruction <= id_ex_instruction; // instruction 
		MEM_out_1 <= EX_out_1; // saving execute readings for printf 
		MEM_out_2 <= EX_out_2; // saving execute readings for printf 
		MEM_Rd <= EX_Rd; // saving EX_rd to check for forwarding for future instructins 
		alu_output_final <= alu_output; // not sure how to implement 
		take_branch_final <= take_branch; // not sure how to implement 
	end 
	
	
	// thoughts : if take branch is true, maybe add another logic  to see if branch instruction holds and if so, 
	// input same logic in pc and tell cpu to get rid of next 2 instructions 
endmodule 