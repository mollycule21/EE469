/*
Name: Veen Oung

Description: The program counter (PC) datapath that handles
             the logic of computing the next PC address to be
             loaded into the Instruction Memory to get the
             next instruction.
*/
`timescale 1ps/10fs

module pcDatapath(instruction, reset, clk, UncondBr, BrTaken);
    output logic [31:0] instruction;
    input  logic reset, clk, UncondBr, BrTaken;

    logic [63:0] currPC, nextPC, imm19_SE, imm26_SE, tempOut, shiftedOut,
                 bAdder, normalNextPC;

    /// Instruction Fetch ///
    // fetch instruction from current PC
    instructmem instrFetch(.address(currPC), .instruction(instruction), .clk(clk));

    /// Program Counter Logic ///
    // sign extend imm19 & imm26
    signExtend #(.WIDTH(19)) se_imm19(.in(instruction[23:5]), .out(imm19_SE));
    signExtend #(.WIDTH(26)) se_imm26(.in(instruction[25:0]), .out(imm26_SE));

    // mux for the UncondBr
    mux64x2_64 uncondBrCheck(.out(tempOut), .in0(imm19_SE), .in1(imm26_SE), .sel(UncondBr));

    // shift the output selected from imm19_SE or imm26_SE by 2
    assign shiftedOut = {tempOut[61:0], {2{1'b0}}};

    // add pc counter and the shifted result, PC = PC + shifted result
    pcAdder pcAdder1(.A(currPC), .B(shiftedOut), .sum(bAdder));

    // add pc counter and 4, PC = PC + 4
    pcAdder pcAdder2(.A(currPC), .B(64'd4), .sum(normalNextPC));

    // mux for the BrTaken
    mux64x2_64 brTakenCheck(.out(nextPC), .in0(normalNextPC), .in1(bAdder), .sel(BrTaken));

    // update PC to the next PC
    pc updatePC(.out(currPC), .in(nextPC), .reset(reset), .clk(clk));
endmodule

module pcDatapath_testbench();
    logic [31:0] instruction;
    logic reset, clk, UncondBr, BrTaken;

    pcDatapath dut(.instruction, .reset, .clk, .UncondBr, .BrTaken);

    parameter ClockDelay = 10000;
    initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

    always_comb begin
        if (instruction[31:26] == 6'b000101)
            begin
                UncondBr = 1;
                BrTaken = 1;
            end
        else
            begin
                UncondBr = 0;
                BrTaken = 0;
            end
        // unable to test for CBZ and B_LT because the data do not
        // get passed into this file.
    end

    integer i;
    initial begin
        reset = 1; @(posedge clk);
                   @(posedge clk);
        reset = 0; @(posedge clk);
                   @(posedge clk);
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
        end
        $stop;
    end
endmodule