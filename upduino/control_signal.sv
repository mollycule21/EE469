// handles intructions
// outputs control signals

// inputs 32 bit instruction from instruction memory 
// inputs RISU_type from regfile_datapath

`include "constants.svh"

`define WORD_SIZE	32


module control_signal(instruction, mem_write, reg_write, branch, alu_signal);
	input logic [`WORD_SIZE - 1 : 0] instruction; 
	input logic mem_write, reg_write, branch; 	// if need to write to memory or register
	input logic [2:0]alu_signal;			// control signal for alu
	
	// reads what opcode is passed in to determine type (RISU) of instruction 
	logic [1:0] RISU_type; 
	logic [6:0] opcode; 
	op_type ot (.instruction(instruction), .RISU_type(RISU_type), .opcode(opcode)) 
	
	logic [6:0] funct_7; 
	logic [4:0] rs1, rs2, rd; 
	logic [2:0] funct_3; 
	
	logic [11:0] imm_I;
	logic [6:0] imm_S_7;
	logic [4:0] imm_S_5;
	
	logic [19:0] imm_U; 
	

	// takes in type (RISU) and organizes the 32 bit instruction 
	always_comb begin
		// R type 
		if (RISU_type == 00) begin 
			funct_7	= instruction[31:25];
			rs2 = instruction[24:20];
			rs1 = instruction[19:15];
			funct_3	= instruction[14:12];
			rd = instruction[11:7];
		// I type 
		end else if (RISU_type == 01) begin
			imm_I = instruction[31:20];
			rs1 = instruction[19:15];
			funct3 = instruction[14:12];
			rd = instruction[11:7];
		// S type 
		end else if (RISU_type == 10) begin
			imm_S_7[11:5] = instruction[31:25];
			rs2 = instruction[24:20];
			rs1 = instruction[19:15];
			funct3	= instruction[14:12];
			imm_S_5[4:0] = instruction[11:7];
		// U-type
		end else begin
			imm_U = instruction[31:12];
			rd = instruction[11:7];
		end
	end
	
	// R type only logic 
	logic [9:0]funct_7_3;// funct7 and funct3 concated
	assign funct_7_3 = {funct7, funct3};
	
	
	
	regfile_datapth (.opcode) 
	
	
	
	
endmodule
