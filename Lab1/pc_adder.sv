
<<<<<<< HEAD
`define WORD_SIZE	32
=======
`define WORD_SIZE		32
>>>>>>> 87a68024dc4cc71812ce6563ccefe90a5c547843

module pc_adder(pc_en, address_in, address_out);
	input logic pc_en;
	input logic [`WORD_SIZE - 1:0]address_in;
	output logic [`WORD_SIZE - 1:0]address_out;

<<<<<<< HEAD
	always_comb begin
		if (!pc_en) 
			address_out = address_in;
		else 
			address_out = address_in + 32'd4;
	end

endmodule

// Correct - ran modelsim 
module pc_adder_tb(); 
	logic [31:0] address_in, address_out;
	logic pc_en; 
	
	pc_adder dut (.pc_en, .address_in(address_in), .address_out(address_out));
	
	// Test inputs 
	initial begin
		#100;
		pc_en <= 0; 				#100
		address_in <= 32'd2;  	#100; // address_out = 32'd2
		pc_en <= 1; 				#100 	// address_out = 32'd6
		address_in <= 32'd20; 	#100; // address_out = 32'24
	 
	 $stop; // End the simulation.
	 end
		
	endmodule  // pc_adder_estbench

=======
	always begin
		if (!pc_en) address_out = address_in;
		else address_out = address_in + 4;
	end

endmodule
>>>>>>> 87a68024dc4cc71812ce6563ccefe90a5c547843
