/*
Name: Veen Oung

Description: The datapath for register file and data
             memory. Based on the instruction passed in
             as input, the control signals get configured
             to choose the correct CPU instruction execution
             between register file and data memory.
*/
`timescale 1ps/10fs

module regAndMemDatapath(instruction, negative, zero, zSet, overflow, carry_out,
                         Reg2Loc, ALUSrc, MemToReg, RegWrite,
                         MemWrite, BrTaken, UncondBr, ALUOp,
                         read_en, movz, movk, setFlag,
                         addi, isLDURB, xfer_size, reset, clk);
    // output required in control signal logic
    output logic negative, zero, zSet, overflow, carry_out;
    // control signals variables
    input  logic Reg2Loc,
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
    input  logic [2:0] ALUOp;
    input  logic [3:0] xfer_size;
    input  logic [31:0] instruction;
    input  logic reset, clk;

    logic [63:0] Aw, Da, Db; 
    logic [63:0] addiOut, imm12_64Bit, imm9_64Bit,
                 aluSrcOut, aluOpOut, memOut, ldurbOut,
                 WriteData, toALUSrc, movzOut; // muxes result
    logic [63:0] regShamt_0, regShamt_1, regShamt_2, regShamt_3,
                 regShamt_01, regShamt_23, regShamt_Final; // for movk
    logic [63:0] movzShift; // for movz
    logic [4:0] Ab;
    logic nSet, oSet, coSet;
    
    // the operands/destination names]
    logic [15:0] imm16;
    logic [4:0] Rd, Rn, Rm;
    logic [1:0] shamt;
    
    assign imm16 = instruction[20:5];
    assign Rd = instruction[4:0];
    assign Rn = instruction[9:5];
    assign Rm = instruction[20:16];
    assign shamt = instruction[22:21];
    
    // mux for Reg2Loc control signal (CS)
    mux5x2_5 reg2LocCheck(.out(Ab), .in0(Rd), .in1(Rm), .sel(Reg2Loc));

    // register file
    regfile rf1(.ReadData1(Da), .ReadData2(Db), .WriteData(WriteData), 
				    .ReadRegister1(Rn), .ReadRegister2(Ab), .WriteRegister(Rd),
				    .RegWrite(RegWrite), .clk(clk));
    
    // zero-extend imm12
    zeroExtend #(.WIDTH(12)) imm12_ZE(.in(instruction[21:10]), .out(imm12_64Bit));
    
    // sign-extend imm9
    signExtend #(.WIDTH(9)) imm9_SE(.in(instruction[20:12]), .out(imm9_64Bit));

    /// Setup for movk ///
    // Each regShamt corresponds to the positions in Db 
    // that the value imm16 is written into.
    assign regShamt_0 = {Db[63:16], imm16};
    assign regShamt_1 = {Db[63:32], imm16, Db[15:0]};
    assign regShamt_2 = {Db[63:48], imm16, Db[31:0]};
    assign regShamt_3 = {imm16, Db[47:0]};

    // mux regShamt_0 and regShamt_1
    mux64x2_64 regShamtMux_01(.out(regShamt_01), .in0(regShamt_0),
                                .in1(regShamt_1), .sel(shamt[0]));

    // mux regShamt_2 and regShamt_3
    mux64x2_64 regShamtMux_23(.out(regShamt_23), .in0(regShamt_2),
                                .in1(regShamt_3), .sel(shamt[0]));

    // select the regShamt based on Shamt value (instruction[22:21])
    mux64x2_64 regShamtMux_Final(.out(regShamt_Final), .in0(regShamt_01),
                                    .in1(regShamt_23), .sel(shamt[1]));

    /// Setup for movz ///
    // shift the value of imm16 by shamt << 4 (shamt * 16)
    // TODO: fix the shifting issue
    logic [63:0] movzShift0, movzShift1, movzShift2, movzShift3,
                 movzShift01, movzShift23;
    assign movzShift0 = {{48{1'b0}}, imm16};
    assign movzShift1 = {{32{1'b0}}, imm16, {16{1'b0}}};
    assign movzShift2 = {{16{1'b0}}, imm16, {32{1'b0}}};
    assign movzShift3 = {imm16, {48{1'b0}}};

    mux64x2_64 movzShamtMux_01(.out(movzShift01), .in0(movzShift0), .in1(movzShift1), .sel(shamt[0]));

    mux64x2_64 movzShamtMux_23(.out(movzShift23), .in0(movzShift2), .in1(movzShift3), .sel(shamt[0]));

    mux64x2_64 movzShamtMux_Final(.out(movzShift), .in0(movzShift01), .in1(movzShift23), .sel(shamt[1]));

    // mux for addi CS
    mux64x2_64 addiCheck(.out(addiOut), .in0(imm9_64Bit), .in1(imm12_64Bit), .sel(addi));
    
    // mux for movz CS
    mux64x2_64 movzCheck(.out(movzOut), .in0(addiOut), .in1(movzShift), .sel(movz));

    // mux for movk CS
    mux64x2_64 movkCheck(.out(toALUSrc), .in0(movzOut), .in1(regShamt_Final), .sel(movk));

    // mux for ALUSrc CS
    mux64x2_64 aluSrcCheck(.out(aluSrcOut), .in0(Db), .in1(toALUSrc), .sel(ALUSrc));

    // alu operation
    alu aluOpCheck(.A(Da), .B(aluSrcOut), .cntrl(ALUOp), .result(aluOpOut),
                    .negative(nSet), .zero(zSet), .overflow(oSet), .carry_out(coSet));

    // when setFlag is triggered, store the value of
    // negative, zero, overflow, and carry_out to be used by control signals logic
    D_FF_enable zeroFlag(.q(zero), .d(zSet), .en(setFlag), .clk(clk));
    D_FF_enable negativeFlag(.q(negative), .d(nSet), .en(setFlag), .clk(clk));
    D_FF_enable overflowFlag(.q(overflow), .d(oSet), .en(setFlag), .clk(clk));
    D_FF_enable carry_outFlag(.q(carry_out), .d(coSet), .en(setFlag), .clk(clk));
    
    // data memory - xfer_size already handles STUR and STURB situations
    datamem dm1(.address(aluOpOut), .write_enable(MemWrite), .read_enable(read_en),
                .write_data(Db), .clk(clk), .xfer_size(xfer_size), .read_data(memOut));
    
    // mux for isLDURB CS
    mux64x2_64 isLDURBCheck(.out(ldurbOut), .in0(memOut),
                            .in1({56'b0, memOut[7:0]}), .sel(isLDURB));

    // mux for MemToReg CS
    mux64x2_64 memToRegCheck(.out(WriteData), .in0(aluOpOut), .in1(ldurbOut), .sel(MemToReg));
endmodule