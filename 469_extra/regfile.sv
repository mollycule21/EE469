/*
Name: Veen Oung

Description: The register file that consists of
             one 5:32 enabled decoder, two large
             32x64 to 64 multiplexors, and D flip-flops.

             @param:
             ReadData1:     Output of the first 32x64_64 mux.
             ReadData2:     Output of the second 32x64_64 mux.
             WriteData:     64-bit data ready to be written into
                            the registers.
             ReadRegister1: Selects the registers whose values
                            are output on the ReadData1 bus.
             ReadRegister2: Selects the registers whose values
                            are output on the ReadData2 bus.
             WriteRegister: Selects the target (register) of the write.
             RegWrite:      If true at the rising edge of clk,
                            write the bits on WriteData into the target
                            determined by WriteRegister.
             clk:           A clock for the system.

*/
`timescale 1ps/1fs

module regfile (ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk);
    output logic [63:0] ReadData1, ReadData2;
    input  logic [63:0] WriteData;
    input  logic [4:0]  ReadRegister1, ReadRegister2, WriteRegister;
    input  logic        RegWrite;
    input  logic        clk;

    logic [31:0] decoderOutput;
    logic [63:0][31:0] muxOutput;

    // set up the 5:32 decoder
    decoder5_32 decoder1 (.out(decoderOutput[31:0]), .in(WriteRegister[4:0]), .set(RegWrite));

    genvar i;

    // set up the 2 64x32:1 muxes
    generate
        for (i = 0; i < 64; i = i + 1) begin
            mux32_1 largeMux1 (.out(ReadData1[i]), .in(muxOutput[i][31:0]), .sel(ReadRegister1[4:0]));
            mux32_1 largeMux2 (.out(ReadData2[i]), .in(muxOutput[i][31:0]), .sel(ReadRegister2[4:0]));
        end
    endgenerate

    // initialize the registers with d flip-flops
    genvar j;

    generate
        for (i = 0; i < 31; i = i + 1) begin
            for (j = 0; j < 64; j = j + 1) begin
                D_FF_enable registers (.q(muxOutput[j][i]), .d(WriteData[j]), .en(decoderOutput[i]), .clk(clk));
            end
        end
    endgenerate

    // initialize register 31 with 0s
    genvar k;
    for (k = 0; k < 64; k = k + 1) begin
        assign muxOutput[k][31] = 0;
    end
endmodule