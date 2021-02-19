/*
Name: Veen Oung

Description: A 64-bit ALU design that takes in two 64-bit
             inputs (A and B) and computes an output
             based on the control signals that determine
             which operation to perform. In addition, it
             provides zero detection, overflow detection,
             negative detection, and carryout detection.

    cntrl			Operation					
    000:			result = B
    010:			result = A + B
    011:			result = A - B
    100:			result = bitwise A & B
    101:			result = bitwise A | B
    110:			result = bitwise A XOR B
*/
`timescale 1ps/1fs

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
    input  logic [63:0] A, B;
    input  logic [2:0]  cntrl;
    output logic [63:0] result;
    output logic zero, overflow, negative, carry_out;

    logic [62:0] carryBit;

    // compute the ALU
    ALU_1bit firstALU (.A(A[0]), .B(B[0]),
                       .Cin(cntrl[0]), .Cout(carryBit[0]),
                       .cntrl(cntrl[2:0]), .out(result[0]));

    genvar i;

    generate
        for (i = 1; i < 63; i = i + 1) begin
            ALU_1bit midALU (.A(A[i]), .B(B[i]),
                             .Cin(carryBit[i - 1]), .Cout(carryBit[i]),
                             .cntrl(cntrl[2:0]), .out(result[i]));
        end
    endgenerate
    
    // store the Cout value into carryout
    ALU_1bit lastALU (.A(A[63]), .B(B[63]),
                      .Cin(carryBit[62]), .Cout(carry_out),
                      .cntrl(cntrl[2:0]), .out(result[63]));

    // check overflow
    xor #50 overflow1 (overflow, carryBit[62], carry_out);

    // check negative
    assign negative = result[63];

    // check zero
    nor64_1 isZero (.in(result[63:0]), .out(zero));

endmodule
