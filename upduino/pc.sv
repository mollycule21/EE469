//	top-level module for program counter
//

module pc(clk, reset, address_increment_en, address_in, address_out);
	input logic clk, reset;
	input logic address_increment_en;
	input logic [31:0]address_in;
	output logic [31:0]address_out;
	
	logic [31:0]nex_address;
	
	// takes 32-bit address and increments it by 4
	pc_adder pc_adder(.address_in(address_in), .address_out(nex_address);

	// DFF logic
	always@(posedge clk) begin
		if (reset) begin 
			address_out <= 32'd0;
		end else if (address_increment_en == 0) begin
			address_out <= address_in;
		end else address_out <= nex_address;
	end

endmodule
