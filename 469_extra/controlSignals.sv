module controlSignals(instruction, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,
                      BrTaken, UncondBr, ALUOp, read_en,
                      movz, movk, setFlag, addi, isLDURB, xfer_size,
                      zero, negative, overflow);
    input  logic [31:0] instruction;
    input  logic zero, negative, overflow;
    output logic Reg2Loc,
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
    output logic [2:0] ALUOp;
    output logic [3:0] xfer_size;

    parameter [10:0] ADDI  = 11'b1001000100x,
                     ADDS  = 11'b10101011000,
                     B     = 11'b000101xxxxx,
                     B_LT  = 11'b01010100xxx,
                     CBZ   = 11'b10110100xxx,
                     LDUR  = 11'b11111000010,
                     LDURB = 11'b00111000010,
                     MOVK  = 11'b111100101xx,
                     MOVZ  = 11'b110100101xx,
                     STUR  = 11'b11111000000,
                     STURB = 11'b00111000000,
                     SUBS  = 11'b11101011000;

    always_comb begin
        casex(instruction[31:21])
            ADDI:
                begin
                    Reg2Loc  = 1'bx;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'b0;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b010;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b1;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            ADDS:
                begin
                    Reg2Loc  = 1'b1;
                    ALUSrc   = 1'b0;
                    MemToReg = 1'b0;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b010;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b1;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            B:
                begin
                    Reg2Loc  = 1'bx;
                    ALUSrc   = 1'bx;
                    MemToReg = 1'bx;
                    RegWrite = 1'b0;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b1;
                    UncondBr = 1'b1;
                    ALUOp    = 3'bxxx;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            B_LT:
                begin
                    Reg2Loc  = 1'bx;
                    ALUSrc   = 1'bx;
                    MemToReg = 1'bx;
                    RegWrite = 1'b0;
                    MemWrite = 1'b0;
                    BrTaken  = negative ^ overflow;
                    UncondBr = 1'b0;
                    ALUOp    = 3'bxxx;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            CBZ:
                begin
                    Reg2Loc  = 1'b0;
                    ALUSrc   = 1'b0;
                    MemToReg = 1'bx;
                    RegWrite = 1'b0;
                    MemWrite = 1'b0;
                    BrTaken  = zero;
                    UncondBr = 1'b0;
                    ALUOp    = 3'b000;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            LDUR:
                begin
                    Reg2Loc  = 1'bx;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'b1;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b010;
                    read_en  = 1'b1;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'b1000;
                end

            LDURB:
                begin
                    Reg2Loc  = 1'bx;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'b1;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b010;
                    read_en  = 1'b1;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b1;
                    xfer_size = 4'b0001;
                end

            MOVK:
                begin
                    Reg2Loc  = 1'b0;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'b0;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b000;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b1;
                    setFlag  = 1'b0;
                    addi     = 1'bx;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            MOVZ:
                begin
                    Reg2Loc  = 1'b0;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'b0;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b000;
                    read_en  = 1'b0;
                    movz     = 1'b1;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'bx;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            STUR:
                begin
                    Reg2Loc  = 1'b0;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'bx;
                    RegWrite = 1'b0;
                    MemWrite = 1'b1;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b010;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'b1000;
                end

            STURB:
                begin
                    Reg2Loc  = 1'b0;
                    ALUSrc   = 1'b1;
                    MemToReg = 1'bx;
                    RegWrite = 1'b0;
                    MemWrite = 1'b1;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b010;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'b0;
                    isLDURB  = 1'b0;
                    xfer_size = 4'b0001;
                end

            SUBS:
                begin
                    Reg2Loc  = 1'b1;
                    ALUSrc   = 1'b0;
                    MemToReg = 1'b0;
                    RegWrite = 1'b1;
                    MemWrite = 1'b0;
                    BrTaken  = 1'b0;
                    UncondBr = 1'bx;
                    ALUOp    = 3'b011;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b1;
                    addi     = 1'bx;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end

            default:
                begin
                    Reg2Loc  = 1'bx;
                    ALUSrc   = 1'bx;
                    MemToReg = 1'bx;
                    RegWrite = 1'b0;
                    MemWrite = 1'b0;
                    BrTaken  = 1'bx;
                    UncondBr = 1'bx;
                    ALUOp    = 3'bxxx;
                    read_en  = 1'b0;
                    movz     = 1'b0;
                    movk     = 1'b0;
                    setFlag  = 1'b0;
                    addi     = 1'bx;
                    isLDURB  = 1'b0;
                    xfer_size = 4'bxxxx;
                end
        endcase
    end
endmodule

module controlSignals_testbench();
    logic [31:0] instruction;
    logic zero, negative, overflow;
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

    parameter [10:0] ADDI  = 11'b1001000100x,
                     ADDS  = 11'b10101011000,
                     B     = 11'b000101xxxxx,
                     B_LT  = 11'b01010100xxx,
                     CBZ   = 11'b10110100xxx,
                     LDUR  = 11'b11111000010,
                     LDURB = 11'b00111000010,
                     MOVK  = 11'b111100101xx,
                     MOVZ  = 11'b110100101xx,
                     STUR  = 11'b11111000000,
                     STURB = 11'b00111000000,
                     SUBS  = 11'b11001011000;

    controlSignals dut(.instruction, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite,
                      .BrTaken, .UncondBr, .ALUOp, .read_en,
                      .movz, .movk, .setFlag, .addi, .isLDURB, .xfer_size,
                      .zero, .negative, .overflow);

    initial begin
        zero = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        instruction[31:21] = ADDI;  #500;
        instruction[31:21] = ADDS;  #500;
        instruction[31:21] = B;     #500;
        instruction[31:21] = B_LT;  #500;
        instruction[31:21] = CBZ;   #500;
        instruction[31:21] = LDUR;  #500;
        instruction[31:21] = LDURB; #500;
        instruction[31:21] = STUR;  #500;
        instruction[31:21] = STURB; #500;
    end
endmodule