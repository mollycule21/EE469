// top level module for 32-bit rv32i processor
`define WORD_SIZE 	32
`define TESTING

`ifndef TESTING
module top(gpio_2, led_red, led_blue, led_green, spi_cs, serial_txd);
	`include "constants.svh"

	input wire gpio_2;
	output wire led_red;
	output wire led_blue;
  	output wire led_green;
  	output wire spi_cs;
  	output wire serial_txd;
`else
module top();
	`include "constants.svh"
`endif

	logic clk, reset;

`ifndef TESTING
	assign spi_cs = 1'b1;
	assign reset = ~gpio_2;
	/* verilator lint_off PINMISSING */
	SB_HFOSC u_SB_HFOSC(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
	/* verilator lint_on PINMISSING */
`endif

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

	// pc address
	logic [`WORD_SIZE - 1:0]address;

	// top level module for pc
	// input:	clk, reset, imm, imm_U_J, imm_en, alu_branch, control_branch
	// output:	address_out
	pc_top_level pc_top(.clk(clk), .reset(reset), .imm(imm_12_bit), .imm_U_J(imm_20_bit), 
						.imm_en(imm_en), .register_for_jalr(reg_out_1), .alu_branch(take_branch), 
						.control_branch(control_branch), .jalr_branch(jalr_branch), 
						.address_out(address));


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
						.write_data(reg_out_2), .read_data(data_mem_output),
						.serial_txd(serial_txd));
`ifndef TESTING
    // LED driver
    SB_RGBA_DRV RGB_DRIVER (
      .RGBLEDEN(1'b1                                            ),
      .RGB0PWM (1'b0											),
      .RGB1PWM (1'b0											),
      // red LED tied to "reset" to indicate when you're triggering reset
      .RGB2PWM (reset                                           ),
      .CURREN  (1'b1                                            ),
      .RGB0    (led_green                                       ),
      .RGB1    (led_blue                                        ),
      .RGB2    (led_red                                         )
    );
    defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";
`endif

`ifdef TESTING
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD /  2) clk <= ~clk;
	end

	// set up output
	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, clk, reset, instruction, mem_read,
					mem_write, take_branch, control_branch,
					jalr_branch, data_mem_signed, reg_write, alu_signal,
					alu_output, data_mem_output, reg_out_1, reg_out_2, 
					rs1, rs2, rd, xfer_size, imm_12_bit, imm_20_bit, imm_en, address);
	end

	// tests
	initial begin
		reset <= 1'b1;			@(posedge clk);
		reset <= 1'b0;			@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								#60000;
								#60000;
		$finish;
	end
`endif
endmodule










