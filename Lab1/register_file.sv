
`define NUMBER_OF_REGS		32

module register_file (clk, reset, read_reg_1, read_reg_2, wr_reg, 
						wr_data, wr_en, read_out_1, read_out_2);
	input clk, reset;
	input logic [4:0] read_reg_1, read_reg_2, wr_reg; 
	input logic [31:0] wr_data;  
	input logic wr_en; 
	output logic [31:0] read_out_1, read_out_2;

	// define regfile 
	logic[31:0] register [`NUMBER_OF_REGS - 1:0];
	
	// initialize regfile to all 0 
	initial begin 
		for (int i = 0; i < `NUMBER_OF_REGS; i = i + 1) begin 
			register[i] = 32'd0;
		end 
	end 


	always_ff@(posedge clk) begin 
		if (reset) begin
			for (int i = 0; i < `NUMBER_OF_REGS; i = i + 1) begin
				register[i] <= 32'd0;
			end
		end else if (wr_en) begin 
			register[wr_reg] <= wr_data; 
		end else begin
			read_out_1 <= register[read_reg_1];
			read_out_2 <= register[read_reg_2];
		end
	end 

endmodule 






// Correct - cofirmed on modelsim 
module register_file_testbench();
	logic [4:0] read_reg_1, read_reg_2, wr_reg;
	logic [31:0] wr_data;  
	logic wr_en, clk; 
	logic [31:0] read_out_1, read_out_2;
	 

	register_file dut (.read_reg_1, .read_reg_2, .wr_reg, .wr_data, .wr_en, .clk, .read_out_1, .read_out_2);
	
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk = 1;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
 
	 // Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		@(posedge clk);

		wr_en <= 0; 
		@(posedge clk);
		read_reg_1 <= 4'd2; 
		read_reg_2 <= 4'd4;
		wr_reg <= 4'd8; 
		wr_data <= 32'd16; 
		repeat(3) @(posedge clk);
		wr_en <= 1; 
		repeat(3) @(posedge clk); // read_out_1 = 20, read_out_2 = 40 (outputs), register[8] = 16

	 $stop; // End the simulation.
	 end
		
	endmodule  // register_file_testbench

			
