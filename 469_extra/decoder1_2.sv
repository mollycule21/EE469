/*
Name: Veen Oung

Description: A 1:2 enabled-decoder that takes in
             1 input and produces 2 outputs based
             on the enable wire (set) value.
*/
`timescale 1ps/1fs

module decoder1_2 (out, in, set);
    output logic [1:0] out;
    input  logic       in, set;

    logic temp;

    not #50 not1 (temp, in);
    and #50 and1 (out[0], temp, set);
    and #50 and2 (out[1], in, set);
endmodule

module decoder1_2_testbench();
    logic [1:0] out;
    logic       in, set;

    decoder1_2 dut (.out, .in, .set);

    initial begin
        in=0; set=0; #150;
        in=0; set=1; #150;
        in=1; set=0; #150;
        in=1; set=1; #150;
    end
endmodule

