module instruction_memory_tb();
	localparam NUMBER_OF_INSTRUCTIONS = 1024;
	localparam address_size = $clog2(NUMBER_OF_INSTRUCTIONS);
	localparam WORD_SIZE = 32;

	logic clk, reset;
	logic [WORD_SIZE - 1:0]address;
	logic [WORD_SIZE - 1:0]instruction;

	// dut
	instruction_memory imem (.clk, .reset, .address, .instruction);

	// initialize clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		$dumpfile("instruction_memory.vcd");
		$dumpvars(0, clk, reset, address, instruction);
	end

	// tests
	initial begin
		address <= 32'd0; reset <= 1; 	@(posedge clk);
		reset <= 0;						@(posedge clk);
		// let it read the memory file
		// cycle through every location and making sure it is right
										@(posedge clk);
										@(posedge clk);
		address <= 32'd0;				@(posedge clk);
		address <= 32'd1;				@(posedge clk);
		address <= 32'd2;				@(posedge clk);
		address <= 32'd3;				@(posedge clk);
		address <= 32'd4;				@(posedge clk);
		address <= 32'd5;				@(posedge clk);
		address <= 32'd6;				@(posedge clk);
		address <= 32'd7;				@(posedge clk);
		address <= 32'd8;				@(posedge clk);
		address <= 32'd9;				@(posedge clk);
		address <= 32'd10;				@(posedge clk);
		address <= 32'd11;				@(posedge clk);
		address <= 32'd12;				@(posedge clk);
		address <= 32'd13;				@(posedge clk);
		address <= 32'd14;				@(posedge clk);
		address <= 32'd15;				@(posedge clk);
		address <= 32'd16;				@(posedge clk);
		address <= 32'd17;				@(posedge clk);
		// checking for out of bounds condition
		// when address exceeds instruction memory size
		//address <= 32'hffffff;	@(posedge clk);
		$finish;
	end
endmodule

