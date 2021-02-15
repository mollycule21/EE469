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
localparam [2:0]SWB = 3'b100;
localparam [2:0]SHU = 3'b101;

