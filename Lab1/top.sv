// top level module for 32-bit rv32i processor

module top();
	logic clk, reset;
	logic [`WORD_SIZE - 1:0]instruction;
	logic	mem_write,
			reg_write,
			pc_en,
			take_branch,
			control_branch;
	logic [3:0]alu_signal;
	logic [`WORD_SIZE - 1:0]alu_output;
	logic [4:0]rs1, rs2, rd;

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
						.imm_en(imm_en), .alu_branch(take_branch), 
						.control_branch(control_branch), .address_out(address));


	// instruction memory
	// input:	clk, reset, address
	// output:	instruction
	instruction_memory inst_mem(.clk(clk), .reset(reset), 
								.address(address), .instruction(instruction));

	// register file
	// input:	clk, reset, read_reg_1, read_reg_2, wr_reg, wr_data, wr_en
	// output:	read_out_1, read_out_2
	register_file reg_file(.clk(clk), .reset(reset),
							.read_reg_1(), .read_reg_2(), .wr_reg(),
							.wr_data(), .wr_en(), .read_out_1(), .read_out_2());

	// data memory
	// input:	clk, reset, address, xfer_size, read_en, write_en, write_data
	// output:	read_data
	data_memory data_mem(.clk(clk), .reset(reset), .address(alu_output), .xfer_size(), 
						.read_en(), .write_en(), .write_data(), .read_data());

	// alu
	// input:	clk, reset, control, in_1, in_2
	// output:	out, take_branch
	alu my_alu(.clk(clk), .reset(reset), .pc(pc), .control(alu_signal),
			.in_1(rs1), .in_2(rs2), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
			.imm_en(imm_en), .out(alu_output), .take_branch(take_branch));

	// control signal
	// input:	instruction, mem_write, reg_write, 
	// output:	alu_signal	
	control_signal control(.instruction(instruction), .mem_write(mem_write), 
							.reg_write(reg_write), .alu_signal(alu_signal),
							.rs1(rs1), .rs2(rs2), .rd(rd),
							.imm(imm_12_bit), .imm_U_J(imm_20_bit), .imm_en);




endmodule
