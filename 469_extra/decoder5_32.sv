/*
Name: Veen Oung

Description: A 5:32 enabled-decoder that takes in
             5 inputs and produces 32 outputs based
             on the enable wire (set) value. The binary
             sequence of the inputs determines which output
             gets switched on.
*/
`timescale 1ps/10fs

module decoder5_32 (out, in, set);
    output logic [31:0] out;
    input  logic [4:0]  in;
    input  logic        set;

    logic [3:0] w;

    decoder2_4 dec2_4_1 (.out(w[3:0]), .in(in[4:3]), .set(set));
    decoder3_8 dec3_8_1 (.out(out[31:24]), .in(in[2:0]), .set(w[3]));
    decoder3_8 dec3_8_2 (.out(out[23:16]), .in(in[2:0]), .set(w[2]));
    decoder3_8 dec3_8_3 (.out(out[15:8]), .in(in[2:0]), .set(w[1]));
    decoder3_8 dec3_8_4 (.out(out[7:0]), .in(in[2:0]), .set(w[0]));

endmodule

module decoder5_32_testbench();
    logic [31:0] out;
    logic [4:0]  in;
    logic        set;

    decoder5_32 dut (.out, .in, .set);

    initial begin
        in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 0; in[4] = 0; set = 0; #150;
        in[0] = 1;                                                      #150;
        in[0] = 0;                                             set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
        in[0] = 0; in[1] = 0; in[2] = 1;                       set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
                                                               set = 0; #150;
        in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 1;            set = 0; #150;
        in[0] = 1;                                                      #150;
        in[0] = 0;                                             set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
        in[0] = 0; in[1] = 0; in[2] = 1;                       set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
        in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 0; in[4] = 1; set = 0; #150;
        in[0] = 1;                                                      #150;
        in[0] = 0;                                             set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
        in[0] = 0; in[1] = 0; in[2] = 1;                       set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
                                                               set = 0; #150;
        in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 1;            set = 0; #150;
        in[0] = 1;                                                      #150;
        in[0] = 0;                                             set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
        in[0] = 0; in[1] = 0; in[2] = 1;                       set = 1; #150;
        in[0] = 1;                                                      #150;
                   in[1] = 1;                                           #150;
        in[0] = 0;                                                      #150;
                                                               set = 0; #150;
    end
endmodule