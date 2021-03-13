// top level module for 32-bit rv32i processor

`include "constants.svh"
`include "pc.sv"
`include "pc_adder.sv"
`include "pc_in_out.sv"
`include "pc_mux.sv"
`include "pc_top_level.sv"
`include "branch_adder.sv"
`include "jalr_adder.sv"
`include "instruction_memory.sv"
`include "instruction_type.sv"
`include "control_signal.sv"
`include "register_file.sv"
`include "if_id.sv"
`include "forwarding.sv"
`include "id_ex.sv"
`include "alu.sv"
`include "ex_mem.sv"
`include "mem_wb.sv"
`include "wb.sv"
`include "data_memory.sv"
`include "hazard_detection_unit.sv"


// `include "alu.sv"
// `include "mem_wb.sv"
// `include "alu.sv"
// `include "data_memory.sv"

// `include "clock_divider.sv"
// `include "display.sv"
// `include "fsm.sv"
// `include "forwarding.sv"
// `include "id_ex.sv"

`define WORD_SIZE 	32
`define TESTING

`ifndef TESTING
module top(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR,
					 CLOCK_50);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic CLOCK_50;
`else
// module top(reset, clk, do_WB, WB_data, EX_out_1, EX_out_2); // test_1 
module top (reset, clk);

`endif

`ifdef TESTING			// logics used in software simulation
	input logic clk; 
	input logic reset;
	// input logic do_WB;
	// input logic [31:0] WB_data;
	// input logic [31:0] data_mem_output_final, wb_data_out; 
	//input logic [31:0] EX_out_1, EX_out_2; 

	
