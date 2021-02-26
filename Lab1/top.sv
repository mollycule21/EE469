// top level module for 32-bit rv32i processor
`define WORD_SIZE 	32

module top(clk, reset, alu_output);
	
	input logic clk, reset;
	output logic [`WORD_SIZE - 1:0]alu_output;
	
	
	`include "constants.svh"
	logic [`WORD_SIZE - 1:0]instruction;
	logic	mem_read,
			mem_write,
			pc_en,
			take_branch,
			control_branch,
			jalr_branch,
			data_mem_signed;
	logic [1:0]reg_write;
	logic [4:0]alu_signal;
	logic [`WORD_SIZE - 1:0]
							//alu_output, 
							data_mem_output,
							reg_out_1,
							reg_out_2;
	logic [4:0]rs1, rs2, rd;
	logic [1:0]xfer_size;

	// immediate values
	logic [19:0]imm_20_bit;
	logic [11:0]imm_12_bit;
	logic [1:0]imm_en;

	// pc address
	logic [`WORD_SIZE - 1:0]address;

	// top level module for pc
	// input:	clk, reset, imm, imm_U_J, imm_en, alu_branch, control_branch
	// output:	address_out
	pc_top_level pc_top(.clk(clk), .reset(reset), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
						.imm_en(imm_en), .register_for_jalr(reg_out_1), .alu_branch(take_branch), 
						.control_branch(control_branch),.jalr_branch(jalr_branch), .address_out(address));


	// instruction memory
	// input:	clk, reset, address
	// output:	instruction
	instruction_memory inst_mem(.clk(clk), .reset(reset), 
								.address(address), .instruction(instruction));

	// register file
	// input:	clk, reset, read_reg_1, read_reg_2, wr_reg, wr_data, wr_en
	// output:	read_out_1, read_out_2
	register_file reg_file(.clk(clk), .reset(reset),
							.read_reg_1(rs1), .read_reg_2(rs2), .wr_reg(rd),
							.alu_wr_data(alu_output), .mem_wr_data(data_mem_output), 
							.wr_en(reg_write), .read_out_1(reg_out_1), .read_out_2(reg_out_2));

	// alu
	// input:	clk, reset, control, in_1, in_2
	// output:	out, take_branch
	alu my_alu(.clk(clk), .reset(reset), .pc(address), .control(alu_signal),
			.in_1(reg_out_1), .in_2(reg_out_2), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
			.imm_en(imm_en), .out(alu_output), .take_branch(take_branch));

	// control signal
	// input:	instruction, mem_write, reg_write, 
	// output:	alu_signal	
	control_signal control(.instruction(instruction), .mem_read(mem_read), .mem_write(mem_write), 
							.reg_write(reg_write), .data_mem_signed(data_mem_signed), 
							.control_branch(control_branch), .jalr_branch(jalr_branch), 
							.alu_signal(alu_signal), .rs1(rs1), .rs2(rs2), .rd(rd),
							.imm(imm_12_bit), .imm_U_J(imm_20_bit), .imm_en(imm_en), 
							.xfer_size(xfer_size));

	// data memory
	// input:	clk, reset, address, read_en, write_en, is_signed, xfer_size, write_data
	// output:	read_data
	data_memory d_mem(.clk(clk), .reset(reset), .read_en(mem_read), 
						.is_signed(data_mem_signed), .address(alu_output), 
						.xfer_size(xfer_size), .write_en(mem_write), 
						.write_data(reg_out_2), .read_data(data_mem_output));
endmodule 

