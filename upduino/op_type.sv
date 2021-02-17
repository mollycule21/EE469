// 32 bit output address_out from pc.sv is inputted into this mododule as instruction 
// outputs the three register address locations : source 1, source 2, and destination 
// outputs are then inputted into control file 

`define WORD_SIZE		32
`define NUMBER_OF_REGS	32

// need a control logic to determine which type of instruction it is
module op_type (instruction, RISU_type, opcode);
	input logic [`WORD_SIZE - 1:0]instruction;

	// output logic [4:0]rs1, rs2;
	// output logic [4:0]rd;
	output logic [1:0] RISU_type; // 00 = R, 01 = I, 10 = S , 11 = U
	output logic [7:0] opcode; 

	
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

	// load opcode
	assign opcode = instruction[6:0];

	// check the opcode
	// 1 opcode for behavior in each type 
	// R-type: op, 
	// I-type: op-imm, jalr, load // all have diff opcodes, but all I type
	// S-type: branch, store
	// U-type: lui, auipc, jal
	
	// takes in opcode and organizes 32 bit instruction binary depending on the type 
	always_comb begin
		if (opcode == op) begin
			// R-type
			RISU_type = 00; 
		end else if (opcode == op_imm || opcode == jalr || opcode == load) begin
			RISU_type = 01; 
		end else if (opcode == branch || opcode == store) begin
			// S-type
			RISU_type = 10; 
		end else begin
			// U-type
			RISU_type = 11; 
		end
	end



endmodule 
			
