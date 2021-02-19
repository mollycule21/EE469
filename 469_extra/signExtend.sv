/*
Name: Veen Oung

Description: A program that sign-extends the input
             with a given size as the WIDTH parameter to
             an output of 64-bits.
*/
`timescale 1ps/1fs

module signExtend #(parameter WIDTH = 9) (in, out);
    output logic [63:0] out;
    input  logic [WIDTH-1:0] in;

    // the extended bits are inherited from the MSB of in
    assign out = {{(64-WIDTH){in[WIDTH-1]}}, in[WIDTH-1:0]};
endmodule

module signExtend_testbench();
    logic [8:0] in;
    logic [63:0] out;

    signExtend dut(.in, .out);

    initial begin
        in = 9'b100000001; #50;
        in = 9'b000000001; #50;
    end
endmodule