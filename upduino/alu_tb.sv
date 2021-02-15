`define WORD_SIZE		32

module alu_tb();
	logic clk, reset;
	logic [2:0]control;
	logic signed [`WORD_SIZE - 1:0]in_1, in_2;
	logic signed [`WORD_SIZE - 1:0]out;

	// dut
	alu alu_dut(.clk(clk), .reset(reset), .control(control),
				.in_1(in_1), .in_2(in_2), .out(out));

	// set up clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	// output vars
	initial begin
		$dumpfile("alu.vcd");
		$dumpvars(0, clk, reset, control, in_1, in_2, out);
	end

	// tests
	initial begin
		reset <= 1;														@(posedge clk);
		// addition
		reset <= 0; control <= 3'b000; in_1 <= 32'd9; in_2 <= 32'd11;	@(posedge clk);	
		// subtraction
		control <= 3'b001;												@(posedge clk);
		in_1 <= 32'd11; in_2 <= 32'd9;									@(posedge clk);
		// and
		control <= 3'b010; in_1 <= -32'd1; in_2 <= 32'd0;				@(posedge clk);
		// or
		control <= 3'b011; 												@(posedge clk);
		// xor
		control <= 3'b100; in_1 <= -32'd1; in_2 <= -32'd1;				@(posedge clk);
		// sl
		control <= 3'b101; in_1 <= 32'd30; in_2 <= 32'd5;				@(posedge clk);
		// srl
		control <= 3'b110;												@(posedge clk);
		// sra
		control <= 3'b111;												@(posedge clk);
																		@(posedge clk);
		$finish;
	end

endmodule
