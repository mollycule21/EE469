module mem_wb (output logic [4:0] WB_Rd, 
						output logic [31:0] mem_wb_pc, mem_wb_instruction ,WB_out_1, WB_out_2, 
						output logic [31:0] data_mem_ouput_final, 
						input logic [4:0] MEM_Rd, 
						input logic [31:0] ex_mem_pc, ex_mem_instruction, MEM_out_1, MEM_out_2, ); 
						input logic [31:0] data_mem_output 
	
		always_ff @(posedge clk) begin 
			mem_wb_pc <= ex_mem_pc;  
			mem_wb_instruction <= ex_mem_instruction; // instruction 
			WB_out_1 <= MEM_out_1; // saving execute readings for printf 
			WB_out_2 <= MEM_out_2; // saving execute readings for printf 
			WB_Rd <= MEM_Rd; // saving EX_rd to check for forwarding for future instructins 
			data_mem_output_final <= data_mem_output; 
		end 

endmodule 