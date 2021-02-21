
`define WORD_SIZE	32


module control_signal(instruction, mem_write, reg_write, 
								alu_signal, rs1, rs2, rd,
								imm, imm_en);
	
	`include "constants.svh"

	input logic [`WORD_SIZE - 1 : 0] instruction; 
	input logic mem_write, reg_write, take_branch; 	// if need to write to memory or register
	output logic [3:0]alu_signal;							// control signal for alu
	output logic [4:0]rs1, rs2, rd;	
	output logic [1:0] imm_en; 							// 00 = read_out_2, 01 = imm, 10 = imm_U_J
	output logic [11:0]imm; 								// immediate value for I, S, B type
	output logic [19:0] imm_U_J;							// immediate value for U-type and J-type
	
	// reads the instruction and determines instruction type and opcode
	logic [2:0] instruction_type; 
	logic [6:0] opcode; 
	
	instruction_type inst_tp(.instruction(instruction), 
										.instruction_type(instruction_type), .opcode(opcode)); 
	
	// logics for instructions
	logic [6:0] funct_7; 
	logic [2:0] funct_3;  						

	// takes in type and organizes the 32 bit instruction 
	always_comb begin
		case(instruction_type) begin

		INSTRUCTION_TYPE_R: begin
			imm_en 		= 2'b00;
			funct_7		= instruction[31:25];
			rs2 			= instruction[24:20];
			rs1 			= instruction[19:15];
			funct_3		= instruction[14:12];
			rd 			= instruction[11:7];
			// outputs DNE 
			imm 			= 12'd0;
			imm_U_J 		= 
		end

		INSTRUCTION_TYPE_I: begin
			imm_en 		= 2'b01;
			imm 			= instruction[31:20];
			rs1 			= instruction[19:15];
			funct3 		= instruction[14:12];
			rd 			= instruction[11:7];
			//outputs DNE 
			rs2 			= 5'd0;
			imm_U_J 		= 20'd0;
		end
		
		INSTRUCTION_TYPE_S: begin
			// STORE:  mem[rs2[value] + imm] <- stored [rs1[value]] 
			imm_en 		= 2'b01; 
			imm[11:5]	= instruction[31:15];
			imm[4:0]		= instruction[11:7];  
			rs2			= instruction[24:20]; 
			rs1			= instruction[19:15];  
			funct3		= instruction[14:12]; 
			// outputs DNE 
			rd 			= 5'd0;
			imm_U_J		= 20'd0;
			
		end
		
		INSTRUCTION_TYPE_U: begin
			imm_en 		= 2'b01;
			imm_U_J		= instruction[31:12];
			rd				= instruction[11:7];
			// outputs DNE 
			rs1 			= 5'd0;
			rs2 			= 5'd0; 
			imm			= 12'd0;
		end
		
		INSTRUCTION_TYPE_B: begin
			imm_en 		= 2'b01;
			imm[11] 		= instruction[31];
			imm[10]		= instruction[7];
			imm[9:4]		= instruction[30:25];
			imm[3:0]		= instruction[11:8];
			rs2			= instruction[24:20];
			rs1			= instruction[19:15];
			funct3		= instruction[14:12];
			// outputs DNE 
			rd 			= 5'd0;
			imm_U_J		= 20'd0;
			
		end
		INSTRUCTION_TYPE_J: begin
			imm_en			= 2'b10;
			imm_U_J[19]		= instruction[31];
			imm_U_J[9:0]	= instruction[30:21];
			imm_U_J[10]		= instruction[20];
			imm_U_J[18:11]	= instruction[19:12];
			rd					= instruction[11:7];
			// outputs DNE 
			rs1 				= 5'd0;
			rs2				= 5'd0;
			imm				= 12'd0;
		end
		end
	end

	
	// R type only logic 
	logic [9:0]funct_7_3;					// funct7 and funct3 concated
	assign funct_7_3 = {funct7, funct3};
	
	// always comb block for instruction decoding	
	always_comb begin
 		case(opcode)
 		op: begin
			mem_write = 1'b0; reg_write = 1'b1;
			case(funct_7_3): begin
			ADD:	alu_signal = ALU_ADD_I;
			SUB:	alu_signal = ALU_SUB_I;
			SLL:	alu_signal = ALU_SLL_I;
			SLT:	alu_signal = ALU_SLT_I;
			SLTU:	alu_signal = ALU_SLT_I_U;
			XOR:	alu_signal = ALU_XOR_I;
			SRL:	alu_signal = ALU_SRL_I;
			SRA:	alu_signal = ALU_SRA_I;
			OR:	alu_signal = ALU_OR_I;
			AND:	alu_signal = ALU_AND_I;
			end	
		end	
 		op-imm: begin
			mem_write = 1'b0; reg_write = 1'b1;
			case(funct3): begin
			ADDI:	alu_signal = ALU_ADD_I;
			SLTI:	alu_signal = ALU_SLT_I;
			SLTIU:alu_signal = ALU_SLT_I_U;
			XORI:	alu_signal = ALU_XOR_I;
			ORI:	alu_signal = ALU_OR_I;
			ANDI:	alu_signal = ALU_AND_I;
			SLLI:	alu_signal = ALU_SLL_I;
			SRLI:	alu_signal = ALU_SRL_I;
			SRAI:	alu_signal = ALU_SRA_I;
			end
 		end
		branch: begin
			mem_write = 1'b0; reg_write = 1'b0;
			case(funct3): begin
			BEQ:	alu_signal = ALU_BEQ;
			BNE:	alu_signal = ALU_BNE;
			BLT:	alu_signal = ALU_BLT;
			BGE:	alu_signal = ALU_BGE;
			BLTU:	alu_signal = ALU_BLT_U;
			BGEU:	alu_signal = ALU_BGE_U;
			end
		end
		load: begin
			mem_write = 1'b1; reg_write = 1'b1;
			case(funct3): begin
			LB:		xfer_size = XFER_BYTE;
			LH:		xfer_size = XFER_HALF;
			LW:		xfer_size = XFER_WORD;
			LBU:		xfer_size = XFER_BYTE;
			LHU:		xfer_size = XFER_HALF;
			end
		end
		store: begin
			mem_write = 1'b1; reg_write = 1'b0; alu_signal = ALU_ADD_I; 
			case(funct3): begin
			SB:		xfer_size = XFER_BYTE;
			SH:		xfer_size = XFER_HALF;
			SW:		xfer_size = XFER_WORD;
			SBU:		xfer_size = XFER_BYTE;
			SHU:		xfer_size = XFER_HALF;
			end
		end
		lui: begin 
			mem_write = 1'b0; reg_write = 1'b1; 
		end 
		auipc:
		jal: begin
			mem_write = 1'b0; reg_write = 1'b1;
		end
		jalr: begin
			mem_write = 1'b0; reg_write = 1'b1;
			alu_signal = ALU_ADD_I;	
		end
 		endcase
	
endmodule
