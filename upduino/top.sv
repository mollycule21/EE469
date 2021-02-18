// top level module for 32-bit rv32i processor

module top();
	logic clk, reset;
	logic [`WORD_SIZE - 1:0]instruction;
	logic take_branch;
	logic [3:0]alu_signal;

	// program counter
	// input: 	clk, reset, take_branch, address_increment_en, address_in
	// output:	address_out
	pc my_pc(.clk(clk), .reset(reset), .take_branch(take_branch), 
			.address_increment_en, .address_in, .address_out);

	auipc_adder auipc(.pc(address_out), .imm(), .pc_out());

	// instruction memory
	// input:	clk, reset, address
	// output:	instruction
	instruction_memory inst_mem(.clk(clk), .reset(reset), .address, .instruction);

	// register file
	// input:	clk, reset, read_reg_1, read_reg_2, wr_reg, wr_data, wr_en
	// output:	read_out_1, read_out_2
	register_file reg_file(.clk(clk), .reset(reset),
							.read_reg_1(), .read_reg_2(), .wr_reg(),
							.wr_data(), .wr_en(), .read_out_1(), .read_out_2());

	// data memory
	// input:	clk, reset, address, xfer_size, read_en, write_en, write_data
	// output:	read_data
	data_memory data_mem(.clk(clk), .reset(reset), .xfer_size(), 
						.read_en(), .write_en(), .write_data(), .read_data());

	// alu
	// input:	clk, reset, control, in_1, in_2
	// output:	out, take_branch
	alu my_alu(.clk(clk), .reset(reset), .control(alu_signal),
			.in_1(), .read_out_2(), .imm(), .imm_U_J, .imm_en(), 
			.out(), .take_branch(take_branch));

	// control signal
	// input:	instruction, mem_write, reg_write, 
	// output:	alu_signal	
	control_signal control(.instruction(instruction), .mem_write(), 
							.reg_write(), .alu_signal(alu_signal),
							.read_reg_1(), .read_reg_2(), .wr_reg());




endmodule
