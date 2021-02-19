/*
Name: Veen Oung

Description: A 64x2:64 multiplexer that takes in
             two 64-bit inputs and select one input as
             output based on the enable value.
*/
`timescale 1ps/10fs

module mux64x2_64(out, in0, in1, sel);
    output logic [63:0] out;
    input  logic [63:0] in0, in1;
    input  logic sel;

    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1) begin
            mux2_1 pickInput(.out(out[i]), .i0(in0[i]), .i1(in1[i]), .sel(sel));
        end
    endgenerate

endmodule

module mux64x2_64_testbench();
    logic [63:0] in0, in1, out;
    logic sel;

    mux64x2_64 dut (.out, .in0, .in1, .sel);

    initial begin
                                                                         #500;
        in0 = 64'h0000000000000000; in1 = 64'hFFFFFFFFFFFFFFFF; sel = 0; #500;
                                                                sel = 1; #500;
    end
endmodule