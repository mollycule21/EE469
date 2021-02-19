/*
Name: Veen Oung

Description: A 5x2:5 multiplexer that takes in
             two 5-bit inputs and select the input as output
             based on the enable value.
*/
`timescale 1ps/10fs

module mux5x2_5(out, in0, in1, sel);
    output logic [4:0] out;
    input  logic [4:0] in0, in1;
    input  logic sel;

    genvar i;

    generate
        for (i = 0; i < 5; i = i + 1) begin
            mux2_1 pickInput(.out(out[i]), .i0(in0[i]), .i1(in1[i]), .sel(sel));
        end
    endgenerate
endmodule

module mux5x2_5_testbench();
    logic [4:0] in0, in1, out;
    logic sel;

    mux5x2_5 dut (.out, .in0, .in1, .sel);

    initial begin
                                                 #500;
        in0 = 5'b00000; in1 = 5'b11111; sel = 0; #500;
                                        sel = 1; #500;
    end
endmodule