/*
Molly Le & Feifan Quiao 
				A 1-bit ALU design that takes in two 1-bit
             inputs (A and B) and computes an output
             based on the control signals that determine
             which operation to perform.

    ctrl			Operation					
    000:			result = B
    010:			result = A + B
    011:			result = A - B
    100:			result = bitwise A & B
    101:			result = bitwise A | B
    110:			result = bitwise A XOR B
*/
`timescale 1ps/1fs

// bug in modelsim 
module alu_1_bit(input logic A, B, Cin, 
						input  logic [2:0] ctrl, 
						output logic Cout, out);
	
	// does all operations and saves each resulting value 
	logic [7:0] temp_op;
	 
   // load B: 000
	assign temp_op[0] = B;

   // add/sub: 010/011 - only ctrl[0] is diff 
	not #50 not_B (invB, B);
	
	// mux to determine: if ctrl[0] is 0 then add if 1 then sub
	// temp B: A + (-B) = A - B
   mux2_1 add_or_sub (.out(temp_B), .i0(B), .i1(invB), .sel(ctrl[0])); 
   
	// logic add_sum, sub_sum; 
	logic final_sum; 
	
	full_adder add (.A(A), .B(temp_B), .Cin(Cin), .Cout(Cout), .Sum(final_sum));
	// full_adder sub (.A(A), .B(invB), .Cin(Cin), .Cout(Cout), .Sum(sub_sum));
	
	// save value for add and sub 
	assign temp_op[2] = final_sum;
	assign temp_op[3] = final_sum;

    // AND operation - 100
    and #50 and_op (temp_op[4], A, B);

    // OR operation - 101
    or #50 or_op (temp_op[5], A, B);

    // XOR operation - 110
    xor #50 xor_op (temp_op[6], A, B);

    // control logic decides the actual out for the appropiate operation 
    mux_8_1 final_out (.out(out),
                    .in({1'b0, temp_op[6:2], 1'b0, temp_op[0]}),
                    .sel(ctrl));

endmodule

module alu_1_bit_testbench();
    logic A, B, Cin;
    logic [2:0] ctrl;
    logic Cout, out;

    parameter DELAY = 200;

    alu_1_bit dut(.A, .B, .Cin, .Cout, .ctrl, .out);

    initial begin
        A = 0; B = 0; Cin = 0; ctrl = 3'b000; #DELAY; // Cout = 0, out = B = 0
                               ctrl = 3'b001; #DELAY; 
                               ctrl = 3'b010; #DELAY; // out = A + B = 0  
                               ctrl = 3'b011; #DELAY; // out = A - B = 0
                               ctrl = 3'b100; #DELAY; // out = A & B = 0
                               ctrl = 3'b101; #DELAY; // out = A | B = 0 
                               ctrl = 3'b110; #DELAY; // out = A xor B = 0
                               ctrl = 3'b111; #DELAY;
										 ;
        A = 0; B = 1; Cin = 0; ctrl = 3'b000; #DELAY; // Cout = 0; 
		                         ctrl = 3'b001; #DELAY; 
                               ctrl = 3'b010; #DELAY; // out = A + B = 1  
                               ctrl = 3'b011; #DELAY; // out = A - B = -1 or 0 & Cout = 1 --> check w/ TA 
                               ctrl = 3'b100; #DELAY; // out = A & B = 0
                               ctrl = 3'b101; #DELAY; // out = A | B = 0 
                               ctrl = 3'b110; #DELAY; // out = A xor B = 0
                               ctrl = 3'b111; #DELAY;

        A = 1; B = 1; Cin = 0; ctrl = 3'b000; #DELAY;
		  		                   ctrl = 3'b001; #DELAY; 
                               ctrl = 3'b010; #DELAY; // out = A + B = 1  
                               ctrl = 3'b011; #DELAY; // out = A - B = Cout = 1 
                               ctrl = 3'b100; #DELAY; // out = A & B = 0
                               ctrl = 3'b101; #DELAY; // out = A | B = 0 
                               ctrl = 3'b110; #DELAY; // out = A xor B = 0
                               ctrl = 3'b111; #DELAY;


        A = 1; B = 1; Cin = 1; ctrl = 3'b000; #DELAY;
		  		                   ctrl = 3'b001; #DELAY; 
                               ctrl = 3'b010; #DELAY; // out = A + B = 1  
                               ctrl = 3'b011; #DELAY; // out = A - B = Cout = 1 
                               ctrl = 3'b100; #DELAY; // out = A & B = 0
                               ctrl = 3'b101; #DELAY; // out = A | B = 0 
                               ctrl = 3'b110; #DELAY; // out = A xor B = 0
                               ctrl = 3'b111; #DELAY;
    
    end
endmodule