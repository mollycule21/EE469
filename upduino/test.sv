module test;
	logic clk;
	logic [31:0]in1, in2, out;
	logic [31:0]temp;
	logic take_branch;
	
	// set up
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial $dumpfile("test.vcd");
	initial $dumpvars(0, clk, in1, in2, temp, out, take_branch);


	// check the most significant bit

	assign temp = in1 - in2;
	always_comb begin
		if (temp[31]) take_branch = 1;
		else take_branch = 0;
	end


	initial begin
		in1 <= -32'd10; in2 <= 32'd8; @(posedge clk);
		$finish;
	end

endmodule
