/*
Name: Veen Oung

Description: A 8:1 multiplexer that takes in
             8 inputs and produces 1 output based
             on the enable wires' value.
*/
`timescale 1ps/10fs

module mux8_1(out, in, sel);
    output logic out;
    input logic [7:0] in;
    input logic [2:0] sel;

    logic v0, v1;

    mux4_1 m0(.out(v0), .in(in[3:0]), .sel(sel[1:0]));
    mux4_1 m1(.out(v1), .in(in[7:4]), .sel(sel[1:0]));
    mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel[2]));
endmodule

module mux8_1_testbench();
    logic [7:0] in;
    logic [2:0] sel;
    logic out;

    mux8_1 dut (.out, .in, .sel);

    integer i;
    initial begin
                                                                            #200;
        sel[0] = 0; sel[1] = 0; sel[2] = 0;
        in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 0;
        in[4] = 0; in[5] = 0; in[6] = 0; in[7] = 0;                         #200;
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
        sel[0] = 0; sel[1] = 0; sel[2] = 1;                                 #200;
                                            in[4] = 1;                      #200;
    end
endmodule