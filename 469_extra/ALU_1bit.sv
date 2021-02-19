/*
Name: Veen Oung

Description: A 1-bit ALU design that takes in two 1-bit
             inputs (A and B) and computes an output
             based on the control signals that determine
             which operation to perform.

    cntrl			Operation					
    000:			result = B
    010:			result = A + B
    011:			result = A - B
    100:			result = bitwise A & B
    101:			result = bitwise A | B
    110:			result = bitwise A XOR B
*/
`timescale 1ps/1fs

module ALU_1bit(A, B, Cin, Cout, cntrl, out);
    input  logic       A, B, Cin;
    input  logic [2:0] cntrl;
    output logic       Cout, out;

    logic [7:0] res;
    logic       invB, tempB, sum;

    // assign B - 000
    assign res[0] = B;

    // add/subtract - 010/011
    not #50 not1 (invB, B);
    mux2_1 addOrSubtract (.out(tempB), .i0(B), .i1(invB), .sel(cntrl[0]));

    adder addr1 (.A(A), .B(tempB), .Cin(Cin), .Cout(Cout), .Sum(sum));

    assign res[2] = sum;
    assign res[3] = sum;

    // AND operation - 100
    and #50 andOp (res[4], A, B);

    // OR operation - 101
    or #50 orOp (res[5], A, B);

    // XOR operation - 110
    xor #50 xorOp (res[6], A, B);

    // control logic decides the actual out
    mux8_1 pickOut (.out(out),
                    .in({1'b0, res[6:2], 1'b0, res[0]}),
                    .sel(cntrl));

endmodule

module ALU_1bit_testbench();
    logic A, B, Cin;
    logic [2:0] cntrl;
    logic Cout, out;

    parameter DELAY = 4000;

    ALU_1bit dut(.A, .B, .Cin, .Cout, .cntrl, .out);

    initial begin
        A = 0; B = 0; Cin = 0; cntrl = 3'b000; #DELAY;
                                               #DELAY;
                               cntrl = 3'b001; #DELAY;
                                               #DELAY;
                               cntrl = 3'b010; #DELAY;
                                               #DELAY;
                               cntrl = 3'b011; #DELAY;
                                               #DELAY;
                               cntrl = 3'b100; #DELAY;
                                               #DELAY;
                               cntrl = 3'b101; #DELAY;
                                               #DELAY;
                               cntrl = 3'b110; #DELAY;
                                               #DELAY;
                               cntrl = 3'b111; #DELAY;
                                               #DELAY;
        A = 0; B = 1; Cin = 0; cntrl = 3'b000; #DELAY;
                                               #DELAY;
                               cntrl = 3'b001; #DELAY;
                                               #DELAY;
                               cntrl = 3'b010; #DELAY;
                                               #DELAY;
                               cntrl = 3'b011; #DELAY;
                                               #DELAY;
                               cntrl = 3'b100; #DELAY;
                                               #DELAY;
                               cntrl = 3'b101; #DELAY;
                                               #DELAY;
                               cntrl = 3'b110; #DELAY;
                                               #DELAY;
                               cntrl = 3'b111; #DELAY;
                                               #DELAY;
        A = 1; B = 1; Cin = 0; cntrl = 3'b000; #DELAY;
                                               #DELAY;
                               cntrl = 3'b001; #DELAY;
                                               #DELAY;
                               cntrl = 3'b010; #DELAY;
                                               #DELAY;
                               cntrl = 3'b011; #DELAY;
                                               #DELAY;
                               cntrl = 3'b100; #DELAY;
                                               #DELAY;
                               cntrl = 3'b101; #DELAY;
                                               #DELAY;
                               cntrl = 3'b110; #DELAY;
                                               #DELAY;
                               cntrl = 3'b111; #DELAY;
                                               #DELAY;
        A = 1; B = 1; Cin = 1; cntrl = 3'b000; #DELAY;
                                               #DELAY;
                               cntrl = 3'b001; #DELAY;
                                               #DELAY;
                               cntrl = 3'b010; #DELAY;
                                               #DELAY;
                               cntrl = 3'b011; #DELAY;
                                               #DELAY;
                               cntrl = 3'b100; #DELAY;
                                               #DELAY;
                               cntrl = 3'b101; #DELAY;
                                               #DELAY;
                               cntrl = 3'b110; #DELAY;
                                               #DELAY;
                               cntrl = 3'b111; #DELAY;
    end
endmodule