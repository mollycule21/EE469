/*
Name: Veen Oung

Description: A 4:1 multiplexer that takes in
             4 inputs and produces 1 output based
             on the enable wires' value.
*/
`timescale 1ps/10fs

module mux4_1(out, in, sel);
    output logic out;
    input logic [3:0] in;
    input logic [1:0] sel;

    logic v0, v1;

    mux2_1 m0(.out(v0), .i0(in[0]), .i1(in[1]), .sel(sel[0]));
    mux2_1 m1(.out(v1), .i0(in[2]), .i1(in[3]), .sel(sel[0]));
    mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel[1]));
endmodule

module mux4_1_testbench();
    logic [3:0] in;
    logic [1:0] sel;
    logic out;

    mux4_1 dut (.out, .in, .sel);

    integer i;
    initial begin
        #200;
        sel[0] = 0; sel[1] = 0; in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 0; #200;
                                                                            #200;
                                in[0] = 1;                                  #200;
                                                                            #200;
        sel[0] = 1;                                                         #200;
                                                                            #200;
                                           in[1] = 1;                       #200;
                                                                            #200;
        sel[0] = 0; sel[1] = 1;                                             #200;
                                                                            #200;
                                                      in[2] = 1;            #200;
                                                                            #200;
        sel[0] = 1; sel[1] = 1;                                             #200;
                                                                            #200;
                                                                 in[3] = 1; #200;
                                                                            #200;
    end
endmodule