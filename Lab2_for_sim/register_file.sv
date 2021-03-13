
`define NUMBER_OF_REGS		32
`define INPUT_FILE			"../assets/register.txt"	

							
module register_file (clk, reset, read_reg_1, read_reg_2, wr_reg,  WB_data,
								do_WB, EX_out_1, EX_out_2, 
								read_out_1, read_out_2);
	`include "constants.svh"
	// got rid of alu
	input logic clk, reset;
	input logic [4:0] read_reg_1, read_reg_2, wr_reg; 
	input logic [31:0] WB_data;
	input logic [31:0] EX_out_1, EX_out_2; 
	// input logic write_half, read_half; 
	input logic do_WB; 
	output logic [31:0] read_out_1, read_out_2;

	// define regfile 
	logic[31:0] register [`NUMBER_OF_REGS - 1:0];
	
	// make sure x0 is always 0
	// assign register[0] = 32'd0;

	initial begin
		$readmemb(`INPUT_FILE, register);
	end

	// write back 
	always_ff @(posedge clk) begin 
		if (do_WB) begin 
			register[wr_reg] <= WB_data; 
		end else begin 
			register[wr_reg] <= register[wr_reg]; 
		end 
	end 
	
	// getting read outputs of source registers 
	always_ff@(negedge clk) begin 
		read_out_1 <= register[read_reg_1];
		read_out_2 <= register[read_reg_2];
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

			
