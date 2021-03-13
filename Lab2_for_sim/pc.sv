// program counter

module pc(clk, reset, address_in, address_out);
	input logic clk, reset;
	input logic [31:0]address_in;
	output logic [31:0]address_out;
	

	// DFF logic
	always_ff@(posedge clk) begin
		if (reset) begin 
			address_out <= 32'h00000000;
		end else  begin 
			address_out <= address_in;
		end
	end

endmodule

