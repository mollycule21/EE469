// 32 bit output address_out from pc.sv is inputted into this mododule as instruction 

`define WORD_SIZE	32

module instruction_type(instruction, instruction_type, opcode);
	`include "constants.svh";
	input logic [`WORD_SIZE - 1:0]instruction;

	output logic [2:0] instruction_type; 	
	output logic [6:0] opcode; 
	
	`include "constants.svh"
	
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
		case(opcode)
			op:			instruction_type = INSTRUCTION_TYPE_R; 
			op_imm:		instruction_type = INSTRUCTION_TYPE_I;
			jalr:			instruction_type = INSTRUCTION_TYPE_I;
			load:			instruction_type = INSTRUCTION_TYPE_I;
			branch:		instruction_type = INSTRUCTION_TYPE_B;
			store:		instruction_type = INSTRUCTION_TYPE_S;
			lui:			instruction_type = INSTRUCTION_TYPE_U; // load upgrade immediate
			auipc:		instruction_type = INSTRUCTION_TYPE_U;
			jal:			instruction_type = INSTRUCTION_TYPE_J;
			default: 	instruction_type = INSTRUCTION_TYPE_R; 
		endcase
	end

endmodule 

// Correct on Modelsim 
module instruction_type_tb(); 

	logic [`WORD_SIZE - 1:0]instruction;
	logic [2:0] instruction_type; 	
	logic [6:0] opcode; 
	
	`include "constants.svh"
	
	instruction_type dut (.instruction, .instruction_type, .opcode);
	
	// Test inputs 
	initial begin
		#100;
		instruction <= {25'd0, op};  		#100; 	// INSTRUCTION_TYPE_R = 3'b000
		
		instruction <= {25'd0, op_imm};  	#100; 	// INSTRUCTION_TYPE_I = 3'b001;
		instruction <= {25'd0, jalr};  	#100; 
		instruction <= {25'd0, load};  	#100; 
		
		instruction <= {25'd0, branch};  	#100; 	// INSTRUCTION_TYPE_B = 3'b100;	
		
		instruction <= {25'd0, store};  	#100; 	// INSTRUCTION_TYPE_S = 3'b010;
		
		instruction <= {25'd0, lui};  		#100; 	// INSTRUCTION_TYPE_U = 3'b011;
		instruction <= {25'd0, auipc};  	#100; 	// INSTRUCTION_TYPE_U = 3'b011;
		
		instruction <= {25'd0, jal};  		#100; 	// INSTRUCTION_TYPE_J = 3'b101;		
		
	 $stop; // End the simulation.
	 end
		
	endmodule  // pc_adder_estbench

		case(opcode) begin
		op:		instruction_type = INSTRUCTION_TYPE_R; 
		op_imm:		instruction_type = INSTRUCTION_TYPE_I;
		jalr:		instruction_type = INSTRUCTION_TYPE_I;
		load:		instruction_type = INSTRUCTION_TYPE_I;
		branch:		instruction_type = INSTRUCTION_TYPE_B;
		store:		instruction_type = INSTRUCTION_TYPE_S;
		lui:		instruction_type = INSTRUCTION_TYPE_U; // load upgrade immediate
		auipc:		instruction_type = INSTRUCTION_TYPE_U;
		jal:		instruction_type = INSTRUCTION_TYPE_J;
		end
	end

endmodule 			
