
`define WORD_SIZE	32

// TODO: fix inputs on the testbench
module control_signal(instruction, mem_read, mem_write, reg_write, data_mem_signed, 
						control_branch, jalr_branch, alu_signal, 
						rs1, rs2, rd, imm, imm_U_J, imm_en, xfer_size);
	
	`include "constants.svh"

	input logic [`WORD_SIZE - 1 : 0] instruction; 
	output logic mem_read, mem_write; 
	output logic [1:0]reg_write; 						// if need to write to memory or register
	output logic data_mem_signed;
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
			if (opcode == op_imm && (funct_3 == SLLI || funct_3 == SRLI || funct_3 == SRAI)) begin
				imm[4:0]  = instruction[24:20];
				// sign extending
				if (instruction[24]) imm[11:5] = 7'b1111111;
				else imm[11:5] = 7'b0;
			end else begin
				imm = instruction[31:20];
			end

			imm_en 			= ALU_READ_IMM;
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
			imm[11:5]		= instruction[31:25];
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
			imm_en 			= ALU_READ_RS2;
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
			imm_en 			= 2'bx;
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
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_ALU; 
			control_branch = 1'b0; jalr_branch = 1'b0;
			data_mem_signed = 1'b0; xfer_size = 2'bx;
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
 		op_imm: begin
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_ALU; 
			control_branch = 1'b0; jalr_branch = 1'b0;
			data_mem_signed = 1'b0; xfer_size = 2'bx;
			case(funct_3) 
			ADDI:	alu_signal = ALU_ADD_I;
			SLTI:	alu_signal = ALU_SLT_I;
			SLTIU:	alu_signal = ALU_SLT_I_U;
			XORI:	alu_signal = ALU_XOR_I;
			ORI:	alu_signal = ALU_OR_I;
			ANDI:	alu_signal = ALU_AND_I;
			SLLI:	alu_signal = ALU_SLL_I;
			SRLI: begin
				if (instruction[30]) alu_signal = ALU_SRA_I;
				else alu_signal = ALU_SRL_I;
			end
			default:alu_signal = 5'bx;
			endcase
 		end
		branch: begin 
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_OFF; 
			control_branch = 1'b1; jalr_branch = 1'b0;
			data_mem_signed = 1'b0; xfer_size = 2'bx;
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
			mem_read = 1'b1; mem_write = 1'b0; reg_write = REG_WR_MEM; 
			alu_signal = ALU_ADD_I; control_branch = 1'b0; jalr_branch = 1'b0;
			case(funct_3) 
			LB: begin
				xfer_size = XFER_BYTE;
				data_mem_signed = 1'b1;
			end
			LH: begin
				xfer_size = XFER_HALF;
				data_mem_signed = 1'b1;
			end
			LW: begin
				xfer_size = XFER_WORD;
				data_mem_signed = 1'b1;
			end
			LBU: begin
				xfer_size = XFER_BYTE;
				data_mem_signed = 1'b0;
			end
			LHU: begin
				xfer_size = XFER_HALF;
				data_mem_signed = 1'b0;
			end
			default: begin
				xfer_size = 2'bx;
				data_mem_signed = 1'bx;
			end
			endcase
		end
		store: begin
			mem_read = 1'b0; mem_write = 1'b1; reg_write = REG_WR_OFF; 
			alu_signal = ALU_ADD_I; control_branch = 1'b0; jalr_branch = 1'b0;
			data_mem_signed = 1'b0;
			case(funct_3) 
			SB:		xfer_size = XFER_BYTE;
			SH:		xfer_size = XFER_HALF;
			SW:		xfer_size = XFER_WORD;
			//SBU:	xfer_size = XFER_BYTE;
			//SHU:	xfer_size = XFER_HALF;
			default:xfer_size = 2'bx;
			endcase
		end
		lui: begin 
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_ALU; 
			alu_signal = ALU_LUI; jalr_branch = 1'b0; xfer_size = 2'bx;
			data_mem_signed = 1'b0;
		end 
		auipc: begin
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_ALU;
			alu_signal = ALU_AUIPC; jalr_branch = 1'b0; xfer_size = 2'bx;
			data_mem_signed = 1'b0;
		end
		jal: begin
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_ALU;
			alu_signal = ALU_JAL_R; jalr_branch = 1'b0; xfer_size = 2'bx;
			data_mem_signed = 1'b0;
		end
		jalr: begin
			mem_read = 1'b0; mem_write = 1'b0; reg_write = REG_WR_ALU;
			jalr_branch = 1'b1; alu_signal = ALU_ADD_I; xfer_size = 2'bx;	
			data_mem_signed = 1'b0;
		end
		default: begin
			mem_read = 1'bx; mem_write = 1'bx; reg_write = 2'bx;
			jalr_branch = 1'bx; alu_signal = 5'bx; xfer_size = 2'bx;	
			data_mem_signed = 1'bx;
		end
 		endcase
	end	

endmodule





//module control_signal_tb();
//	`include "constants.svh"
//
//	logic clk;
//	logic [`WORD_SIZE - 1 : 0] instruction; 
//	logic mem_write; 							// if need to write to memory or register
//	logic [1:0]reg_write;
//	logic control_branch, jalr_branch;			// true if the instruction contains branch
//	logic [4:0]alu_signal;						// control signal for alu
//	logic [4:0]rs1, rs2, rd;	
//	logic [1:0]imm_en; 							// 00 = rs2, 01 = imm, 10 = imm_U_J
//	logic [11:0]imm; 							// immediate value for I, S, B type
//	logic [19:0]imm_U_J;						// immediate value for U-type and J-type
//	logic [1:0]xfer_size;
//	
//
//
//	// dut
//	control_signal control(.instruction, .mem_write, .reg_write, 
//						.control_branch, .jalr_branch, .alu_signal, 
//						.rs1, .rs2, .rd, .imm, .imm_U_J, .imm_en, .xfer_size);
//
//	// set up the clock
//	parameter CLOCK_PERIOD = 100;
//	initial begin
//		clk <= 0;
//		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
//	end
//
//	initial begin
//		$dumpfile("control_signal.vcd");
//		$dumpvars(0, clk, instruction, mem_write, reg_write, control_branch,
//					jalr_branch, alu_signal, rs1, rs2, rd, imm, imm_U_J, imm_en, xfer_size);
//	end
//
//	// tests
//	initial begin
//		// add a3, a3, t0
//		instruction <= 32'h005686b3;		@(posedge clk);
//		// sub a5, a5, s0
//		instruction <= 32'h408787b3;		@(posedge clk);
//		// sll a4, s5, s0
//		instruction <= 32'h008a9733;		@(posedge clk);
//		// slt a1, s4, a2
//		instruction <= 32'h00ca25b3;		@(posedge clk);
//		// sltu a1, s4, a2
//		instruction <= 32'h00ca35b3;		@(posedge clk);
//		// xor a5, a4, a5
//		instruction <= 32'h00f747b3;		@(posedge clk);
//		// srl a0, a1, a2
//		instruction <= 32'h00c5d533;		@(posedge clk);
//		// sra a0, a1, a2
//		instruction <= 32'h40c5d533;		@(posedge clk);
//		// or a7, a7, a2
//		instruction <= 32'h00c8e8b3;		@(posedge clk);
//		// and a4, a4, a5
//		instruction <= 32'h00f77733;		@(posedge clk);
//		// addi sp, sp, -32
//		instruction <= 32'hfe010113;		@(posedge clk);
//		// slti tp, t0, -96
//		instruction <= 32'hfa02a213;		@(posedge clk);
//		// sltiu t0, t1, 1365
//		instruction <= 32'h55533293;		@(posedge clk);
//		// xori s0, s1, 254
//		instruction <= 32'h0fe4c413;		@(posedge clk);
//		// ori x10, x11, 0x444
//		instruction <= 32'h4445e513;		@(posedge clk);
//		// andi a0, a1, 255
//		instruction <= 32'h0ff5f513;		@(posedge clk);
//		// slli a6, a4, 0x2
//		instruction <= 32'h00271813;		@(posedge clk);
//		// srli a3, a4 0x2
//		instruction <= 32'h00275693;		@(posedge clk);
//		// srai s2, s2, 0x2
//		instruction <= 32'h40295913;		@(posedge clk);
//		// beq a0, a2, 10518
//		instruction <= 32'h02d50463;		@(posedge clk);
//		// bne 
//		instruction <= 32'h01871463;		@(posedge clk);
//		// blt a6, a4, 1053c
//		instruction <= 32'h06e84e63;		@(posedge clk);
//		// bge t1, a2, 10284
//		instruction <= 32'h02c37e63;		@(posedge clk);
//		// bltu a4, a3, 10264
//		instruction <= 32'hfed766e3;		@(posedge clk);
//		// bgeu zero, a6, 14
//		instruction <= 32'h01007663;		@(posedge clk);
//		// lui a5, 0x11
//		instruction <= 32'h000117b7;		@(posedge clk);
//		// auipc t0, 0x0
//		instruction <= 32'h00000297;		@(posedge clk);
//		// jal ra, 10240
//		instruction <= 32'h19c000ef;		@(posedge clk);
//		// jalr zero #0
//		instruction <= 32'h000000e7;		@(posedge clk);
//		// lb a0, 4(a1)
//		instruction <= 32'h00458503;		@(posedge clk);
//		// lh a0, 4(a1)
//		instruction <= 32'h00459503;		@(posedge clk);
//		// lw a0, 0(sp)
//		instruction <= 32'h00012503;		@(posedge clk);
//		// lbu a4, -972(gp)
//		instruction <= 32'hc341c703;		@(posedge clk);
//		// lhu a0, 4(a1)
//		instruction <= 32'h0045d503;		@(posedge clk);
//		// sb a1, 1(a4)
//		instruction <= 32'h00b700a3;		@(posedge clk);
//		// sh a0, 0(a1)
//		instruction <= 32'h00a59023;		@(posedge clk);
//		// sw s0, 0(a0)
//		instruction <= 32'h00852023;		@(posedge clk);
//		// sbu
//		// shu
//		$finish;
//	end
//
//endmodule

