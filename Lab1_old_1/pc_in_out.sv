
module pc_in_out (clk, reset, address_in, address_out);
	input logic clk, reset;
	input logic [31:0]address_in;
	output logic [31:0]address_out;
	
	
	// DFF logic
	always_ff @(posedge clk) begin
		if (reset) begin 
			address_out <= 32'd0;
		end else begin 
			address_out <= address_in;
		end
	end
	
	
endmodule 

// Correct on Modelsim 
module pc_in_out_tb(); 

	logic clk, reset;
	logic [31:0]address_in;
	logic [31:0]address_out;
	
	pc_in_out dut (.clk, .reset, .address_in, .address_out);
	
	// Set up clock 
	parameter CLOCK_PERIOD = 100; 
	
	initial begin 
		clk = 1;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; 
	end 
	
	initial begin 
		repeat (2) @(posedge clk); 
		
		reset <= 1; address_in <= 32'd4; repeat (2) @(posedge clk); // address_out = 32'd0
		reset <= 0; 							repeat (2) @(posedge clk); // address_out = 32'd4
		
		$stop;
	end
	
endmodule 
