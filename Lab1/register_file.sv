
`define NUMBER_OF_REGS		32
`define INPUT_FILE			"./assets/register_test.txt"	

module register_file (clk, reset, read_reg_1, read_reg_2, wr_reg, 
						alu_wr_data, mem_wr_data, wr_en, read_out_1, read_out_2);
	`include "constants.svh"

	input clk, reset;
	input logic [4:0] read_reg_1, read_reg_2, wr_reg; 
	input logic [31:0] alu_wr_data, mem_wr_data;  
	input logic [1:0]wr_en; 
	output logic [31:0] read_out_1, read_out_2;

	// define regfile 
	logic[31:0] register [`NUMBER_OF_REGS - 1:0];
	
	// make sure x0 is always 0
	// assign register[0] = 32'd0;

	initial begin
		$readmemb(`INPUT_FILE, register);
	end

	// need to buffer wr_en for three clock cycles
	logic [1:0]wr_en_temp_1, wr_en_temp_2, wr_en_temp_3;
	always_ff@(posedge clk) begin
		wr_en_temp_1 <= wr_en;
		wr_en_temp_2 <= wr_en_temp_1;
		wr_en_temp_3 <= wr_en_temp_2;
	end


	// need to buffer wr_reg for three clock cycles as well
	logic [4:0] wr_reg_temp_1, wr_reg_temp_2, wr_reg_temp_3;
	always_ff@(posedge clk) begin
		wr_reg_temp_1 <= wr_reg;
		wr_reg_temp_2 <= wr_reg_temp_1;
		wr_reg_temp_3 <= wr_reg_temp_2;
	end

	// need to buffer alu_wr_data for one clock cycle
	logic [31:0]alu_wr_data_temp;
	always_ff@(posedge clk) begin
		alu_wr_data_temp <= alu_wr_data;
	end

	always_ff@(posedge clk) begin 
		if (reset) begin
			//for (int i = 0; i < `NUMBER_OF_REGS; i = i + 1) begin
			//	if (i == 2) register[i] <= 32'h00017fff;
			//	else register[i] <= 32'd0;
			//end
		end else if (wr_en == REG_WR_OFF) begin
			read_out_1 <= register[read_reg_1];
			read_out_2 <= register[read_reg_2];
		end else if ((wr_en_temp_3 == REG_WR_ALU ||
						wr_en_temp_3 == REG_WR_MEM)
						&& wr_reg_temp_3 == 5'b0) begin
			register[wr_reg_temp_3] <= 32'b0;
		end else if (wr_en_temp_3 == REG_WR_ALU) begin 
			register[wr_reg_temp_3] <= alu_wr_data_temp; 
		end else if (wr_en_temp_3 == REG_WR_MEM) begin
			register[wr_reg_temp_3] <= mem_wr_data;
		end else begin
			read_out_1 <= 32'bx;
			read_out_2 <= 32'bx;
		end
	end 

endmodule 






//// Correct - cofirmed on modelsim 
//module register_file_testbench();
//	logic [4:0] read_reg_1, read_reg_2, wr_reg;
//	logic [31:0] wr_data;  
//	logic wr_en, clk; 
//	logic [31:0] read_out_1, read_out_2;
//	 
//
//	register_file dut (.read_reg_1, .read_reg_2, .wr_reg, .wr_data, .wr_en, .clk, .read_out_1, .read_out_2);
//	
//	
//	// Set up the clock.
//	parameter CLOCK_PERIOD=100;
//	
//	initial begin
//		clk = 1;
//		forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	end
// 
//	 // Set up the inputs to the design. Each line is a clock cycle.
//	initial begin
//		@(posedge clk);
//
//		wr_en <= 0; 
//		@(posedge clk);
//		read_reg_1 <= 4'd2; 
//		read_reg_2 <= 4'd4;
//		wr_reg <= 4'd8; 
//		wr_data <= 32'd16; 
//		repeat(3) @(posedge clk);
//		wr_en <= 1; 
//		repeat(3) @(posedge clk); // read_out_1 = 20, read_out_2 = 40 (outputs), register[8] = 16
//
//	 	$finish; // End the simulation.
//	 end
//		
//endmodule  // register_file_testbench

			
