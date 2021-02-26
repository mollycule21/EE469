module pc_top_level_tb();
	`include "constants.svh"
	
	logic clk, reset, pc_en;
	logic [11:0]imm;
	logic [19:0]imm_U_J;
	logic [1:0]imm_en;
	logic alu_branch, control_branch;
	logic [`WORD_SIZE - 1:0]address_out;
	
	pc_top_level pctl(.clk, .reset, .pc_en, .imm, .imm_U_J,
						.imm_en, .alu_branch, .control_branch, .address_out);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	// dump file
	initial begin
		$dumpfile("pc_top_level_tb.vcd");
		$dumpvars(0, clk, reset, pc_en, imm, imm_U_J, imm_en,
				alu_branch, control_branch, address_out);
	end

	initial begin
		reset <= 1'b1;															@(posedge clk);
		reset <= 1'b0;															@(posedge clk);
		// branch instructions
		control_branch <= 1'b1; imm <= 12'h00c; imm_en <= ALU_READ_IMM;			@(posedge clk);
		// alu_branch and control_branch
		control_branch <= 1'b0;													@(posedge clk);
		alu_branch <= 1'b1; 													@(posedge clk);
		alu_branch <= 1'b0; 													@(posedge clk);
		imm_U_J <= 20'h0f0; imm_en <= ALU_READ_IMM_J; control_branch <= 1'b1;	@(posedge clk);
																				@(posedge clk);
		alu_branch <= 1'b1;														@(posedge clk);
		alu_branch <= 1'b0; control_branch <= 1'b0;								@(posedge clk);
		imm_U_J <= 20'h00cd0; imm_en <= ALU_READ_IMM_U; control_branch <= 1'b1;	@(posedge clk);
																				@(posedge clk);
		alu_branch <= 1'b1;														@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
		$finish;
	end


endmodule
