/*
Name: Veen Oung

Description: A 2:1 multiplexer that takes in
             2 inputs and produces 1 output based
             on the enable wire's value.
*/
`timescale 1ps/10fs

module mux2_1(out, i0, i1, sel);
    output logic out;
    input logic i0, i1, sel;

    logic temp;
    logic [1:0] w;

    not #50 not1 (temp, sel);
    and #50 and1 (w[0], i0, temp);
    and #50 and2 (w[1], i1, sel);
    or  #50 or1 (out, w[0], w[1]);

endmodule

module mux2_1_testbench();
    logic i0, i1, sel;
    logic out;

    mux2_1 dut (.out, .i0, .i1, .sel);

    initial begin
        sel=0; i0=0; i1=0; #50;
        sel=0; i0=0; i1=1; #50;
        sel=0; i0=1; i1=0; #50;
        sel=0; i0=1; i1=1; #50;
        sel=1; i0=0; i1=0; #50;
        sel=1; i0=0; i1=1; #50;
        sel=1; i0=1; i1=0; #50;
        sel=1; i0=1; i1=1; #50;
    end
endmodule 