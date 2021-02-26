// adder for auipc and branch instructions
`define WORD_SIZE		32

module branch_adder(clk, pc, imm, imm_U_J, imm_en, pc_out);
	`include "constants.svh"
	input logic clk;
	input logic [`WORD_SIZE - 1:0]pc;
	input logic [11:0]imm;			// for branch operations
	input logic [19:0]imm_U_J;		// for lui operations
	input logic [1:0]imm_en;		// tells us which immediate value to take
	output logic [`WORD_SIZE - 1:0]pc_out;
	logic [`WORD_SIZE - 1:0]pc_delayed;

	// pc needs a one clock cycle delay
	always_ff@(posedge clk) begin
		pc_delayed <= pc;
	end

	logic imm_sign, imm_J_sign;
	assign imm_sign = imm[11];
	assign imm_J_sign = imm_U_J[19];

	logic [`WORD_SIZE - 1:0]temp;
	always_comb begin
		case(imm_en)
		ALU_READ_IMM: begin // corresponds to all the branch instructions
			// sign extending immediate
			if (imm_sign) temp[`WORD_SIZE - 1:13] = 19'b1111111111111111111;
			else temp[`WORD_SIZE - 1:13] = 19'b0;

			temp[12:0] = {imm, 1'b0};  
		end
		ALU_READ_IMM_J: begin // corresponds to jal instruction 
			// sign extending immediate
			if (imm_J_sign) temp[`WORD_SIZE - 1:21] = 11'b11111111111;
			else temp[`WORD_SIZE - 1:21] = 11'b0;

			temp[20:0] = {imm_U_J, 1'b0};
		end
		ALU_READ_IMM_U: begin // corresponds to auipc instruction
			temp = {imm_U_J, 12'b0};
		end
		default: temp = 32'b0;
		
		endcase
	end 

	always_comb begin
		pc_out = (pc_delayed + temp);		
	end

endmodule

// module branch_adder_tb();
// 
// 	`include "constants.svh"
// 	logic [`WORD_SIZE - 1:0]pc;
// 	logic [11:0]imm;			// for branch operations
// 	logic [19:0]imm_U_J;		// for lui operations
// 	logic [1:0]imm_en;		// tells us which immediate value to take
// 	logic [`WORD_SIZE - 1:0] pc_out;
// 	
// 	branch_adder dut (.pc, .imm, .imm_U_J, .imm_en, .pc_out);
// 	
// 	parameter DELAY = 50; 
// 	
// 	initial begin 
// 		#DELAY 
// 		
// 		imm_en <= 00;												#DELAY;		
// 		imm <= 12'b000000000101; 								
// 		pc <= {20'd0, 12'b010101010101}; 					#DELAY; 
// 		imm_en <= ALU_READ_IMM;									#DELAY; // pc_out = {20'd0, 12'b101010101111}
// 		
// 		imm_en <= 00;												#DELAY;
// 		imm_U_J <= 20'b10101010101010101010;
// 		pc <= {20'b01010101010101010101, 12'd0}; 			#DELAY; 
// 		imm_en <= ALU_READ_IMM_U_J;							#DELAY; // pc_out = {20'b11111111111111111111, 12'd0} 
// 		$stop; 
// 	end 
// 	
// endmodule 
// 	
// 
