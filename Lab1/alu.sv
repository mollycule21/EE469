// control signal mapping are in constants.svh

// alu_signal (output regfile_datapath.sv) --> input control 
// register (output) read_out_1 and in_2  -->  in_1 and in_2


// TODO: add an enable signal, alu is not running @ every clock cycle

`define WORD_SIZE	32

module alu(clk, reset, pc, control, in_1, in_2, imm, imm_U_J, imm_en, out, take_branch);
	`include "constants.svh"

	input logic clk, reset;
	input logic [4:0]control;							// 3-bit control signal for ALU 
	input logic [`WORD_SIZE - 1:0]in_1, in_2;			// signed inputs
	input logic [`WORD_SIZE - 1:0]pc;
	input logic [1:0]imm_en;
	input logic [11:0]imm;
	input logic [19:0]imm_U_J;
	
	output logic [`WORD_SIZE - 1:0]out; 
	output logic take_branch;

	logic sign;
	logic [`WORD_SIZE - 1:0]sorted_in_2;
	
	// this combinational logic act as the mux
	always_comb begin
		case(imm_en)
		
			ALU_READ_RS2:		sorted_in_2 = in_2;	
			
			ALU_READ_IMM: begin
				// sign extenting the immediate
				sign = imm[11];		// sign of the immediate
				if (sign) sorted_in_2[`WORD_SIZE - 1:12] = 20'b1; // negative sign extension 
				else sorted_in_2[`WORD_SIZE - 1:12] = 20'b0; // zero extension 

				sorted_in_2[11:0] = imm;
				end
				
			ALU_READ_IMM_U: begin
				sorted_in_2[`WORD_SIZE - 1:12] = imm_U_J; 
				sorted_in_2[11:0] = 12'd0;
			end
			
			ALU_READ_IMM_J: begin
				sorted_in_2 = 32'dx; 
			end
		
		endcase
	end

	// temp variable for less than operations
	logic [`WORD_SIZE - 1:0]less_than_temp;
	always_comb begin
		less_than_temp = in_1 - in_2;
	end

	// dff logic
	always_ff@(posedge clk) begin
		if (reset) begin
			out <= 32'd0;
			take_branch <= 0;
		end else begin
			case(control) 
			ALU_ADD_I: begin
				out 		<= in_1 + sorted_in_2;
				take_branch <= 0;
			end
			ALU_SUB_I: begin
				out 		<= in_1 - sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_AND_I: begin
				out 		<= in_1 & sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_OR_I: begin
				out 		<= in_1 | sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_XOR_I: begin
				out 		<= in_1 ^ sorted_in_2;
				take_branch <= 0; 
			end 
			ALU_SLL_I: begin  
				out 		<= in_1 << sorted_in_2[4:0];
				take_branch <= 0; 
			end 
			ALU_SRL_I: begin 
				out 		<= in_1 >> sorted_in_2[4:0];
				take_branch <= 0; 
			end 
			ALU_SRA_I: begin 
				out 		<= in_1 >>> sorted_in_2[4:0];
				take_branch <= 0; 
			end 
			ALU_BEQ: begin	
				out <= 32'd0;
				if (in_1 == sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BNE: begin
				out <= 32'd0;
				if (in_1 != sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end
			ALU_BLT: begin 
				out <= 32'd0; 	
				if (less_than_temp[31])		take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BGE: begin
				out <= 32'd0;
				if (less_than_temp[31])		take_branch <= 0;
				else						take_branch <= 1;
			end 
			ALU_BLT_U: begin
				out <= 32'd0;
				if (in_1 < sorted_in_2)		take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_BGE_U: begin
				out <= 32'd0;
				if (in_1 >= sorted_in_2)	take_branch <= 1;
				else						take_branch <= 0;
			end 
			ALU_SLT_I: begin 
				take_branch <= 0;
				if (less_than_temp[31])		out <= 32'd1;
				else						out <= 32'd0;
			end 
			ALU_SLT_I_U: begin
				take_branch <= 0;
				if (in_1 < sorted_in_2)		out <= 32'd1;
				else						out <= 32'd0;
			end
			ALU_JAL_R: begin
				take_branch <= 1;
				out <= pc + 32'd4;
			end
			ALU_LUI: begin
				take_branch <= 0;
				out <= sorted_in_2;
			end
			ALU_AUIPC: begin
				take_branch <= 1;
				out <= pc + sorted_in_2;
			end
			endcase
		end
	end

endmodule

`define WORD_SIZE		32

// Correct on Modelsim 
module alu_tb();
	`include "constants.svh"
	logic clk, reset;
	logic [4:0]control;
	logic take_branch;
	logic signed [`WORD_SIZE - 1:0]in_1, in_2;
	logic signed [`WORD_SIZE - 1:0]out;
	logic [`WORD_SIZE - 1:0]pc;
	logic [11:0]imm;
	logic [19:0]imm_U_J;
	logic [1:0]imm_en;

	// dut
	alu alu_dut(.clk(clk), .reset(reset), .pc(pc), .control(control),
				.in_1(in_1), .in_2(in_2), .imm(imm), .imm_U_J(imm_U_J), 
				.imm_en(imm_en), .out(out), .take_branch(take_branch));

	// set up clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

//	// output vars
//	initial begin
//		$dumpfile("alu.vcd");
//		$dumpvars(0, clk, reset, pc, control, in_1, in_2, imm, imm_U_J,
//					imm_en, out, take_branch);
//	end

	// tests
	initial begin
		reset <= 1; imm_en <= ALU_READ_RS2;									@(posedge clk); // sorted_in_2 = 32'd11; 
		// addition
		reset <= 0; 																@(posedge clk);
		control <= ALU_ADD_I; in_1 <= -32'd2; in_2 <= 32'd11;			@(posedge clk); // out = 32'd9, take_branch = 0; 
		assert (out == 32'd9);													@(posedge clk); // check for error 
		// subtraction, result is negative
		control <= ALU_SUB_I;													@(posedge clk); // out = -32'd13
		// subtraction, result is positive
		in_1 <= 32'd11; in_2 <= 32'd9;										@(posedge clk); // out = 32'd2; 
		
		// and
		control <= ALU_AND_I; in_1 <= -32'd1; in_2 <= 32'd0;			@(posedge clk); // out = 0;
									 in_1 <= 32'd6; in_2 <= 32'd5; 			@(posedge clk); // out = {29'd0, 110} & {29'd0}, 101} = {29'd0, 1, 00}
		// or
		control <= ALU_OR_I; 													@(posedge clk); // out = {29'd0, 111}
									in_1 <= -32'd1; in_2 <= 32'd0;			@(posedge clk); // out = -32'd1; 
		
		// xor
		control <= ALU_XOR_I; in_1 <= -32'd1; in_2 <= -32'd1;			@(posedge clk); // out = 0; 
									 in_1 <= 32'd6; in_2 <= 32'd5;			@(posedge clk); // out = {29'd0, 0, 11}
		// sl
		control <= ALU_SLL_I; in_1 <= 32'd30; in_2 <= 32'd5;			@(posedge clk); // out = 32'd960; 
		// srl
		control <= ALU_SRL_I; in_1 <= 32'd960; in_2 <= 32'd5;			@(posedge clk); // out = 32'd30; 
		// sra
		control <= ALU_SRA_I;													@(posedge clk); // out = 0 ???? 
		// branch if equal
		control <= ALU_BEQ; in_1 <= 32'd10; in_2 <= 32'd10;			@(posedge clk); // out = 0; take_branch = 1; 
		// branch if not equal
		control <= ALU_BNE; in_1 <= -32'd9; in_2 <= 32'd9;				@(posedge clk); // take_branch = 0; 
		// branch if less than
		control <= ALU_BLT;														@(posedge clk); // take_branch = 1; 
		// branch if greater equal
		control <= ALU_BGE; in_1 <= -32'd20; in_2 <= -32'd30;			@(posedge clk); // take_branch = 1; 
		// branch if less than unsigned
		control <= ALU_BLT_U; in_1 <= 32'd10; in_2 <= 32'd5;		@(posedge clk); // take_branch = 0; 
		// branch if greater equal unsigned
		control <= ALU_BGE_U; in_1 <= 32'd20; in_2 <= 32'd10;		@(posedge clk); // take branch = 1; 
		
		// set less than
		control <= ALU_SLT_I; in_1 <= -32'd10; in_2 <= 32'd90;			@(posedge clk); // out = 32'd1, take branch  = 0; 
		// set less than unsigned
		control <= ALU_SLT_I_U; in_1 <= 32'd10; in_2 <= {20'b00000111110000011111, 12'd1};	@(posedge clk); // out = 1; 
		
		// jal and jalr
		control <= ALU_JAL_R; pc <= 32'd4; 						@(posedge clk); // out = 32'd8, take_branch = 1, 
		// auipc
		imm_en <= ALU_READ_IMM_U; control <= ALU_AUIPC; imm_U_J <= {20'b00111000001111100000};  @(posedge clk); // out = imm_u_j, 12'd4
																																@(posedge clk);
																		
		$stop;
	end

endmodule
