
`define WORD_SIZE	32


module control_signal(instruction, mem_write, reg_write, 
						control_branch, jalr_branch, alu_signal, 
						rs1, rs2, rd, imm, imm_U_J, imm_en, xfer_size);
	
	`include "constants.svh"

	input logic [`WORD_SIZE - 1 : 0] instruction; 
	output logic mem_write, reg_write; 					// if need to write to memory or register
	output logic control_branch, jalr_branch;			// true if the instruction contains branch
	output logic [4:0]alu_signal;						// control signal for alu
	output logic [4:0]rs1, rs2, rd;	
	output logic [1:0] imm_en; 							// 00 = rs2, 01 = imm, 10 = imm_U_J
	output logic [11:0]imm; 							// immediate value for I, S, B type
	output logic [19:0] imm_U_J;						// immediate value for U-type and J-type
	output logic [1:0] xfer_size;

	
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
		case(instruction_type) 

		INSTRUCTION_TYPE_R: begin
			imm_en 			= ALU_READ_RS2;
			funct_7			= instruction[31:25];
			rs2 			= instruction[24:20];
			rs1 			= instruction[19:15];
			funct_3			= instruction[14:12];
			rd 				= instruction[11:7];
			// outputs DNE 
			imm 			= 12'bx;
			imm_U_J 		= 20'bx;
		end

		INSTRUCTION_TYPE_I: begin
			imm_en 			= ALU_READ_IMM;
			imm 			= instruction[31:20];
			rs1 			= instruction[19:15];
			funct_3 			= instruction[14:12];
			rd 				= instruction[11:7];
			//outputs DNE 
			funct_7			= 7'bx;
			rs2 			= 5'bx;
			imm_U_J 		= 20'bx;
		end
		
		INSTRUCTION_TYPE_S: begin
			// STORE:  mem[rs2[value] + imm] <- stored [rs1[value]] 
			imm_en 			= ALU_READ_IMM; 
			imm[11:5]		= instruction[31:15];
			imm[4:0]		= instruction[11:7];  
			rs2				= instruction[24:20]; 
			rs1				= instruction[19:15];  
			funct_3			= instruction[14:12]; 
			// outputs DNE 
			funct_7			= 7'bx;
			rd 				= 5'bx;
			imm_U_J			= 20'bx;
		end
		
		INSTRUCTION_TYPE_U: begin
			imm_en 			= ALU_READ_IMM_U;
			imm_U_J			= instruction[31:12];
			rd				= instruction[11:7];
			// outputs DNE 
			funct_3			= 3'bx;
			funct_7			= 7'bx;
			rs1 			= 5'bx;
			rs2 			= 5'bx; 
			imm				= 12'bx;
		end
		
		INSTRUCTION_TYPE_B: begin
			imm_en 			= ALU_READ_IMM;
			imm[11] 		= instruction[31];
			imm[10]			= instruction[7];
			imm[9:4]		= instruction[30:25];
			imm[3:0]		= instruction[11:8];
			rs2				= instruction[24:20];
			rs1				= instruction[19:15];
			funct_3			= instruction[14:12];
			// outputs DNE 
			funct_7			= 7'bx;
			rd 				= 5'bx;
			imm_U_J			= 20'bx;
			
		end
		INSTRUCTION_TYPE_J: begin
			imm_en			= ALU_READ_IMM_J;
			imm_U_J[19]		= instruction[31];
			imm_U_J[9:0]	= instruction[30:21];
			imm_U_J[10]		= instruction[20];
			imm_U_J[18:11]	= instruction[19:12];
			rd				= instruction[11:7];
			// outputs DNE 
			funct_3			= 3'bx;
			funct_7			= 7'bx;
			rs1 			= 5'bx;
			rs2				= 5'bx;
			imm				= 12'bx;
		end
		default: begin
			funct_3			= 3'bx;
			funct_7			= 7'bx;
			imm_en 			= 5'bx;
			imm_U_J			= 20'bx;
			imm				= 12'bx;
			rd				= 5'bx;
			rs1				= 5'bx;
			rs2				= 5'bx;
		end
		endcase
	end

	
	// R type only logic 
	logic [9:0]funct_7_3;					// funct_7 and funct_3 concated
	assign funct_7_3 = {funct_7, funct_3};
	
	// always comb block for instruction decoding	
	always_comb begin
 		case(opcode)
 		op: begin
			mem_write = 1'b0; reg_write = 1'b1; 
			control_branch = 1'b0; jalr_branch = 1'b0;
			xfer_size = 2'bx;
			case(funct_7_3) 
			ADD:	alu_signal = ALU_ADD_I;
			SUB:	alu_signal = ALU_SUB_I;
			SLL:	alu_signal = ALU_SLL_I;
			SLT:	alu_signal = ALU_SLT_I;
			SLTU:	alu_signal = ALU_SLT_I_U;
			XOR:	alu_signal = ALU_XOR_I;
			SRL:	alu_signal = ALU_SRL_I;
			SRA:	alu_signal = ALU_SRA_I;
			OR:		alu_signal = ALU_OR_I;
			AND:	alu_signal = ALU_AND_I;
			default:alu_signal = 5'bx;
			endcase	
		end	
 		op-imm: begin
			mem_write = 1'b0; reg_write = 1'b1; 
			control_branch = 1'b0; jalr_branch = 1'b0;
			xfer_size = 2'bx;
			case(funct_3) 
			ADDI:	alu_signal = ALU_ADD_I;
			SLTI:	alu_signal = ALU_SLT_I;
			SLTIU:	alu_signal = ALU_SLT_I_U;
			XORI:	alu_signal = ALU_XOR_I;
			ORI:	alu_signal = ALU_OR_I;
			ANDI:	alu_signal = ALU_AND_I;
			SLLI:	alu_signal = ALU_SLL_I;
			SRLI:	alu_signal = ALU_SRL_I;
			SRAI:	alu_signal = ALU_SRA_I;
			default:alu_signal = 5'bx;
			endcase
 		end
		branch: begin 
			mem_write = 1'b0; reg_write = 1'b0; 
			control_branch = 1'b1; jalr_branch = 1'b0;
			xfer_size = 2'bx;
			case(funct_3) 
			BEQ:	alu_signal = ALU_BEQ;
			BNE:	alu_signal = ALU_BNE;
			BLT:	alu_signal = ALU_BLT;
			BGE:	alu_signal = ALU_BGE;
			BLTU:	alu_signal = ALU_BLT_U;
			BGEU:	alu_signal = ALU_BGE_U;
			default:alu_signal = 5'bx;
			endcase
		end
		load: begin
			mem_write = 1'b1; reg_write = 1'b1; 
			alu_signal = ALU_ADD_I; control_branch = 1'b0; jalr_branch = 1'b0;
			case(funct_3) 
			LB:		xfer_size = XFER_BYTE;
			LH:		xfer_size = XFER_HALF;
			LW:		xfer_size = XFER_WORD;
			LBU:	xfer_size = XFER_BYTE;
			LHU:	xfer_size = XFER_HALF;
			default:xfer_size = 2'bx;
			endcase
		end
		store: begin
			mem_write = 1'b1; reg_write = 1'b0; 
			alu_signal = ALU_ADD_I; control_branch = 1'b0; jalr_branch = 1'b0;
			case(funct_3) 
			SB:		xfer_size = XFER_BYTE;
			SH:		xfer_size = XFER_HALF;
			SW:		xfer_size = XFER_WORD;
			SBU:	xfer_size = XFER_BYTE;
			SHU:	xfer_size = XFER_HALF;
			default:xfer_size = 2'bx;
			endcase
		end
		lui: begin 
			mem_write = 1'b0; reg_write = 1'b1; 
			alu_signal = ALU_LUI; jalr_branch = 1'b0; xfer_size = 2'bx;
		end 
		auipc: begin
			mem_write = 1'b0; reg_write = 1'b1;
			alu_signal = ALU_AUIPC; jalr_branch = 1'b0; xfer_size = 2'bx;
		end
		jal: begin
			mem_write = 1'b0; reg_write = 1'b1;
			alu_signal = ALU_JAL_R; jalr_branch = 1'b0; xfer_size = 2'bx;
		end
		jalr: begin
			mem_write = 1'b0; reg_write = 1'b1;
			jalr_branch = 1'b1; alu_signal = ALU_ADD_I; xfer_size = 2'bx;	
		end
		default: begin
			mem_write = 1'bx; reg_write = 1'bx;
			jalr_branch = 1'bx; alu_signal = 5'bx; xfer_size = 2'bx;	
		end
 		endcase
	end	

endmodule





module control_signal_tb();
	`include "constants.svh"

	logic clk;
	logic [`WORD_SIZE - 1 : 0] instruction; 
	logic mem_write, reg_write; 				// if need to write to memory or register
	logic control_branch, jalr_branch;			// true if the instruction contains branch
	logic [4:0]alu_signal;						// control signal for alu
	logic [4:0]rs1, rs2, rd;	
	logic [1:0]imm_en; 							// 00 = rs2, 01 = imm, 10 = imm_U_J
	logic [11:0]imm; 							// immediate value for I, S, B type
	logic [19:0]imm_U_J;						// immediate value for U-type and J-type
	logic [1:0]xfer_size;
	


	// dut
	control_signal control(.instruction, .mem_write, .reg_write, 
						.control_branch, .jalr_branch, .alu_signal, 
						.rs1, .rs2, .rd, .imm, .imm_U_J, .imm_en, .xfer_size);

	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		$dumpfile("control_signal.vcd");
		$dumpvars(0, clk, instruction, mem_write, reg_write, control_branch,
					jalr_branch, alu_signal, rs1, rs2, rd, imm, imm_U_J, imm_en, xfer_size);
	end

	// tests
	initial begin
		// addi sp, sp, -32
		instruction <= 32'hfe010113;		@(posedge clk);
											@(posedge clk);
		$finish;
	end

endmodule

