// adder for auipc and branch instructions
`define WORD_SIZE		32

module branch_adder(pc, imm, imm_U_J, imm_en, pc_out);
	`include "constants.svh"
	input logic [`WORD_SIZE - 1:0]pc;
	input logic [11:0]imm;			// for branch operations
	input logic [19:0]imm_U_J;		// for lui operations
	input logic [1:0]imm_en;		// tells us which immediate value to take
	output logic [`WORD_SIZE - 1:0]pc_out;
	
	logic [`WORD_SIZE - 1:0]temp;
	logic dummy; 
	always_comb begin
		case(imm_en)
		ALU_READ_IMM: begin
			temp = {19'd0, imm, 1'b0}; // disregarding 0 b/c it's always 0 in risc v instruction manual 
		end
		ALU_READ_IMM_U_J: begin
			temp[`WORD_SIZE - 1:12] = imm_U_J;
		end
		// default: temp = 32'd0; 
		
		endcase
	end 

	always_comb begin
		pc_out = (pc + temp);		
	end

endmodule

module branch_adder_tb();

	`include "constants.svh"
	logic [`WORD_SIZE - 1:0]pc;
	logic [11:0]imm;			// for branch operations
	logic [19:0]imm_U_J;		// for lui operations
	logic [1:0]imm_en;		// tells us which immediate value to take
	logic [`WORD_SIZE - 1:0] pc_out;
	
	branch_adder dut (.pc, .imm, .imm_U_J, .imm_en, .pc_out);
	
	parameter DELAY = 50; 
	
	initial begin 
		#DELAY 
		
		imm_en <= 00;												#DELAY;		
		imm <= 12'b000000000101; 								
		pc <= {20'd0, 12'b010101010101}; 					#DELAY; 
		imm_en <= ALU_READ_IMM;									#DELAY; // pc_out = {20'd0, 12'b101010101111}
		
		imm_en <= 00;												#DELAY;
		imm_U_J <= 20'b10101010101010101010;
		pc <= {20'b01010101010101010101, 12'd0}; 			#DELAY; 
		imm_en <= ALU_READ_IMM_U_J;							#DELAY; // pc_out = {20'b11111111111111111111, 12'd0} 
		$stop; 
	end 
	
endmodule 
	

