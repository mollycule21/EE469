/*
Name: Molly Le & Feifan Quiao

Description: A 8:1 multiplexer that takes in
             8 inputs and produces 1 output based
             on the enable wires' value.
*/
`timescale 1ps/10fs

module mux_8_1(out, in, sel);
    output logic out;
    input logic [7:0] in;
    input logic [2:0] sel;

    logic temp_0, temp_1;

    mux_4_1 m0(.out(temp_0), .in(in[3:0]), .sel(sel[1:0]));
    mux_4_1 m1(.out(temp_1), .in(in[7:4]), .sel(sel[1:0]));
    mux_2_1 m_final (.out(out), .i0(temp_0), .i1(temp_1), .sel(sel[2]));
endmodule

// Correct-confirmed on modelsim 
module mux_8_1_testbench();
    logic [7:0] in;
    logic [2:0] sel;
    logic out;

    mux_8_1 dut (.out, .in, .sel);


    initial begin
		#200;
      sel =3'b000; in = 8'd0;			#200; // out = in[0] = 0 
		sel =3'b001; in = 8'd2;			#200; // out = in[1] = 1 
		sel =3'b010; in = 8'd0; 		#200; // out = in[2] = 0 
		sel =3'b011; in = 8'd8; 		#200; // out = in[3] = 1 
		sel =3'b100; in = 8'd0;			#200; // out = in[4] = 0 
		sel =3'b101; in = 8'd32;		#200; // out = in[5] = 1 
		sel =3'b110; in = 8'd0; 		#200; // out = in[6] = 0 
		sel =3'b111; in = 8'd128; 		#200; // out = in[7] = 1 
		
		
    end
endmodule
