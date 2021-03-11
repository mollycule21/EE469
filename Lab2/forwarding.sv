// 2 forwarding logics bc the there are 2 source regsiters from the instruction going into the register file 
// Forwarding happens from 3 stages:EX, MEM, WB
// Checked for forwarding at decoder stage 


module forwarding(forwardA, forwardB, EX_Reg_Write, MEM_Reg_Write, WB_Reg_Write,
                        EX_Rd, MEM_Rd, WB_Rd, rs1, rs2);
   
	output logic [1:0] forwardA, forwardB;
	input  logic EX_Reg_Write, MEM_Reg_Write, WB_Reg_Write;
	input  logic [4:0] EX_Rd, MEM_Rd, WB_Rd, rs1, rs2;
 
// foward data from execute, mem, and write back 
	always_comb begin
		  // forwardA logic 
		  if ((EX_Rd != 5'd0) && EX_Reg_Write && (EX_Rd == rs1)) begin // EX hazard 
            forwardA = 2'b01;
		  end else if ((MEM_Rd != 5'd0) && MEM_Reg_Write && (MEM_Rd == rs1)) begin // MEM hazard
            forwardA = 2'b10;
		  end else if ((WB_Rd != 5'd0) && WB_Reg_Write && (WB_Rd == rs1)) begin // WB hazard
				forwardA = 2'b11; 
		  end else begin 																			// no hazard, proceed with current cycle data
            forwardA = 2'b00;
		  end 
        // forwardB logic 
        if ((EX_Rd != 5'd0) && EX_Reg_Write && (EX_Rd == rs2)) begin  // EX hazard 
            forwardB = 2'b01;
		  end else if ((MEM_Rd != 5'd0) && MEM_Reg_Write && (MEM_Rd == rs2)) begin // MEM hazard
            forwardB = 2'b10;
		  end else if ((WB_Rd != 5'd0) && WB_Reg_Write && (WB_Rd == rs2)) begin // WB hazard 
				forwardB = 2'b11; 
		  end else begin // no hazard, proceed with current cycle data
            forwardB = 2'b00;
		  end 
    end 
endmodule

// Correct on Modelsim as of 3/10/21
module forwarding_tb(); 
	logic [1:0] forwardA, forwardB;
	logic EX_Reg_Write, MEM_Reg_Write, WB_Reg_Write;
	logic [4:0] EX_Rd, MEM_Rd, WB_Rd, rs1, rs2;
	
	forwarding dut (.forwardA, .forwardB, 
							.EX_Reg_Write, .MEM_Reg_Write, .WB_Reg_Write, .EX_Rd, .MEM_Rd, .WB_Rd, .rs1, .rs2);
	
	// Set DELAY 
	parameter DELAY = 50; 
	
	// Set inputs to test 
	initial begin 
		#DELAY; // forwardA & forwardB = 2'b00; 
		EX_Rd <= 5'd1; EX_Reg_Write <= 1'b1; rs1 <= 5'd1; rs2 <= 5'd1; 		#DELAY; // forwardA & forwardB = 2'b01
		EX_Rd <= 5'd0; 																		#DELAY; // forwardA & forwardB = 2'b00
		MEM_Rd <= 5'd1; MEM_Reg_Write <= 1'b1; rs1 <= 5'd1; rs2 <= 5'd1;		#DELAY; // forwardA & forwardB = 2'b10
		MEM_Rd <= 5'd0; 																		#DELAY; // forwardA & forwardB = 2'b00
		WB_Rd <= 5'd1; WB_Reg_Write <= 1'b1; rs1 <= 5'd1;	rs2 <= 5'd1;		#DELAY; // forwardA & forwardB = 2'b11
		WB_Rd <= 5'd0; 																		#DELAY; // forwardA & forwardB = 2'b00
	$stop; 
	end 
	
	
endmodule 


