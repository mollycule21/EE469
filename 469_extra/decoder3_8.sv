/*
Name: Veen Oung

Description: A 3:8 enabled-decoder that takes in
             3 inputs and produces 8 outputs based
             on the enable wire (set) value. Outputs
             are generated as follow:
             3'b000 = 8'b00000001
             3'b001 = 8'b00000010
             3'b010 = 8'b00000100
             3'b011 = 8'b00001000
             3'b100 = 8'b00010000
             3'b101 = 8'b00100000
             3'b110 = 8'b01000000
             3'b111 = 8'b10000000
*/
`timescale 1ps/10fs

module decoder3_8 (out, in, set);
    output logic [7:0] out;
    input  logic [2:0] in;
    input  logic       set;

    logic [1:0] temp;
    decoder1_2 dec1_2 (.out(temp[1:0]), .in(in[2]), .set(set));
    decoder2_4 dec2_4_1(.out(out[3:0]), .in(in[1:0]), .set(temp[0]));
    decoder2_4 dec2_4_2(.out(out[7:4]), .in(in[1:0]), .set(temp[1]));
    
endmodule


module decoder3_8_testbench();
    logic [7:0] out;
    logic [2:0] in;
    logic       set;

    decoder3_8 dut (.out, .in, .set);

    initial begin
        in[0] = 0; in[1] = 0; in[2] = 0; set = 0; #150;
        in[0] = 1;                                #150;
        in[0] = 0;                       set = 1; #150;
        in[0] = 1;                                #150;
                   in[1] = 1;                     #150;
        in[0] = 0;                                #150;
        in[0] = 0; in[1] = 0; in[2] = 1; set = 1; #150;
        in[0] = 1;                                #150;
                   in[1] = 1;                     #150;
        in[0] = 0;                                #150;
                                         set = 0; #150;
    end
endmodule