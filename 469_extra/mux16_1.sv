/*
Name: Veen Oung

Description: A 16:1 multiplexer that takes in
             16 inputs and produces 1 output based
             on the enable wires' values.
*/
`timescale 1ps/10fs

module mux16_1(out, in, sel);
    output logic out;
    input  logic [15:0] in;
    input  logic [3:0] sel;

    logic [3:0] temp;

    mux4_1 mux4_1_0 (.out(temp[0]), .in(in[3:0]), .sel(sel[1:0]));
    mux4_1 mux4_1_1 (.out(temp[1]), .in(in[7:4]), .sel(sel[1:0]));
    mux4_1 mux4_1_2 (.out(temp[2]), .in(in[11:8]), .sel(sel[1:0]));
    mux4_1 mux4_1_3 (.out(temp[3]), .in(in[15:12]), .sel(sel[1:0]));

    mux4_1 mux4_1_res (.out(out), .in(temp[3:0]), .sel(sel[3:2]));

endmodule

module mux16_1_testbench();
    logic [15:0] in;
    logic [3:0]  sel;
    logic out;

    mux16_1 dut (.out, .in, .sel);

    initial begin
        #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 0; sel[2] = 0; sel[3] = 0; #400;
        in = 16'b0000000000000001;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 0; sel[2] = 0; sel[3] = 0; #400;
        in = 16'b0000000000000010;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 1; sel[2] = 0; sel[3] = 0; #400;
        in = 16'b0000000000000100;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 1; sel[2] = 0; sel[3] = 0; #400;
        in = 16'b0000000000001000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 0; sel[2] = 1; sel[3] = 0; #400;
        in = 16'b0000000000010000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 0; sel[2] = 1; sel[3] = 0; #400;
        in = 16'b0000000000100000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 1; sel[2] = 1; sel[3] = 0; #400;
        in = 16'b0000000001000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 1; sel[2] = 1; sel[3] = 0; #400;
        in = 16'b0000000010000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 0; sel[2] = 0; sel[3] = 1; #400;
        in = 16'b0000000100000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 0; sel[2] = 0; sel[3] = 1; #400;
        in = 16'b0000001000000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 1; sel[2] = 0; sel[3] = 1; #400;
        in = 16'b0000010000000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 1; sel[2] = 0; sel[3] = 1; #400;
        in = 16'b0000100000000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 0; sel[2] = 1; sel[3] = 1; #400;
        in = 16'b0001000000000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 0; sel[2] = 1; sel[3] = 1; #400;
        in = 16'b0010000000000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 0; sel[1] = 1; sel[2] = 1; sel[3] = 1; #400;
        in = 16'b0100000000000000;                                                 #400;
        in = 16'b0000000000000000; sel[0] = 1; sel[1] = 1; sel[2] = 1; sel[3] = 1; #400;
        in = 16'b1000000000000000;                                                 #400;
    end
endmodule