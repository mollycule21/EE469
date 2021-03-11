module mem_wb (output logic [31:0] mem_wb_pc, mem_wb_instruction,
						output logic [31:0] data_mem_output_final, 
						output logic [31:0] alu_output_final, 
						input logic [31:0] ex_mem_pc, ex_mem_instruction, 
						input logic [31:0] data_mem_output,
						input logic [31:0] ex_alu_output,
						input clk);
	
		always_ff @(posedge clk) begin 
			mem_wb_pc <= ex_mem_pc;  
			mem_wb_instruction <= ex_mem_instruction; // instruction 
			data_mem_output_final <= data_mem_output; 
			alu_output_final <= ex_alu_output; 
		end 

endmodule 