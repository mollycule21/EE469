// top level module for 32-bit rv32i processor
`define WORD_SIZE 	32


module top(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR,
					 CLOCK_50);
					 // clk); 
					 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	//input logic clk; 
	

	input logic CLOCK_50;
	// logic clk; 
	// assign clk = CLOCK_50; 
	assign reset = ~KEY[3];
	
	// Generate clk off of CLOCK_50, whichClock picks rate
	logic [31:0] clk;
	parameter whichClock = 25;
	logic clk_s; 
	assign clk_s = clk[whichClock];
	
	clock_divider cdiv(CLOCK_50, clk);
	
	// clock_divider slower_clk (.clock(CLOCK_50), .reset, .divided_clocks(clk));
	
	`include "constants.svh"

	//logic clk, reset;

	logic [`WORD_SIZE - 1:0]instruction;
	logic	mem_read,
			mem_write,
			take_branch,
			control_branch,
			jalr_branch,
			data_mem_signed;
	logic [1:0]reg_write;
	logic [4:0]alu_signal;
	logic [`WORD_SIZE - 1:0]alu_output, 
							data_mem_output,
							reg_out_1,
							reg_out_2;
	logic [4:0]rs1, rs2, rd;
	logic [1:0]xfer_size;

	// immediate values
	logic [19:0]imm_20_bit;
	logic [11:0]imm_12_bit;
	logic [1:0]imm_en;
	
	parameter nill = ~(7'b0000000);
	
	assign HEX5 = nill; 
	assign HEX4 = nill;
	assign HEX3 = nill;
	assign HEX2 = nill; 
	
	// pc address
	logic [`WORD_SIZE - 1:0]address;

	// top level module for pc
	// input:	clk, reset, imm, imm_U_J, imm_en, alu_branch, control_branch
	// output:	address_out
	pc_top_level pc_top(.clk(clk_s), .reset(reset), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
						.imm_en(imm_en), .register_for_jalr(reg_out_1), .alu_branch(take_branch), 
						.control_branch(control_branch), .jalr_branch(jalr_branch), 
						.address_out(address));


	// instruction memory
	// input:	clk, reset, address
	// output:	instruction
	instruction_memory inst_mem(.clk(clk_s), .reset(reset), 
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
	alu my_alu(.clk(clk_s), .reset(reset), .pc(address), .control(alu_signal),
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
							
	logic [7:0] HEX_out; 
	logic io_flag; 
	// data memory
	// input:	clk, reset, address, read_en, write_en, is_signed, xfer_size, write_data
	// output:	read_data
	data_memory d_mem(.clk(clk_s), .reset(reset), .read_en(mem_read), 
						.is_signed(data_mem_signed), .address(alu_output), 
						.xfer_size(xfer_size), .write_en(mem_write), 
						.write_data(reg_out_2), .read_data(data_mem_output),
						.HEX_out(HEX_out), .io_flag(io_flag));
						
	logic [6:0]  out1, out0; 		
	// each HEX digit = 4 bits of data at a time 					
	display h1 (.in(HEX_out[7:4]), .out(out1)); 
	display h0 (.in(HEX_out[3:0]), .out(out0)); 
	
	//fsm f1 (.clk(CLOCK_50), .reset, .io_flag(io_flag), .in(out1), .hex_out_1(HEX1), .hex_out_2(HEX3));
	//fsm f0 (.clk(CLOCK_50), .reset, .io_flag(io_flag), .in(out0), .hex_out_1(HEX0), .hex_out_2(HEX2));
	
	fsm f1 (.clk(clk_s), .reset, .io_flag(io_flag), .in(out1), .out(HEX1));
	fsm f0 (.clk(clk_s), .reset, .io_flag(io_flag), .in(out0), .out(HEX0));
	
endmodule 

//module top_tb(); 
//					 
//	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
//	logic [9:0] LEDR;
//	logic [3:0] KEY;
//	logic clk; 
//
//	// logic CLOCK_50;
//	// pc address
//	logic [`WORD_SIZE - 1:0]address;
//	
//	top dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,
//					 // CLOCK_50);
//					 .clk); 		
//	
//	// set up the clock
//	parameter CLOCK_PERIOD = 100;
//	initial begin
//		clk <= 1;
//		forever #(CLOCK_PERIOD/ 2) clk <= ~clk;
//	end
//
//
//	// tests
//	initial begin
//		KEY[3] <= 1'b0;		@(posedge clk);
//		KEY[3] <= 1'b1;		@(posedge clk);
//								repeat (60000) @(posedge clk);
//								repeat (60000)@(posedge clk);
//								repeat (60000)@(posedge clk);
//								@(posedge clk);
//								@(posedge clk);
//								@(posedge clk);
//								@(posedge clk);
//								@(posedge clk);
//								@(posedge clk);
//								@(posedge clk);
//
//		$stop;
//	end
//endmodule

