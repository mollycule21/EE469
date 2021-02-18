// 32 bit output address_out from pc.sv is inputted into this mododule as instruction 

`define WORD_SIZE		32

module instruction_type(instruction, instruction_type, opcode);
	`include "constants.svh";

	input logic [`WORD_SIZE - 1:0]instruction;

	output logic [2:0] instruction_type; 	
	output logic [6:0] opcode; 

	// load opcode
	assign opcode = instruction[6:0];

	// check the opcode for which instruction type
	// R-type: op, 
	// I-type: op-imm, jalr, load 
	// S-type: store
	// U-type: lui, auipc
	// B-type: branch
	// J-type: jal
	
	// takes in opcode and determines which instruction type 
	always_comb begin
		case(opcode) begin
		op:			instruction_type = INSTRUCTION_TYPE_R; 
		op_imm:		instruction_type = INSTRUCTION_TYPE_I;
		jalr:		instruction_type = INSTRUCTION_TYPE_I;
		load:		instruction_type = INSTRUCTION_TYPE_I;
		branch:		instruction_type = INSTRUCTION_TYPE_B;
		store:		instruction_type = INSTRUCTION_TYPE_S;
		lui:		instruction_type = INSTRUCTION_TYPE_U;
		auipc:		instruction_type = INSTRUCTION_TYPE_U;
		jal:		instruction_type = INSTRUCTION_TYPE_J;
		end
	end

endmodule 
			
