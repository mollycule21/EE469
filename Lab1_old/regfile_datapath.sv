// inputs funct_7_3 from control signal 
// output mem_write ->  data passed into data_mem.sv gets written to address 
// output reg_write ->  data passed into register gets written to destination register 
// output mem_read -> data_memory -> reads data at adressed passed into data_mem.sv 

module regfile_datapath (input logic [9:0] funct_7_3
											output logic mem_write, reg_write, mem_to_reg,
											output logic [2:0] alu_signal);
	
// determine which instructions to implement base on opcode 
 	
	always_comb begin
 		case(opcode)
		
 		op: mem_write = 1'b0; reg_write = 1'b1;
	
			if (funct7_3 == ADD) begin
 				alu_signal = ALU_ADD;
				
 			end else if (funct7_3 == SUB) begin
 				alu_signal = ALU_SUB;

 			end else if (funct7_3 == SLL) begin
 				alu_signal = ALU_SL;

 			end else if (funct7_3 == SLT) begin
 				// need work here
 				alu_signal = ;

 			end else if (funct7_3 == SLTU) begin
 				// need work here
 			end else if (funct7_3 == XOR) begin
 				alu_signal = ALU_XOR;

 			end else if (funct7_3 == SRL) begin
 				alu_signal = ALU_SRL;

 			end else if (funct7_3 == SRA) begin
 				alu_signal = ALU_SRA;

 			end else if (funct7_3 == OR) begin
 				alu_signal = ALU_OR;

 			end else begin 		// AND CASE
 				alu_signal = ALU_AND;

 			end
			
 		op-imm: mem_write = 1'b0; reg_write = 1'b1;

			if (funct7_3 == ADDI) begin
 				alu_signal = ALU_ADD;

 			end else if (funct7_3 == SLLI) begin
 				alu_signal = ALU_SL;

 			end else if (funct7_3 == SLT) begin
 				// need work here
 				alu_signal = ;

 			end else if (funct7_3 == SLTU) begin
 				// need work here
 			end else if (funct7_3 == XOR) begin
 				alu_signal = ALU_XOR;

 			end else if (funct7_3 == SRL) begin
 				alu_signal = ALU_SRL;

 			end else if (funct7_3 == SRA) begin
 				alu_signal = ALU_SRA;

 			end else if (funct7_3 == OR) begin
 				alu_signal = ALU_OR;

 			end else begin 		// AND CASE
 				alu_signal = ALU_AND;

 			end

 		endcase
 	end