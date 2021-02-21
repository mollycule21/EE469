// Molly Le 
// EE 439 Lab 1 


module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0, clk);

	logic [5:0] address; 
	logic [31:0] instruction; 
	
	instruction_memory IM (.address, .clk, .reset, .instruction); 
	// wr_data from ALU-module not done 
	register_file RF(.read_reg_1(instruction[5:0]), .read_reg_2(instruction[11:6]), .wr_reg(instruction[17:12]), .wr_data, .wr_en, .clk, .read_out_1, .read_out_2);
	
	
endmodule  // DE1_SoC


module DE1_SoC_testbench();


	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_0, .clk);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk = 1;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
 
	 // Set up the inputs to the design. Each line is a clock cycle.
	initial begin
	@(posedge clk);
		SW[9] <= 1;
		@(posedge clk);
		SW[9] <= 0;
		KEY[0] <= 1; KEY[1] <= 1; //~ key = active high 
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 1;
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 1; // enter end
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 1;
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 1; // enter end 
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 1;
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 1; // enter end
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 1;
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 1; // enter end
		repeat(3) @(posedge clk);
		KEY[0] <= 1; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 0;
		repeat(3) @(posedge clk);
		KEY[0] <= 0; KEY[1] <= 1;
		repeat(3) @(posedge clk);
		KEY[1] <= 1; KEY[0] <= 1; 
		repeat(3) @(posedge clk);  // exit end 
		 
	 $stop; // End the simulation.
	 end
		
	endmodule  // DE1_SoC_testbench
