// program counter

module pc_in_out(clk, reset, address_in, address_out);
	input logic clk, reset, pc_en;
	input logic [31:0]address_in;
	output logic [31:0]address_out;
	

	// DFF logic
	always@(posedge clk) begin
		if (reset) begin 
			address_out <= 32'h0000c000;
		end else  begin 
			address_out <= address_in;
		end
	end

endmodule

