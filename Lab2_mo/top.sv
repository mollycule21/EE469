// top level module for 32-bit rv32i processor
`define WORD_SIZE 	32


module top(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR,
					 CLOCK_50);
					  //clk); 
					 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic CLOCK_50; 
	// input logic clk; 
	
	// assign clk = CLOCK_50; 
	assign reset = ~KEY[3];
	
	// Generate clk off of CLOCK_50, whichClock picks rate
	logic [31:0] divided_clocks;
	parameter whichClock = 12;
	logic clk; 
	// assign clk = divided_clocks[whichClock];
	assign clk = CLOCK_50;
		
	clock_divider cdiv(.clock(CLOCK_50), .divided_clocks(divided_clocks));

	`include "constants.svh"

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
	
	// pc address
	logic [`WORD_SIZE - 1:0]address;
	
	// making sure that logics are written before read 
//	logic write_half, read_half;
//	logic counter;
//	always_comb begin 
//		if (reset) begin 
//			write_half = 1'b0; 
//			read_half = 1'b0;
//			counter = 1'b0; 
//		end else if (count == 0) begin 
//			write_half = 1'b1; 
//			read_half = 1'b0;
//			counter = 1'b1; 
//		end else if (count == 1) begin 
//			write_half = 1'b0; 
//			read_half = 1'b1;
//			counter = 1'b0; 			
//		end else begin 
//			write_half = 1'b0; 
//			read_half = 1'b0; 
//			counter = 1'b0;
//		end 
//	end
//	
//	
//	// stage 2 
//	always_comb begin 
//		if(reset) begin 
//		end else if (write_half) begin 
//			mem_write = mem_write_f;
//			reg_write = reg_write_f;
//			control_branch = control_branch_f; 
//			alu_output = alu_output_f;
//			data_mem_output = data_mem_output_f; 
//		end else if (read_half) begin 
//			mem_read = mem_read_f;
//			read_out_1 = read_out_1_f; 
//			read_out_2 = read_out_2_f;
//			
//		end 
//	end 
	
	// top level module for pc
	// input:	clk, reset, imm, imm_U_J, imm_en, alu_branch, control_branch
	// output:	address_out
	pc_top_level pc_top(.clk(clk), .reset(reset), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
						.imm_en(imm_en), .register_for_jalr(reg_out_1), .alu_branch(take_branch_final), 
						.control_branch(control_branch), .jalr_branch(jalr_branch), 
						.address_out(address));


	// instruction memory
	// input:	clk, reset, address
	// output:	instruction
	instruction_memory inst_mem(.clk(clk), .reset(reset), 
								.address(address), .instruction(instruction));	
	
	
	// 5 stage pipeline - stage 1
	logic [31:0] if_id_pc, if_id_instruction;
	
	if_id stage1 (.if_id_pc(if_id_pc), .if_id_instruction(if_id_instruction), 
							.clk(clk), .reset(reset), .address(address), .instruction(intruction));
							
	// control signal
	// input:	instruction, mem_write, reg_write, 
	// output:	alu_signal	
	control_signal control(.instruction(instruction), .mem_read(mem_read), .mem_write(mem_write), 
							.reg_write(reg_write), .data_mem_signed(data_mem_signed), 
							.control_branch(control_branch_f), .jalr_branch(jalr_branch), 
							.alu_signal(alu_signal), .rs1(rs1), .rs2(rs2), .rd(rd),
							.imm(imm_12_bit), .imm_U_J(imm_20_bit), .imm_en(imm_en), 
							.xfer_size(xfer_size));

	
	// register file
	// input:	clk, reset, read_reg_1, read_reg_2, wr_reg, wr_data, wr_en
	// output:	read_out_1, read_out_2
	register_file reg_file(.clk(clk), .reset(reset),
							.read_reg_1(rs1), .read_reg_2(rs2), .wr_reg(rd),
							.alu_wr_data(alu_output), .mem_wr_data(data_mem_output), 
							.wr_en(reg_write), .read_out_1(reg_out_1), .read_out_2(reg_out_2));
	
	// forwarding 
	// outputs: forwardA, forwardB 
	// inputs: rs1, rs2, EX_Reg_Write, Mem_Reg_Write, WB_Reg_Write (from control signal????)
	// ***** WB_Reg_Write not implmented in control_signal
	// inputs: EX_Rd (from id_ex), MEM_Rd(from ex_mem), Wb_Rd(from ???) 
	logic [1:0] forwardA, forwardB;
	logic [4:0] EX_Rd, Mem_Rd, Wb_Rd; 
	forwarding checkforwarding(.forwardA(forwardA), .forwardB(forwardB),
											.EX_Reg_Write(reg_write), .MEM_Reg_Write(mem_write), .WB_Reg_Write(????), 
											.EX_Rd(.EX_Rd), .MEM_Rd(.MEM_Rd), .WB_Rd(.WB_Rd), .rs1(rs1), .rs2(rs2));
							
	// 5 stage pipeline - stage 2
	// Overwrite read_out_1 and read_out_2 before it enters alu if there is a forwarding hazard 
	logic [31:0] read_out_1_final, read_out_2_final;
	logic [31:0] id_ex_pc, id_ex_instruction;
	logic [31:0] EX_out_1, EX_out_2;
	id_ex stage2 (.read_out_1_final(read_out_1_final), .read_out_2_final(read_out_2_final), .Ex_Rd(EX_Rd),
							.id_ex_pc(id_ex_pc),.id_ex_instruction(id_ex_instruction), EX_out_1(EX_out_1), EX_out_2(EX_out_2)
							.forwardA(forwardA), .forwardB(forwardB), .read_out_1(reg_out_1), .read_out_2(reg_out_2), 
							.alu_out(.alu_output_final), .mem_read_out(data_mem_output_final), .wb_data_out(wb_data_out), .if_id_pc(if_id_pc), 
							.if_id_instruction(if_id_instruction), .rd(rd)), .clk(clk);				
	// alu
	// output:	out, take_branch
	// input: clk, reset, control
	// input: in_1, in_2 (from id_ex as read_out_1_final and read_out_2_final) 
	
	alu my_alu(.clk(clk), .reset(reset), .pc(address), .control(alu_signal),
			.in_1(read_out_1_final), .in_2(read_out_2_final), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
			.imm_en(imm_en), .out(alu_output), .take_branch(take_branch)); // take branch goes to pc 
			
	// This is where branching gets tricky 
	// passing in outputs from alu: alu_output and take_branch, but not exactly sure how to implmement it, so for now it's just buffers
	logic [31:0] ex_mem_pc, ex_mem_instruction;
	logic [31:0] MEM_out_1, MEM_out_2;
	logic [31:0] alu_output_final; 
	logic take_branch_final; 
	ex_mem stage3(.MEM_Rd(MEM_Rd), .ex_mem_pc(ex_mem_pc), .ex_mem_instruction(ex_mem_instruction),
									.MEM_out_1(MEM_out_1), .MEM_out_2(MEM_out_2), .alu_output_final(alu_output_final), 
									.take_branch_final(take_branch_final),
									.EX_Rd(EX_Rd), .id_ex_pc(id_ex_pc), .id_ex_instruction(id_ex_instruction), 
									.EX_out_1(EX_out_1), .EX_out_2(EX_out_2), .alu_output(alu_output), .take_branch(take_branch), .clk(clk)); 
									// put take_branch_final as input logic to pc_top_level, implementation may need adjusting 
							
	logic [7:0] HEX_out; 
	logic [7:0]HEX_out_temp;
	logic io_flag_01, io_flag_23; 
	logic io_flag_01_temp, io_flag_23_temp; 
	// data memory
	// input:	clk, reset, address, read_en, write_en, is_signed, xfer_size, write_data
	// output:	read_data
	data_memory d_mem(.clk(clk), .reset(reset), .read_en(mem_read), 
						.is_signed(data_mem_signed), .address(alu_output_final), 
						.xfer_size(xfer_size), .write_en(mem_write), 
						.write_data(reg_out_2), .read_data(data_mem_output),
						.HEX_out(HEX_out_temp), .io_flag_01(io_flag_01_temp), .io_flag_23(io_flag_23_temp));
	
	
	
	logic [31:0] mem_wb_pc, mem_wb_instruction;
	logic [31:0] MEM_out_1, MEM_out_2;
	logic [31:0] data_mem_ouput_final; 				
	mem_wb stage3 (.WB_Rd(Wb_Rd), .mem_wb_pc(mem_wb_pc), .mem_wb_instruction(mem_wb_instruction),
							.WB_out_1(WB_out_1), .WB_out_2(WB_out_1), .data_mem_ouput_final(data_mem_ouput_final), 
							.MEM_Rd(MEM_Rd), .ex_mem_pc(ex_mem_pc), .ex_mem_instruction(ex_mem_instruction), 
							.MEM_out_1(MEM_out_1), MEM_out_2(MEM_out_2), .data_mem_output(data_mem_output)); 
						
	logic [6:0]  out3, out2, out1, out0; 
	logic [1:0] counter; 
	logic [4:0] in0, in1, in2, in3;

	always_ff @(posedge clk) begin 
		if (reset) begin 
			in3 <= 5'd16;
			in2 <= 5'd16;
			in1 <= 5'd16; 
			in0 <= 5'd16;
			counter <= 2'b00;
		end else if (counter == 2'b00 && io_flag_01) begin 
			in3 <= in3; 
			in2 <= in2;
			in1 <= {1'b0, HEX_out[7:4]}; 
			in0 <= {1'b0, HEX_out[3:0]};
			counter <= 2'b01; 
		end else if (counter == 2'b01 && io_flag_23) begin 
			in3 <= {1'b0, HEX_out[7:4]}; 
			in2 <= {1'b0, HEX_out[3:0]};
			in1 <= in1; 
			in0 <= in0;
			counter <= 2'b10;
		end else if (counter == 2'b10) begin 
			in3 <= in3;
			in2 <= in2;
			in1 <= in1;
			in0 <= in0;
			counter <= 2'b11;
		end else if (counter == 2'b11) begin 
			in3 <= in3;
			in2 <= in2;
			in1 <= in1; 
			in0 <= in0;
			counter <= counter; 
		end else begin 
			in3 <= in3;
			in2 <= in2;
			in1 <= in1; 
			in0 <= in0; 
			counter <= counter; 
		end 
	end 
	
	logic io_flag_01_ub, io_flag_23_ub; 
	always_ff @(posedge clk) begin 
		if (reset) begin 
			io_flag_01 <= 1'b0;
			io_flag_23 <= 1'b0;
			HEX_out <= 8'd0; 
		end else begin 
			io_flag_01_ub <= io_flag_01_temp;
			io_flag_01 <= io_flag_01_ub; 
			
			io_flag_23_ub <= io_flag_23_temp;
			io_flag_23 <= io_flag_23_ub;
			HEX_out <= HEX_out_temp;
		end 

	end 
	// each HEX digit = 4 bits of data at a time 					
	display h3 (.in(in3), .out(out3)); 
	display h2 (.in(in2), .out(out2)); 
	display h1 (.in(in1), .out(out1)); 
	display h0 (.in(in0), .out(out0)); 
	
	// fsm for each hex output 
	fsm f3 (.clk(clk), .reset, .io_flag(io_flag_23), .in(out3), .out(HEX3));
	fsm f2 (.clk(clk), .reset, .io_flag(io_flag_23), .in(out2), .out(HEX2));
	fsm f1 (.clk(clk), .reset, .io_flag(io_flag_01), .in(out1), .out(HEX1));
	fsm f0 (.clk(clk), .reset, .io_flag(io_flag_01), .in(out0), .out(HEX0));
	
	
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


