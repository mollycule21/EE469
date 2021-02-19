///*
//
//Molly Le & Feifan Qiao 
//EE 469 Lab 1 
//
//This module impelements at 32 bit ALU Design. 
//Inputs: [2, 32 bit logics (A & B)] and control signal (ctrl) 
//Outputs: Computes appropaiate operation based on control signal
//Does zero detection, overflow detection, negative detection, and carryout detection.
//
//    ctrl			Operation					
//    000:			result = B
//    010:			result = A + B
//    011:			result = A - B
//    100:			result = bitwise A & B
//    101:			result = bitwise A | B
//    110:			result = bitwise A XOR B
//*/
//
//`timescale 1ps/1fs
//
//module alu (input logic [31:0] A, B;
//					input  logic [2:0]  ctrl;
//					output logic [31:0] result;
//					output logic zero, overflow, negative, carry_out;
//	
//	always_comb begin 
//		case (ctrl[2:0])
//			000: result = A; // nothing 
//			001: result = A & B; // and 
//			010: reult
//			
//	
//	end 
//    
//    // store the Cout value into carryout
//    ALU_1bit lastALU (.A(A[63]), .B(B[63]),
//                      .Cin(carryBit[62]), .Cout(carry_out),
//                      .cntrl(cntrl[2:0]), .out(result[63]));
//
//    // check overflow
//    xor #50 overflow1 (overflow, carryBit[62], carry_out);
//
//    // check negative
//    assign negative = result[63];
//
//    // check zero
//    nor64_1 isZero (.in(result[63:0]), .out(zero));
//
//endmodule