`else					// logics used in hardware

	// Generate clk off of CLOCK_50, whichClock picks rate
	logic [31:0] divided_clocks;
	parameter whichClock = 12;
	logic clk; 
	// assign clk = divided_clocks[whichClock];
	assign clk = CLOCK_50;
		
	clock_divider cdiv(.clock(CLOCK_50), .divided_clocks(divided_clocks));
`endif
	
	
	// delcaring structs for each tage 
	control_outputs dec_control_outputs;
	control_outputs EX_control_outputs;
	control_outputs MEM_control_outputs;
	control_outputs WB_control_outputs;
	
	// keeping track of outputs from control_signal and passing it down a stage at each posedge clk 
	always_ff @(posedge clk) begin
		EX_control_outputs <= dec_control_outputs;
		MEM_control_outputs <= EX_control_outputs;
		WB_control_outputs<= MEM_control_outputs;
	end
	
	// making sure that logics are written before read 
	logic write_half, read_half;
	logic rw_counter;
	always_comb begin 
		if (reset) begin 
			write_half = 1'b0; 
			read_half = 1'b0;
			rw_counter = 1'b0; 
		end else if (rw_counter == 0) begin 
			write_half = 1'b1; 
			read_half = 1'b0;
			rw_counter = 1'b1; 
		end else if (rw_counter == 1) begin 
			write_half = 1'b0; 
			read_half = 1'b1;
			rw_counter = 1'b0; 			
		end else begin 
			write_half = 1'b0; 
			read_half = 1'b0; 
			rw_counter = 1'b0;
		end 
	end
	
	// necessary logics 
	logic [32 - 1:0]instruction;
	logic [1:0]reg_write;
	logic [4:0]alu_signal;
	logic [`WORD_SIZE - 1:0] alu_output, data_mem_output, reg_out_1, reg_out_2;
	logic [4:0] rs1, rs2;
	logic [1:0] xfer_size;
	// logic do_WB; 
	
	// immediate values
	logic [19:0]imm_20_bit;
	logic [11:0]imm_12_bit;
	logic [1:0]imm_en;
	
	parameter nill = ~(7'b0000000);
	assign HEX5 = nill; 
	assign HEX4 = nill;
	
	// pc address
	logic [`WORD_SIZE - 1:0]address;

	// id_ex
	logic [31:0] id_ex_alu_in_1, id_ex_alu_in_2;
	logic [31:0] id_ex_pc, id_ex_instruction;
	logic [31:0] EX_out_1, EX_out_2;
	logic stall;

	//ex_mem 
	logic [31:0] ex_mem_pc, ex_mem_instruction;
	logic [31:0] ex_mem_alu_output; 
	logic take_branch_final;
	
	// data_memory 
	logic [7:0] HEX_out; 
	logic [7:0]HEX_out_temp;
	logic io_flag_01, io_flag_23; 
	logic io_flag_01_temp, io_flag_23_temp; 
	
	// mem_wb 
	logic [31:0] mem_wb_pc, mem_wb_instruction;
	logic [31:0] data_mem_output_final; 
	logic [31:0] alu_output_final; 

	// wb
	logic do_WB;
	logic [31:0] WB_data; 
	

	// top level module for pc
	pc_top_level pc_top(.clk(clk), .reset(reset), .imm(dec_control_outputs.imm), .imm_U_J(dec_control_outputs.imm_U_J), // inputs  
						.imm_en(dec_control_outputs.imm_en), .register_for_jalr(reg_out_1), .alu_branch(take_branch_final), 
						.control_branch(dec_control_outputs.control_branch), .jalr_branch(dec_control_outputs.jalr_branch), 
						.stall(stall), .address_out(address)); // outputs 


	// instruction memory
	// input:	clk, reset, address
	// output:	instruction
	instruction_memory inst_mem(.clk(clk), .reset(reset), .stall(stall), .address(address), // inputs 
											.instruction(instruction));	// outputs 
	
	
	// 5 stage pipeline: END OF STAGE 1 - Fetch: read the instruction from code memory
	// clocking instruction and address **** MAY NEED TO CHANGE INSTRUCTION TO OPCODE FOR EFFICENCY 
	logic [31:0] if_id_pc, if_id_instruction;
	
	if_id stage1 (.if_id_pc(if_id_pc), .if_id_instruction(if_id_instruction), // outputs 
							.clk(clk), .reset(reset), .address(address), .instruction(instruction)); // inputs 
							
	// control signal: decode instruction
	control_signal control (.dec_control_outputs(dec_control_outputs), // outputs 
										.rs1(rs1), .rs2(rs2), .instruction(if_id_instruction)); // inputs 
	
	// hazard detection unit
	// checks if the instruction in the current execution stage is a load word instruction
	// with a destination matching one of the src operands of the instruction in the decode
	hazard_detection_unit hazard_detection(.clk(clk), .EX_instruction(id_ex_instruction), .ID_instruction(if_id_instruction), 
											.EX_rd(EX_control_outputs.rd), .ID_rd(dec_control_outputs.rd), .ID_rs1(rs1), .ID_rs2(rs2), .stall(stall));


	// register file
	register_file reg_file(.clk(clk), .reset(reset), // inputs 
							.read_reg_1(rs1), .read_reg_2(rs2), .wr_reg(WB_control_outputs.rd),
							.WB_data(WB_data), 
							.EX_out_1(EX_out_1), .EX_out_2(EX_out_2), // RF_out of previous instruction 
							.do_WB(do_WB), 
							.read_out_1(reg_out_1), .read_out_2(reg_out_2)); // outputs // RF of current instruction 
							
	// -----------------------=------------------ end of test1_waveform for test_tb -----------------------=-----------------
	// Check for data fowarding in case of hazzards 
	logic [1:0] forwardA, forwardB;
	forwarding checkforwarding(.forwardA(forwardA), .forwardB(forwardB), // outputs 
											.EX_Reg_Write(EX_control_outputs.reg_write), .MEM_Reg_Write(MEM_control_outputs.reg_write), // inputs 
											.WB_Reg_Write(WB_control_outputs.reg_write), 
											.EX_Rd(EX_control_outputs.rd), .MEM_Rd(MEM_control_outputs.rd), .WB_Rd(WB_control_outputs.rd),
											.rs1(rs1), .rs2(rs2));
							
	// 5 stage pipeline: END OF STAGE 2 - Decode/Register access: decode the instruction and read the register file
	// Overwrite read_out_1 and read_out_2 before it enters alu if there is a forwarding hazard 

	// ------------------------------------------------ end of decode stage -----------------------------------------

	id_ex stage2 (.id_ex_alu_in_1(id_ex_alu_in_1), .id_ex_alu_in_2(id_ex_alu_in_2), // outputs 
							.id_ex_pc(id_ex_pc),.id_ex_instruction(id_ex_instruction),
							.EX_out_1(EX_out_1), .EX_out_2(EX_out_2), 
							.forwardA(forwardA), .forwardB(forwardB), .read_out_1(reg_out_1), .read_out_2(reg_out_2), // inputs 
							//forwarding works for add/sub instructions  - TODO: make sure it works for other instructions 
							.alu_out(alu_output), .mem_read_out(ex_mem_alu_output), .wb_data_out(WB_data),  
							.if_id_pc(if_id_pc), .if_id_instruction(if_id_instruction), .clk(clk));

	// ------------------------------------------------ start of execution stage ------------------------------------
	

	// tell alu to take current instruction (write_half ) or read previous instruction (read_half) 
	// at write half: write in current inputs 
	// at read half: read for at that stage in pipeline 
	logic [`WORD_SIZE - 1:0] alu_pc;
	logic [4:0] alu_control;
	logic [`WORD_SIZE - 1:0]alu_in_1;
	logic [`WORD_SIZE - 1:0]alu_in_2;
	logic [11:0] alu_imm; 
	logic [19:0] alu_imm_U_J;
	logic [1:0] alu_imm_en; 
	
	// always_comb begin 
	// 	// write in logics for current instructions 
	// 	if(write_half == 1'b1 && read_half ==1'b0) begin 
	// 		alu_pc = if_id_pc;
	// 		alu_control = EX_control_outputs.alu_signal;
	// 		alu_in_1 = id_ex_alu_in_1;
	// 		alu_in_2 = id_ex_alu_in_2;
	// 		alu_imm = EX_control_outputs.imm; 
	// 		alu_imm_U_J = EX_control_outputs.imm_U_J;
	// 		alu_imm_en = EX_control_outputs.imm_en; 
	// 	// read logics from previous instructions -aka does not change yet at read half 
	// 	end else if (read_half == 1'b1 && write_half == 1'b0) begin 
	// 		alu_pc = ex_mem_pc;
	// 		alu_control = MEM_control_outputs.alu_signal;
	// 		alu_in_1 = ex_mem_alu_in_1;
	// 		alu_in_2 = ex_mem_alu_in_2;
	// 		alu_imm = MEM_control_outputs.imm; 
	// 		alu_imm_U_J = MEM_control_outputs.imm_U_J;
	// 		alu_imm_en = MEM_control_outputs.imm_en; 
	// 	end else begin 
	// 		alu_pc = ex_mem_pc;
	// 		alu_control = MEM_control_outputs.alu_signal;
	// 		alu_in_1 = ex_mem_alu_in_1;
	// 		alu_in_2 = ex_mem_alu_in_2;
	// 		alu_imm = MEM_control_outputs.imm; 
	// 		alu_imm_U_J = MEM_control_outputs.imm_U_J;
	// 		alu_imm_en = MEM_control_outputs.imm_en; 
	// 	end 
	// end 

	// can probably use a struct 
	alu my_alu(.clk(clk), .reset(reset), // inputs 
					.pc(id_ex_pc), .control(EX_control_outputs.alu_signal), .in_1(id_ex_alu_in_1), .in_2(id_ex_alu_in_2),
					.imm(EX_control_outputs.imm), .imm_U_J(EX_control_outputs.imm_U_J), .imm_en(EX_control_outputs.imm_en), 
					.out(alu_output), .take_branch(take_branch)); // outputs // take branch goes to ex_mem then its clocked output goes to pc 
	
	// ------------------------------------------------ end of execute stage --------------------------------------------------	
	// TODO: maybe we don't need instruction
	// This is where branching gets tricky 
	// passing in outputs from alu: alu_output and take_branch, but not exactly sure how to implmement it, so for now it's just buffers 
	ex_mem stage3(.ex_mem_pc(ex_mem_pc), .ex_mem_instruction(ex_mem_instruction), // outputs 
									.ex_mem_alu_output(ex_mem_alu_output), .take_branch_final(take_branch_final), 
									.id_ex_pc(id_ex_pc), .id_ex_instruction(id_ex_instruction), // inputs 
									.alu_output(alu_output), .take_branch(take_branch),
									.clk(clk)); 
								// put take_branch_final as input logic to pc_top_level, implementation may need adjusting 				
	// ------------------------------------------------ start of mem stage ------------------------------------------------------
	
	
	// data memory
	// input:	clk, reset, address, read_en, write_en, is_signed, xfer_size, write_data
	// output:	read_data
	

	data_memory d_mem(.clk(clk), .reset(reset), .read_en(MEM_control_outputs.mem_read), // inputs 
						.is_signed(MEM_control_outputs.data_mem_signed), .address(ex_mem_alu_output), 
						.xfer_size(MEM_control_outputs.xfer_size), .write_en(MEM_control_outputs.mem_write), 
						.write_data(id_ex_alu_in_2), 
						.read_data(data_mem_output) // outputs 
						// .HEX_out(HEX_out_temp), .io_flag_01(io_flag_01_temp), .io_flag_23(io_flag_23_temp)
						); // inputs 

	// // checking to see if previous instruction is load and current instrution is store & overwrite if so 
	// mem_to_mem_hazard m_m (.mem_wb_dmo(.mem_wb_dmo), // outputs 
	// 							.dmo(data_mem_output), .wb_dmo_load_inst(data_mem_output_final), // inputs - current data, data overiding with 
	// 							.ex_mem_instruction(ex_mem_instruction), .mem_wb_instruction)(mem_wb_instruction)); // inputs - current & next inst

	// ------------------------------------------------ end of mem stage ------------------------------------------------------		
	mem_wb stage4 (.mem_wb_pc(mem_wb_pc), .mem_wb_instruction(mem_wb_instruction), // outputs 
							.data_mem_output_final(data_mem_output_final), .alu_output_final(alu_output_final),
							.ex_mem_pc(ex_mem_pc), .ex_mem_instruction(ex_mem_instruction), // inputs 
							.data_mem_output(data_mem_output), .ex_mem_alu_output(ex_mem_alu_output), .clk(clk)); 
				
	// ------------------------------------------------ start of wb stage ------------------------------------------------------							
	wb stage5 (.WB_data(WB_data), .do_WB(do_WB), //outputs 
						.WB_reg_write(WB_control_outputs.reg_write), .alu_output_final(alu_output_final), //inputs 
						.data_mem_output_final(data_mem_output_final), .clk(clk)); 
	
	// // ------------------- wb stage ends after its data is inputted in register file located in decoder stage  ------------------------------------------------------	
						
	// logic [6:0]  out3, out2, out1, out0; 
	// logic [1:0] counter; 
	// logic [4:0] in0, in1, in2, in3;

	// always_ff @(posedge clk) begin 
	// 	if (reset) begin 
	// 		in3 <= 5'd16;
	// 		in2 <= 5'd16;
	// 		in1 <= 5'd16; 
	// 		in0 <= 5'd16;
	// 		counter <= 2'b00;
	// 	end else if (counter == 2'b00 && io_flag_01) begin 
	// 		in3 <= in3; 
	// 		in2 <= in2;
	// 		in1 <= {1'b0, HEX_out[7:4]}; 
	// 		in0 <= {1'b0, HEX_out[3:0]};
	// 		counter <= 2'b01; 
	// 	end else if (counter == 2'b01 && io_flag_23) begin 
	// 		in3 <= {1'b0, HEX_out[7:4]}; 
	// 		in2 <= {1'b0, HEX_out[3:0]};
	// 		in1 <= in1; 
	// 		in0 <= in0;
	// 		counter <= 2'b10;
	// 	end else if (counter == 2'b10) begin 
	// 		in3 <= in3;
	// 		in2 <= in2;
	// 		in1 <= in1;
	// 		in0 <= in0;
	// 		counter <= 2'b11;
	// 	end else if (counter == 2'b11) begin 
	// 		in3 <= in3;
	// 		in2 <= in2;
	// 		in1 <= in1; 
	// 		in0 <= in0;
	// 		counter <= counter; 
	// 	end else begin 
	// 		in3 <= in3;
	// 		in2 <= in2;
	// 		in1 <= in1; 
	// 		in0 <= in0; 
	// 		counter <= counter; 
	// 	end 
	// end 
	
	// logic io_flag_01_ub, io_flag_23_ub; 
	// always_ff @(posedge clk) begin 
	// 	if (reset) begin 
	// 		io_flag_01 <= 1'b0;
	// 		io_flag_23 <= 1'b0;
	// 		HEX_out <= 8'd0; 
	// 	end else begin 
	// 		io_flag_01_ub <= io_flag_01_temp;
	// 		io_flag_01 <= io_flag_01_ub; 
			
	// 		io_flag_23_ub <= io_flag_23_temp;
	// 		io_flag_23 <= io_flag_23_ub;
	// 		HEX_out <= HEX_out_temp;
	// 	end 

	// end 
	// // each HEX digit = 4 bits of data at a time 					
	// display h3 (.in(in3), .out(out3)); 
	// display h2 (.in(in2), .out(out2)); 
	// display h1 (.in(in1), .out(out1)); 
	// display h0 (.in(in0), .out(out0)); 
	
	// // fsm for each hex output 
	// fsm f3 (.clk(clk), .reset, .io_flag(io_flag_23), .in(out3), .out(HEX3));
	// fsm f2 (.clk(clk), .reset, .io_flag(io_flag_23), .in(out2), .out(HEX2));
	// fsm f1 (.clk(clk), .reset, .io_flag(io_flag_01), .in(out1), .out(HEX1));
	// fsm f0 (.clk(clk), .reset, .io_flag(io_flag_01), .in(out0), .out(HEX0));
	
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
