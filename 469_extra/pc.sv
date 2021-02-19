/*
Name: Veen Oung

Description: The program counter of the CPU
             triggered by posedge clk.
*/
module pc(out, in, reset, clk);
    output logic [63:0] out;
    input  logic [63:0] in;
    input  logic reset, clk;

    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1) begin
            D_FF nextPC(.q(out[i]), .d(in[i]), .reset(reset), .clk(clk));
        end
    endgenerate
endmodule

module pc_testbench();
    logic [63:0] out, in;
    logic reset, clk;

    pc dut(.out, .in, .reset, .clk);

    initial begin
        reset = 0; clk = 0; in = 64'h0000000000000000; #100;
                            in = 64'h0000000000000000; #100;
                            in = 64'h0000000000000000; #100;
                            in = 64'h0000000000000000; #100;
                   clk = 1; in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                   clk = 0; in = 64'h0000000000000000; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
        reset = 1; clk = 1; in = 64'h0000000000000000; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'h0000000000000000; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
                   clk = 0; in = 64'hFFFFFFFFFFFFFFFF; #100;
                            in = 64'hFFFFFFFFFFFFFFFF; #100;
    end
endmodule