/*
Name: Veen Oung

Description: A 32:1 multiplexer that takes in
             32 inputs and produces 1 output based
             on the enable wires' values.
*/
`timescale 1ps/10fs

module mux32_1(out, in, sel);
    output logic out;
    input  logic [31:0] in;
    input  logic [4:0] sel;

    logic [1:0] temp;

    mux16_1 mux16_1_0 (.out(temp[0]), .in(in[15:0]), .sel(sel[3:0]));
    mux16_1 mux16_1_1 (.out(temp[1]), .in(in[31:16]), .sel(sel[3:0]));
    mux2_1 mux2_1_0 (.out(out), .i0(temp[0]), .i1(temp[1]), .sel(sel[4]));

endmodule

module mux32_1_testbench();
    logic [31:0] in;
    logic [4:0] sel;
    logic out;

    mux32_1 dut (.out, .in, .sel);

    initial begin
        in = 32'b00000000000000000000000000000000;
        sel[0] = 0; sel[1] = 0; sel[2] = 0; sel[3] = 0; sel[4] = 0;
        #500;
        in = 32'b00000000000000000000000000000001;                                 
        #500;
        in = 32'b00000000000000000000000000000000;
        sel[0] = 0; sel[1] = 1; sel[2] = 0; sel[3] = 0; sel[4] = 0;
        #500;
        in = 16'b00000000000000000000000000000100;
        #500;
        in = 16'b00000000000000000000000000000000;
        sel[0] = 0; sel[1] = 1; sel[2] = 0; sel[3] = 1; sel[4] = 0;
        #500;
        in = 16'b00000000000000000000010000000000;
        #500;
    end
endmodule