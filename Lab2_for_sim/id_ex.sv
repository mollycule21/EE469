

module id_ex (
	output logic [31:0] id_ex_alu_in_1, id_ex_alu_in_2, 
	output logic [31:0] id_ex_pc, id_ex_instruction, 
	output logic [31:0] EX_out_1, EX_out_2,
	
   	input logic [1:0] forwardA, forwardB, 
	input logic [31:0] read_out_1, read_out_2, // set to register read_out values if no forwarding 
	input logic [31:0] alu_out, mem_read_out, wb_data_out, // overide register file outputs if forwarding 
	input logic [31:0] if_id_pc, if_id_instruction, // saving logics for printf at pipeline 
	input logic clk
	); 
					
	// output logic logic id_ex_alu_in_1
	// input logic alu_out, mem_read_out 
	always_ff @(negedge clk) begin 
		if(forwardA == 2'b01) begin 
			id_ex_alu_in_1 <= alu_out; 
		end else if (forwardA == 2'b10) begin 
			id_ex_alu_in_1 <= mem_read_out; 
		end else if (forwardA == 2'b11) begin 
			id_ex_alu_in_1 <= wb_data_out;
		end else begin 
			id_ex_alu_in_1 <= read_out_1;
		end 
		
		if(forwardB == 2'b01) begin 
			id_ex_alu_in_2 <= alu_out; 
		end else if (forwardB == 2'b10) begin 
			id_ex_alu_in_2 <= mem_read_out; 
		end else if (forwardB == 2'b11) begin 
			id_ex_alu_in_2 <= wb_data_out;
		end else begin 
			id_ex_alu_in_2 <= read_out_2;
		end 	
	end 
	
	// Saving logics from fetch to decode 
	always_ff @ (posedge clk) begin 
		id_ex_pc <= if_id_pc; 
		id_ex_instruction <= if_id_instruction;
		// clock to check for previous outputs of register as next instruction is in decoder stage, input to register_file module 
		EX_out_1 <= read_out_1; 
		EX_out_2 <= read_out_2; 
	end 
							
endmodule
	
//// Correct on Modelsim as of 3/10/21
//module id_ex_tb (); 
//	logic [31:0] id_ex_alu_in_1, id_ex_alu_in_2; 
//	logic [4:0] EX_Rd; 
//	logic [31:0] id_ex_pc, id_ex_instruction, EX_out_1, EX_out_2;
//   logic [1:0] forwardA, forwardB; 
//	logic [31:0] read_out_1, read_out_2;  // set to register read_out values if no forwarding takes place
//	logic [31:0] alu_out, mem_read_out, wb_data_out; 
//	logic [31:0] if_id_pc, if_id_instruction; 
//	logic [4:0] rd;  
//	logic clk; 
//	
//	id_ex dut(
//	.id_ex_alu_in_1, .id_ex_alu_in_2, 
//	.EX_Rd, 
//	.id_ex_pc, .id_ex_instruction, .EX_out_1, .EX_out_2, 
//   .forwardA, .forwardB, 
//	.read_out_1, .read_out_2, // set to register read_out values if no forwarding 
//	.alu_out, .mem_read_out, .wb_data_out, // overide register file outputs if forwarding 
//	.if_id_pc, .if_id_instruction, // saving logics for printf at pipeline 
//	.rd, 
//	.clk
//	); 
//		
//	
//	// Set clock
//	parameter CLOCK_PERIOD = 100; 
//	
//	initial begin 
//		clk <= 1; 
//		forever #(CLOCK_PERIOD/2) clk <= ~clk; 
//	end 
//	
//	// Set inputs to run test 
//	
//	initial begin 
//		@(posedge clk); 
//		forwardA <= 2'b00;  forwardB <= 2'b00;
//		read_out_1 <= 32'd1; read_out_2 <= 32'd2;
//		alu_out <= 32'd3; mem_read_out <= 32'd4; wb_data_out <= 32'd5; 
//		if_id_pc <= 32'd5; if_id_instruction <= 32'd6;
//		rd <= 5'd1; 
//		@(posedge clk); // id_ex_alu_in_1 = 32'd1, id_ex_alu_in_2 = 32'd1, Ex_Rd = 1, id_ex_pc = 32'd5, id_ex_instruction = 32'd6,
//		
//		forwardA <= 2'b01;  forwardB <= 2'b01; // ex
//		@(posedge clk); // id_ex_alu_in_1 = 32'd3, id_ex_alu_in_2 = 32'd3
//		
//		forwardA <= 2'b10;  forwardB <= 2'b10; // mem
//		repeat (4) @(posedge clk); // id_ex_alu_in_1 = 32'd4, id_ex_alu_in_2 = 32'd4
//		
//		forwardA <= 2'b11;  forwardB <= 2'b11; // wb
//		repeat (8) @(posedge clk); // id_ex_alu_in_1 = 32'd5, id_ex_alu_in_2 = 32'd5
//		
//		$stop; 
//	end 
//	
//
//endmodule
