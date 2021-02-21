/*
Name: Molly Le and Fefian Qiao 

Description: A 4:1 multiplexer that takes in
             4 inputs and produces 1 output based
             on the enable wires' value.
*/

`timescale 1ps/10fs

module mux_4_1(out, in, sel);
    output logic out;
    input logic [3:0] in;
    input logic [1:0] sel;

    logic temp_0, temp_1;
	 
	// implements 3, 2_1 mux to create a 4_1 mux 
    mux_2_1 m_0 (.out(temp_0), .i0(in[0]), .i1(in[1]), .sel(sel[0]));
    mux_2_1 m_1 (.out(temp_1), .i0(in[2]), .i1(in[3]), .sel(sel[0]));
    mux_2_1 m_f (.out(out), .i0(temp_0), .i1(temp_1), .sel(sel[1]));
endmodule

module mux_4_1_testbench();
    logic [3:0] in;
    logic [1:0] sel;
    logic out;

    mux_4_1 dut (.out, .in, .sel);

    integer i;
    initial begin
        #200;
        sel =2'b00; in = 4'd0;		#200; // out = in[0] = 0 
		  sel =2'b01; in = 4'b0010;	#200; // out = in[1] = 1 
		  sel =2'b10; in = 4'd0; 		#200; // out = in[2] = 0 
		  sel =2'b11; in = 4'b1000; 	#200; // out = in[3] = 1 
		  
    end
endmodule