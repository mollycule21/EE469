`define WORD_SIZE		32

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

// instruction types
localparam [2:0]INSTRUCTION_TYPE_R	= 3'b000;
localparam [2:0]INSTRUCTION_TYPE_I	= 3'b001;
localparam [2:0]INSTRUCTION_TYPE_S	= 3'b010;
localparam [2:0]INSTRUCTION_TYPE_U	= 3'b011;
localparam [2:0]INSTRUCTION_TYPE_B	= 3'b100;
localparam [2:0]INSTRUCTION_TYPE_J	= 3'b101;

// instructions

// opcode = op
// function 7 + function3
localparam [9:0]ADD = 10'b0000000000;
localparam [9:0]SUB = 10'b0100000000;
localparam [9:0]SLL = 10'b0000000001;
localparam [9:0]SLT = 10'b0000000010;
localparam [9:0]XOR = 10'b0000000100;
localparam [9:0]SRL = 10'b0000000101;
localparam [9:0]SRA = 10'b0100000101;
localparam [9:0]OR  = 10'b0000000110;
localparam [9:0]AND = 10'b0000000111;

// opcode = op_imm
// function 3
localparam [2:0]ADDI  = 3'b000;
localparam [2:0]SLTI  = 3'b010;
localparam [2:0]SLTIU = 3'b011; 
localparam [2:0]XORI  = 3'b100;
localparam [2:0]ORI	  = 3'b110;
localparam [2:0]ANDI  = 3'b111;
localparam [2:0]SLLI  = 3'b001;
localparam [2:0]SRLI  = 3'b101;		// SRLI and SRAI has the same value
localparam [2:0]SRAI  = 3'b101;		// need to check their imm[11:5] values

// opcode = branch
localparam [2:0]BEQ  = 3'b000;
localparam [2:0]BNE  = 3'b001;
localparam [2:0]BLT  = 3'b100;
localparam [2:0]BGE  = 3'b101;
localparam [2:0]BLTU = 3'b110;
localparam [2:0]BGEU = 3'b111;

// opcode = load
// function 3
localparam [2:0]LB  = 3'b000;
localparam [2:0]LH  = 3'b001;
localparam [2:0]LW  = 3'b010;
localparam [2:0]LBU = 3'b100;
localparam [2:0]LHU = 3'b101;

// opcode = store
// function 3
localparam [2:0]SB  = 3'b000;
localparam [2:0]SH  = 3'b001;
localparam [2:0]SW  = 3'b010;
localparam [2:0]SBU = 3'b100;
localparam [2:0]SHU = 3'b101;

// control signals for alu is defined here
// 4 operations : 1)op 2) op-imm 3) branch 4) load 5) store
//for op
localparam [3:0]ALU_ADD_I	= 4'b0000; // addi (op imm)
localparam [3:0]ALU_SUB_I	= 4'b0001;
localparam [3:0]ALU_AND_I	= 4'b0010;
localparam [3:0]ALU_OR_I	= 4'b0011;
localparam [3:0]ALU_XOR_I	= 4'b0100;
localparam [3:0]ALU_SLL_I	= 4'b0101; // shift left logical 
localparam [3:0]ALU_SRL_I	= 4'b0110;
localparam [3:0]ALU_SRA_I	= 4'b0111;

localparam [3:0]ALU_BEQ		= 4'b1000;	// branch operations
localparam [3:0]ALU_BNE		= 4'b1001;
localparam [3:0]ALU_BLT		= 4'b1010;
localparam [3:0]ALU_BGE		= 4'b1011;
localparam [3:0]ALU_BLT_U	= 4'b1100;
localparam [3:0]ALU_BGE_U	= 4'b1101;

localparam [3:0]ALU_SLT_I	= 4'b1110;	// set less than operations
localparam [3:0]ALU_SLT_I_U = 4'b1111;	

// alu immediate read signals
localparam [1:0]ALU_READ_RS2		= 2'b00;
localparam [1:0]ALU_READ_IMM		= 2'b01;
localparam [1:0]ALU_READ_IMM_U_J	= 2'b10;

// xfer_size
localparam [2:0]XFER_BYTE 	= 3'b000;
localparam [2:0]XFER_HALF	= 3'b001;
<<<<<<< HEAD
localparam [2:0]XFER_WORD	= 3'b010;
=======
localparam [2:0]XFER_WORD	= 3'b010;


>>>>>>> 87a68024dc4cc71812ce6563ccefe90a5c547843
