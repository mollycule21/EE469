`define WORD_SIZE		32
`define NUMBER_OF_REGS	32


module register_file_datapath_tb();
	logic [`WORD_SIZE - 1:0]instruction;
	logic [4:0]rs1, rs2, rd;
	logic clk;

	// dut
	register_file_datapath datapath(.instruction, .rs1, .rs2, .rd);

	// initialize clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		$dumpfile("register_file_datapath.vcd");
		$dumpvars(0, clk, instruction, rs1, rs2, rd);
	end


	// tests
	initial begin
		instruction <= 32'b0100000_11111_00011_000_11100_0110011;	@(posedge clk);
		$finish;
	end

endmodule