module top_tb(); 
	logic clk, reset; 
	logic [`WORD_SIZE - 1:0] alu_output;
	logic [`WORD_SIZE - 1:0]instruction;
	logic	mem_read,
			mem_write,
			pc_en,
			take_branch,
			control_branch,
			jalr_branch,
			data_mem_signed;
	logic [1:0]reg_write;
	logic [4:0]alu_signal;
	logic [`WORD_SIZE - 1:0]
							data_mem_output,
							reg_out_1,
							reg_out_2;
	logic [4:0]rs1, rs2, rd;
	logic [1:0]xfer_size;

	// immediate values
	logic [19:0]imm_20_bit;
	logic [11:0]imm_12_bit;
	logic [1:0]imm_en;
	
	logic [`WORD_SIZE - 1:0]address;
	
	top dut (.clk, .reset, .alu_output); 
	

	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD /  2) clk <= ~clk;
	end

	// set up output
	initial begin
		//$dumpfile("top.vcd");
		$dumpvars(0, clk, reset, instruction, mem_read,
					mem_write, pc_en, take_branch, control_branch,
					jalr_branch, data_mem_signed, reg_write, alu_signal,
					alu_output, data_mem_output, reg_out_1, reg_out_2, 
					rs1, rs2, rd, xfer_size, imm_12_bit, imm_20_bit, imm_en, address);
	end

	// tests
	initial begin
		reset <= 1;		@(posedge clk);
							// 0 
		reset <= 0;		repeat (5) @(posedge clk);		// add a3, a3, t0 | instruction <= 32'h005686b3 
																	// (register [13] = 1) + (register[5] = 3) ->					 	alu_output = 4 
							// 1									
							repeat (5) @(posedge clk);		// sub a5, a5, s0 |instruction <= 32'h408787b3;	
																	// register [15] = 2 - register[8] = 1 -> 							alu_output = 1
							// 2  // a4 = 4
							repeat (5) @(posedge clk);		// sll a4, s5, s0 | instruction <= 32'h008a9733;	
																	// register [21] = 2 - register[8] = 1 -> 							alu_output = 4
							// 3  										
							repeat (5) @(posedge clk);		// slt a1, s4, a2 | instruction <= 32'h00ca25b3;	
																	// register [20] = -6 < register[12] = 5 -> 							alu_output = 1 
							// 4	// al = 0 								
							repeat (5) @(posedge clk);		// sltu a1, s4, a2 | instruction <= 32'h00ca35b3;	
																	// register [20] = big #  < register[12] = 5 ->						alu_output = 0 
							// 5	// a5 = 5 							
							repeat (5) @(posedge clk);		// xor a5, a4, a5 |instruction <= 32'h00f747b3;	
																	// register [14] = 4 ^ register[13] = 1 -> 							alu_output = 5
							// 6 // a0 = 0 
							repeat (5) @(posedge clk);		// srl a0, a1, a2 | instruction <= 32'h00c5d533;	
																	// register [11] = 0 >> register[12] = 5 -> 							alu_output = 0
							// 7										
							repeat (5) @(posedge clk);		// sra a0, a1, a2 | instruction <= 32'h40c5d533;	
																	// register [11] = 0 register[12] = 5 >>> 							alu_output = 0
							// 8	// a7 = 7									
							repeat (5) @(posedge clk);		// or a7, a7, a2 | instruction <= 32'h00c8e8b3;	
																	// register [17] = 2  < register[12] = 5 -> 							alu_output = 7 
							// 9	// a4 = 4				
							repeat (5) @(posedge clk);		// and a4, a4, a5| instruction <= 32'h00f77733	
																	// register [14] = 4  & register[15] = 5 -> 							alu_output = 4 
							// 10								
							repeat (5) @(posedge clk);		// addi sp, sp, -32 |instruction <= 32'hfe010113	
																	// register [2] = 128 -32 ->												alu_output = 96
							// 11
							repeat (5) @(posedge clk);		// slti tp, t0, -96 | instruction <= 32'hfa02a213;	
																	// register [5] = 0 < -96? -> 											alu_output = 0
							// 12										
							repeat (5) @(posedge clk);		// sltiu t0, t1, 1365| instruction <= 32'h55533293	
																	// register [6] = 0 < 1365 -> 											alu_output = 1
							// 13										
							repeat (5) @(posedge clk);		// xori s0, s1, 254 | instruction <= 32'h0fe4c413	
																	// register [9] = 1	^254 -> 											alu_output = 255
							
							// 14 NEW TEST START 
							repeat (5) @(posedge clk);		// ori x10, x11, 0x444 | instruction <= 32'h4445e513;
																	// register[11] = 0 | 1092 												alu_output = 1092
							// 15									
							repeat (5) @(posedge clk);		// andi a0, a1, 255 | instruction <= 32'h0ff5f513;
																	// register[11] = 0 & 255  												alu_output = 0 
							//16 										
							repeat (5) @(posedge clk);		// slli a6, a4, 0x2 | instruction <= 32'h00271813;
																	// register [14] = 4 << 2													alu_output = 16 
																	

							//17		
							repeat (5) @(posedge clk);		// srli a3, a4 0x2 | instruction <= 32'h00275693;
																	// register[14] = 4 >> 2 													alu_output = 1
							
							
							//18 // BUG (reuse previous for now) 
							repeat (5) @(posedge clk); 	// srai s2, s2, 0x2 | instruction <= 32'h40295913;
																	// register[18] = -60 >>> 2 												alu_output = -15
						
							//19 // BUG 
							repeat (5) @(posedge clk);		// beq a0, a2, 4 | instruction <= 32'h00d50263;
																	// register[10] = 8 , register[12] = 10518 							alu_output = 0

							//20
							repeat (5) @(posedge clk);		// bne a4, s8, 10450	;	instruction <= 32'h01871463;
																	// register[10] register[24] = 10450 = 10450 						alu_output = 1;
							
							// organize, but values are not adjusted 
							
							//21
							repeat (5) @(posedge clk);		// blt a6, a4, 1053c; instruction <= 32'h06e84e63;
																	// register[16] < register[14] 
							//22
							repeat (5) @(posedge clk);		// bge t1, a2, 10284
//		
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


		$stop;
	end
endmodule










