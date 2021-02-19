/*
Name: Veen Oung

Description: A 64-to-1 NOR gate which takes
             in 64 inputs to produce an output = 1
             when all inputs are 0, and output = 0
             otherwise.
*/
`timescale 1ps/1fs

module nor64_1(in, out);
    input  logic [63:0] in;
    output logic        out;

    logic [3:0] temp;

    nor16_1 nor1(.in(in[15:0]), .out(temp[0]));
    nor16_1 nor2(.in(in[31:16]), .out(temp[1]));
    nor16_1 nor3(.in(in[47:32]), .out(temp[2]));
    nor16_1 nor4(.in(in[63:48]), .out(temp[3]));

    and #50 and1(out, temp[0], temp[1], temp[2], temp[3]);
endmodule

module nor64_1_testbench();
    logic [63:0] in;
    logic out;

    nor64_1 dut(.in, .out);

    integer i;

    initial begin
        for (i=0; i<100; i++) begin
            in = i; #1000;
        end
    end
endmodule