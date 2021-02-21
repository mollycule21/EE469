<<<<<<< HEAD
=======

>>>>>>> 87a68024dc4cc71812ce6563ccefe90a5c547843
`define WORD_SIZE		32

module pc_mux(address_from_increment, address_from_branch, alu_branch, control_branch, pc_out);
	input logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch;
	input logic alu_branch, control_branch;
	output logic [`WORD_SIZE - 1:0]pc_out;

	always_comb begin
		if (alu_branch && control_branch) pc_out = address_from_branch;
		else pc_out = address_from_increment;
	end

endmodule
<<<<<<< HEAD

// Correct on Modelsim 
module pc_mux_tb(); 
	logic [`WORD_SIZE - 1:0]address_from_increment, address_from_branch;
	logic alu_branch, control_branch;
	logic [`WORD_SIZE - 1:0]pc_out;
	
	pc_mux dut (.address_from_increment, .address_from_branch, .alu_branch, .control_branch, .pc_out);
	
	parameter DELAY = 100; 
	
	initial begin
		#DELAY 
		alu_branch <= 0; control_branch <= 0; address_from_increment <= 32'd2; address_from_branch <= 32'd4;  #DELAY // pc_out = 32'd2
							  control_branch <= 1; #DELAY
		alu_branch <= 1; control_branch <= 0; #DELAY
		alu_branch <= 1; control_branch <= 1; #DELAY // pc_out = 32'd4
	
		
	$stop; 
	end 
	
endmodule 
=======
>>>>>>> 87a68024dc4cc71812ce6563ccefe90a5c547843
