/*
Name: Veen Oung

Description: A 2:4 enabled-decoder that takes in
             2 inputs and produces 4 outputs based
             on the enable wire (set) value. Outputs
             are generated as follow:
             2'b00 = 4'b0001
             2'b01 = 4'b0010
             2'b10 = 4'b0100
             2'b11 = 4'b1000
*/
`timescale 1ps/10fs

module decoder2_4 (out, in, set);
    output logic [3:0] out;
    input  logic [1:0] in;
    input  logic       set;

    logic [1:0] w;
    not #50 not1 (w[0], in[0]);
    not #50 not2 (w[1], in[1]);
    and #50 and1 (out[0], w[0], w[1], set);
    and #50 and2 (out[1], in[0], w[1], set);
    and #50 and3 (out[2], w[0], in[1], set);
    and #50 and4 (out[3], in[0], in[1], set);
    
endmodule


module decoder2_4_testbench();
    logic [3:0] out;
    logic [1:0] in;
    logic       set;

    decoder2_4 dut (.out, .in, .set);

    initial begin
        in[0] = 0; in[1] = 0; set = 0; #150;
        in[0] = 1;                     #150;
                   in[1] = 1;          #150;
        in[0] = 0;                     #150;
        in[0] = 0; in[1] = 0; set = 1; #150;
        in[0] = 1;                     #150;
                   in[1] = 1;          #150;
        in[0] = 0;                     #150;
                              set = 0; #150;
    end
endmodule