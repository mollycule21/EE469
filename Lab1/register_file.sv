// UART = "usb port" 
// 1) code from computer 
// 2) rv32-i complier compiles code into binary form and exports a file 
// 3) take files and send it to hardware 
// 4) instruction memory will read memory file and load all contents inside memeory file into 2D array 
// 5) use address to specify which apart of 2D arrary we want to acces 


module register_file (input logic [4:0] read_reg_1, read_reg_2, wr_reg, 
						input logic [31:0] wr_data,  
						input logic wr_en, 
						input clk,  
						output logic [31:0] read_out_1, read_out_2);
	
	//need to implement register? 
	// logic [31:0] [31:0] regsiter 
	logic [31:0] register [31:0] ;
	
	assign register[2] = 32'd20;
	assign register[4] = 32'd40; 
	assign register[8] = 32'd80; 

	assign read_out_1 = register[read_reg_1];
	assign read_out_2 = register[read_reg_2];

	always @(posedge clk) begin 
		if (wr_en) begin 
			register[wr_reg] <= wr_data; 
		end 
	end 

endmodule 

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
		repeat(3) @(posedge clk); //read_out_1, read_out_2; 

	 $stop; // End the simulation.
	 end
		
	endmodule  // register_file_testbench

			