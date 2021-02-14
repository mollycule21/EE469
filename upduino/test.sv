module test(clk, reset, x, out);
	input logic clk, reset;
	input logic x;
	output logic out;
	logic y;	
	assign y = x + 2;

	always_ff@(posedge clk) begin
		if (reset) out <= 0;
		else out <= y;
	end
endmodule
