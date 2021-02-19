/*
Name: Veen Oung

Description: An adder takes in three inputs (A, B, and Cin)
             and produces two outputs (Cout and Sum).
*/
`timescale 1ps/1fs

module adder(A, B, Cin, Cout, Sum);
    input logic A, B, Cin;
    output logic Cout, Sum;

    logic tempC1, tempC2, tempC3, tempS;

    // logic for Cout = A*B + A*Cin + B*Cin
    and #50 and1(tempC1, A, B);
    or  #50 or1(tempC2, A, B);
    and #50 and2(tempC3, tempC2, Cin);
    or  #50 or2(Cout, tempC1, tempC3);

    // logic for Sum = A XOR B XOR Cin
    xor #50 xor1(tempS, A, B);
    xor #50 xor2(Sum, tempS, Cin);

endmodule

module adder_testbench();
    logic A, B, Cin;
    logic Cout, Sum;

    adder dut(.A, .B, .Cin, .Cout, .Sum);

    initial begin
        A = 0; B = 0; Cin = 0; #150;
        A = 1;                 #150;
                      Cin = 1; #150;
               B = 1;          #150;
    end
endmodule