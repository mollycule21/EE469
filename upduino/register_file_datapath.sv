// 32 bit output address_out from pc.sv is inputted into this mododule as instruction 
// outputs the three register address locations : source 1, source 2, and destination 
// outputs are then inputted into register file

`define WORD_SIZE		32
`define NUMBER_OF_REGS	32

// need a control logic to determine which type of instruction it is
module register_file_datapath(instruction, rs1, rs2, rd);
	input logic [`WORD_SIZE - 1:0]instruction;

	output logic [4:0]rs1, rs2;
	output logic [4:0]rd;

	
	// 32 32-bit registers 
	// logic [`WORD_SIZE - 1:0] register [`NUMBER_OF_REGS - 1:0];
	// register x0 has value 0
	// assign register[0] = 32'b0;
	
	// 7-bit op code values
	localparam  [6:0]op 		= 7'b0110011;
	localparam  [6:0]op_imm 	= 7'b0010011; 
	localparam  [6:0]branch 	= 7'b1100011;
	localparam  [6:0]lui		= 7'b0110111;
	localparam  [6:0]auipc		= 7'b0010111;
	localparam  [6:0]jal		= 7'b1101111;
	localparam  [6:0]jalr		= 7'b1100111;
	localparam  [6:0]load		= 7'b0000011;
	localparam  [6:0]store		= 7'b0100011;

	// instruction logics
	logic [6:0]opcode;
	logic [2:0]funct3;
	logic [6:0]funct7;
	logic [11:0]imm;		// this imm applies for I and S type
	logic [19:0]imm_U_type;	// this imm applied for U type

	// load opcode
	assign opcode = instruction[6:0];

	// check the opcode
	// 1 opcode for behavior in each type 
	// R-type: op, 
	// I-type: op-imm, jalr, load // all have diff opcodes, but all I type
	// S-type: branch, store
	// U-type: lui, auipc, jal
	always_comb begin
		if (opcode == op) begin
			// R-type
			funct7	= instruction[31:25];
			rs2		= instruction[24:20];
			rs1		= instruction[19:15];
			funct3	= instruction[14:12];
			rd		= instruction[11:7];
		end else if (opcode == op_imm || opcode == jalr || opcode == load) begin
			// I-type
			imm		= instruction[31:20];
			rs1		= instruction[19:15];
			funct3	= instruction[14:12];
			rd		= instruction[11:7];
		end else if (opcode == branch || opcode == store) begin
			// S-type
			imm[11:5]	= instruction[31:25];
			rs2			= instruction[24:20];
			rs1			= instruction[19:15];
			funct3		= instruction[14:12];
			imm[4:0]	= instruction[11:7];
		end else begin
			// U-type
			imm_U_type	= instruction[31:12];
			rd			= instruction[11:7];
		end
	end



endmodule 
			
