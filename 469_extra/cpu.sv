/*
Name: Veen Oung

Description: A 64-bit ARM single-cycle CPU.
*/
`timescale 1ps/10fs

module cpu(clk, reset);
    input logic clk, reset;

    logic [31:0] instruction;
    logic negative, zero, zSet, overflow, carry_out;
    logic Reg2Loc,
          ALUSrc,
          MemToReg,
          RegWrite,
          MemWrite,
          BrTaken,
          UncondBr,
          read_en,
          movz,
          movk,
          setFlag,
          addi,
          isLDURB;
    logic [2:0] ALUOp;
    logic [3:0] xfer_size;

    pcDatapath pcLogic (.instruction, .reset, .clk, .UncondBr, .BrTaken);

    controlSignals cs(.instruction, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite,
                      .BrTaken, .UncondBr, .ALUOp, .read_en,
                      .movz, .movk, .setFlag, .addi, .isLDURB, .xfer_size,
                      .zero(zSet), .negative, .overflow);

    regAndMemDatapath regAndMem(.instruction, .negative, .zero, .zSet, .overflow, .carry_out,
                         .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite,
                         .MemWrite, .BrTaken, .UncondBr, .ALUOp,
                         .read_en, .movz, .movk, .setFlag,
                         .addi, .isLDURB, .xfer_size, .reset, .clk);
endmodule

module cpu_testbench();

    parameter ClockDelay = 10000;

    logic clk, reset;

    cpu dut(.clk, .reset);

    initial begin // Set up the clock
        clk <= 0;
        forever #(ClockDelay/2) clk <= ~clk;
    end

    integer i;
    initial begin
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk);
        for (i = 0; i < 1000; i = i + 1) begin
            @(posedge clk);
        end
        $stop;
    end
endmodule