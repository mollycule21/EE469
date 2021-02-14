/*
Name: Molly Le & Feifan Quiao 

Description: An adder takes in three inputs (A, B, and Cin)
             and produces two outputs (Cout and Sum).
*/

`timescale 1ps/1fs

module full_adder(input logic A, B, Cin, 
					output logic Cout, Sum); 

    logic temp_sum;

    // logic for Sum = A XOR B XOR Cin
    xor #50 xor_1(temp_sum, A, B);
    xor #50 xor_2(Sum, temp_sum, Cin);

    // logic for Cout = A*B + (A + B)*Cin 
    and #50 and_1(temp_c_1, A, B);
    or  #50 or_1(temp_c_2, A, B);
    and #50 and_2(temp_c_3, temp_c_2, Cin);
    or  #50 or_2(Cout, temp_c_1, temp_c_3);

endmodule

// Correct -confirmed on modelsim 
module full_adder_testbench();
	logic A, B, Cin;
	logic Cout, Sum;

	full_adder dut(.A, .B, .Cin, .Cout, .Sum);
	
	initial begin
	
		A = 0; 	B = 0; Cin = 0; #200; // Sum  = 0,  Cout = 0 
					B = 0; Cin = 1; #200; // Sum  = 1,  Cout = 0 
					B = 1; Cin = 0; #200; // Sum  = 1,  Cout = 0 
					B = 1; Cin = 1; #200; // Sum  = 0,  Cout = 1 
		A = 1; 	B = 0; Cin = 0; #200; // Sum  = 1,  Cout = 0 
					B = 0; Cin = 1; #200; // Sum  = 0,  Cout = 1 
					B = 1; Cin = 0; #200; // Sum  = 0,  Cout = 1 
					B = 1; Cin = 1; #200; // Sum  = 1,  Cout = 1 
				

    end
endmodule
