`define WORD_SIZE		32

module alu_tb();
	`include "constants.svh"
	logic clk, reset;
	logic [3:0]control;
	logic take_branch;
	logic signed [`WORD_SIZE - 1:0]in_1, in_2;
	logic signed [`WORD_SIZE - 1:0]out;

	// dut
	alu alu_dut(.clk(clk), .reset(reset), .control(control),
				.in_1(in_1), .in_2(in_2), .out(out), .take_branch(take_branch));

	// set up clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	// output vars
	initial begin
		$dumpfile("alu.vcd");
		$dumpvars(0, clk, reset, control, in_1, in_2, out, take_branch);
	end

	// tests
	initial begin
		reset <= 1;														@(posedge clk);
		// addition
		reset <= 0; 
		control <= ALU_ADD_I; in_1 <= 32'd9; in_2 <= 32'd11;			@(posedge clk);	
		// subtraction, result is negative
		control <= ALU_SUB_I;											@(posedge clk);
		// subtraction, result is positive
		in_1 <= 32'd11; in_2 <= 32'd9;									@(posedge clk);
		// and
		control <= ALU_AND_I; in_1 <= -32'd1; in_2 <= 32'd0;			@(posedge clk);
		// or
		control <= ALU_OR_I; 											@(posedge clk);
		// xor
		control <= ALU_XOR_I; in_1 <= -32'd1; in_2 <= -32'd1;			@(posedge clk);
		// sl
		control <= ALU_SLL_I; in_1 <= 32'd30; in_2 <= 32'd5;			@(posedge clk);
		// srl
		control <= ALU_SRL_I;											@(posedge clk);
		// sra
		control <= ALU_SRA_I;											@(posedge clk);
		// branch if equal
		control <= ALU_BEQ; in_1 <= 32'd10; in_2 <= 32'd10;				@(posedge clk);
		// branch if not equal
		control <= ALU_BNE; in_1 <= -32'd9; in_2 <= 32'd9;				@(posedge clk);
		// branch if less than
		control <= ALU_BLT;												@(posedge clk);
		// branch if greater equal
		control <= ALU_BGE; in_1 <= -32'd20; in_2 <= -32'd30;			@(posedge clk);
		// branch if less than unsigned
		control <= ALU_BLT_U; in_1 <= 32'd10; in_2 <= 32'hffffff00;		@(posedge clk);
		// branch if greater equal unsigned
		control <= ALU_BGE_U; in_1 <= 32'hffffff00; in_2 <= 32'd10;		@(posedge clk);
		// set less than
		control <= ALU_SLT_I; in_1 <= -32'd10; in_2 <= 32'd90;			@(posedge clk);
		// set less than unsigned
		control <= ALU_SLT_I_U; in_1 <= 32'd10; in_2 <= 32'hffffff00;	@(posedge clk);
																		@(posedge clk);
		$finish;
	end

endmodule
