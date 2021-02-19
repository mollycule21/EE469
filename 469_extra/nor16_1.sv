/*
Name: Veen Oung

Description: A 16-to-1 NOR gate which takes
             in 16 inputs to produce an output = 1
             when all inputs are 0, and output = 0
             otherwise.
*/
`timescale 1ps/1fs

module nor16_1(in, out);
    input  logic [15:0] in;
    output logic        out;

    logic [3:0] temp;

    nor #50 nor0(temp[0], in[0], in[1], in[2], in[3]);
    nor #50 nor1(temp[1], in[4], in[5], in[6], in[7]);
    nor #50 nor2(temp[2], in[8], in[9], in[10], in[11]);
    nor #50 nor3(temp[3], in[12], in[13], in[14], in[15]);

    and #50 and1(out, temp[0], temp[1], temp[2], temp[3]);
endmodule

module nor16_1_testbench();
    logic [15:0] in;
    logic out;

    nor16_1 dut(.in, .out);

    integer i;

    initial begin
        for (i=0; i<16; i++) begin
            in = i; #1000;
        end
    end
endmodule