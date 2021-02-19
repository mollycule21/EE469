/*
Name: Veen Oung

Description: An adder takes in three inputs (A, B, and Cin)
             and produces two outputs (Cout and Sum).
*/
`timescale 1ps/1fs

module pcAdder(A, B, sum);
    input  logic [63:0] A, B;
    output logic [63:0] sum;

    logic [63:0] temp;

    adder firstBit(.A(A[0]), .B(B[0]), .Cin(1'b0), .Cout(temp[0]), .Sum(sum[0]));
    
    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) begin
            adder remainingBits(.A(A[i]), .B(B[i]), .Cin(temp[i-1]),
                                .Cout(temp[i]), .Sum(sum[i]));
        end
    endgenerate
endmodule

module pcAdder_testbench();
    logic [63:0] A, B, sum;

    pcAdder dut(.A, .B, .sum);

    initial begin
        A = 64'h0000000000000000; B = 64'h1111111111111111; #500;
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; #500;
    end
endmodule