module instruction_memory_tb();
	logic clk, reset;
	logic [31:0]address;
	logic [31:0]instruction;

	// dut
	instruction_memory imem (.clk, .reset, .address, .instruction);

	// initialize clock
	parameter CLOCK_PERIOD <= 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	// tests
	initial begin
		reset <= 1;				@(posedge clk);
		reset <= 0;				@(posedge clk);
		// let it read the memory file
		// cycle through every location and making sure it is right
		$finish
	end
