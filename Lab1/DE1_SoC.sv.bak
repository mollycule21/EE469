// Molly Le 
// Student ID: 1727364
// Lab Number 1

/* Top-level module for DE1-SoC hardware connections to implement a parking lot occupancy counter 
	The inputs are connected to KEY[0] and KEY[1] representing the inside and outside sensors 
	The outputs are connected to GPIO_0[12], GPIO_0[13] to LEDS to light up when the sensors are blocked 
	The ouputs number of occupants are display on and HEX5 through HEX1. 
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0, clk);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_0;
	input  logic [3:0] KEY;
	input  logic [9:0] SW;
   input logic clk;

	// Assign the pin labeled “AG16 KEY2” to true (3.3V) when KEY0 is pressed 
	assign GPIO_0[12] = ~ KEY[0];
	
	// Assign the pin labeled “AE16 KEY2” to true (3.3V) when KEY1 is pressed
	assign GPIO_0[13] = ~ KEY[1];
	
	// Assign the pin labeled “AE17 LEDR0”  and "AC20 LEDR1" to false (0V)
	assign GPIO_0[18] = 0; 
	assign GPIO_0[19] = 0;
	
	// determiines whether the car is exiting or entering
	logic exit, enter;
	moveCars mc (.exit(exit), .enter(enter), .out(~KEY[0]), .in(~KEY[1]), .reset(SW[9]), .clk(clk));
	
	// determines the number of cars in the parking lot 
	logic [4:0] totalOccupants;
	counter totalCars (.totalOccupants(totalOccupants), .exited(exit), .entered(enter), .clk(clk), .reset(SW[9]));
	
	// displays the number of cars in the parking lot 
	displayOccupancy displayTotalCars (.HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX2(HEX2), .HEX1(HEX1), .HEX0(HEX0), .totalOccupants(totalOccupants), .reset(SW[9]));
	

endmodule  // DE1_SoC


/* testbench for the DE1_SoC */
module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [35:0] GPIO_0;
	logic clk;
	
	// using SystemVerilog's implicit port connection syntax for brevity
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
