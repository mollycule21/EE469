module wb (output logic [31:0] WB_data, 
		input logic [6:0] WB_reg_write,
		input logic [31:0] alu_output_final, data_mem_output_final,
		input clk);
		
		`include "constants.svh"
		always_ff @(posedge clk) begin 
			if (WB_reg_write == REG_WR_ALU) begin 
				WB_data <= alu_output_final; 
			end else if (WB_reg_write == REG_WR_MEM) begin 
				WB_data <= data_mem_output_final; 
			end else begin 
				WB_data <= 32'd0; 
			end 
		end 

endmodule 