/*
Name: Molly Le & Feifan Quiao 

Description: A 2:1 multiplexer that takes in
             2 inputs and produces 1 output based
             on the enable wire's value.
*/
`timescale 1ps/10fs

module mux_2_1(output logic out, input logic i0, i1, sel);
	
	assign out = (sel) ? i1 : i0; 

endmodule

module mux_2_1_testbench();
    logic i0, i1, sel;
    logic out;

    mux_2_1 dut (.out, .i0, .i1, .sel);

    initial begin
        sel=0; i0=0; i1=0; #50; // out = i0  
        sel=0; i0=0; i1=1; #50;
        sel=0; i0=1; i1=0; #50;
        sel=0; i0=1; i1=1; #50;
        sel=1; i0=0; i1=0; #50; // out = i1
        sel=1; i0=0; i1=1; #50;
        sel=1; i0=1; i1=0; #50;
        sel=1; i0=1; i1=1; #50;
    end
endmodule 