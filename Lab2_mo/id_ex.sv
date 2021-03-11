module id_ex (
	output logic [31:0] read_out_1_final, read_out_2_final, 
	output logic [4:0] EX_Rd, 
	output logic [31:0] id_ex_pc, id_ex_instruction, EX_out_1, EX_out_2, 
   input logic [1:0] forwardA, forwardB, 
	input logic [31:0] read_out_1, read_out_2, // set to register read_out values if no forwarding 
	input logic [31:0] alu_out, mem_read_out, wb_data_out, // overide register file outputs if forwarding 
	input logic [31:0] if_id_pc, if_id_instruction, // saving logics for printf at pipeline 
	input logic [4:0] rd, 
	input logic clk
	); 
							
	// output logic logic read_out_1_final
	// input logic alu_out, mem_read_out 
	always_ff @(posedge clk) begin 
		if(forwardA == 2'b01) begin 
			read_out_1_final <= alu_out; 
		end else if (forwardA == 2'b10) begin 
			read_out_1_final <= mem_read_out; 
		end else if (forwardA == 2'b11) begin 
			read_out_1_final <= wb_data_out;
		end else begin 
			read_out_1_final <= read_out_1;
		end 
		
		if(forwardB == 2'b01) begin 
			read_out_2_final <= alu_out; 
		end else if (forwardB == 2'b10) begin 
			read_out_2_final <= mem_read_out; 
		end else if (forwardB == 2'b11) begin 
			read_out_2_final <= wb_data_out;
		end else begin 
			read_out_2_final <= read_out_2;
		end 
	end 
	
	// Saving logics from decode to execute stage 
	 always_ff @ (posedge clk) begin
		id_ex_pc <= if_id_pc; 
		id_ex_instruction <= if_id_instruction; // instruction 
		EX_out_1 <= read_out_1_final; // saving register readings for printf 
		EX_out_2 <= read_out_2_final; // saving register reading for printf 
		EX_Rd <= rd; // saving rd to check for forwarding for future instructins 
	 end 
							
endmodule

// Correct on Modelsim as of 3/10/21
module id_ex_tb (); 
	logic [31:0] read_out_1_final, read_out_2_final; 
	logic [4:0] EX_Rd; 
	logic [31:0] id_ex_pc, id_ex_instruction, EX_out_1, EX_out_2;
   logic [1:0] forwardA, forwardB; 
	logic [31:0] read_out_1, read_out_2;  // set to register read_out values if no forwarding takes place
	logic [31:0] alu_out, mem_read_out, wb_data_out; 
	logic [31:0] if_id_pc, if_id_instruction; 
	logic [4:0] rd;  
	logic clk; 
	
	id_ex dut(
	.read_out_1_final, .read_out_2_final, 
	.EX_Rd, 
	.id_ex_pc, .id_ex_instruction, .EX_out_1, .EX_out_2, 
   .forwardA, .forwardB, 
	.read_out_1, .read_out_2, // set to register read_out values if no forwarding 
	.alu_out, .mem_read_out, .wb_data_out, // overide register file outputs if forwarding 
	.if_id_pc, .if_id_instruction, // saving logics for printf at pipeline 
	.rd, 
	.clk
	); 
		
	
	// Set clock
	parameter CLOCK_PERIOD = 100; 
	
	initial begin 
		clk <= 1; 
		forever #(CLOCK_PERIOD/2) clk <= ~clk; 
	end 
	
	// Set inputs to run test 
	
	initial begin 
		@(posedge clk); 
		forwardA <= 2'b00;  forwardB <= 2'b00;
		read_out_1 <= 32'd1; read_out_2 <= 32'd2;
		alu_out <= 32'd3; mem_read_out <= 32'd4; wb_data_out <= 32'd5; 
		if_id_pc <= 32'd5; if_id_instruction <= 32'd6;
		rd <= 5'd1; 
		@(posedge clk); // read_out_1_final = 32'd1, read_out_2_final = 32'd1, Ex_Rd = 1, id_ex_pc = 32'd5, id_ex_instruction = 32'd6,
		
		forwardA <= 2'b01;  forwardB <= 2'b01; // ex
		@(posedge clk); // read_out_1_final = 32'd3, read_out_2_final = 32'd3
		
		forwardA <= 2'b10;  forwardB <= 2'b10; // mem
		repeat (4) @(posedge clk); // read_out_1_final = 32'd4, read_out_2_final = 32'd4
		
		forwardA <= 2'b11;  forwardB <= 2'b11; // wb
		repeat (8) @(posedge clk); // read_out_1_final = 32'd5, read_out_2_final = 32'd5
		
		$stop; 
	end 
	

endmodule
