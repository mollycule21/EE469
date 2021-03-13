// TODO:
// 1) Memory to memorey hazard for 1) load instruction then  2) store instruction 
/* 2) Hazard of ex_instruction being load instruction & EX_rd = id_rs1/rs2,
    make sure id_instruction isn't sw, branch, jump, & other instructions with storage --> 
    feed flag to  prevent pc and if_id registers from changing 
    3) figure out conditions for branch, jump, and anything else not accounted for in 2 
    */

`define WORD_SIZE       32

// load use hazard detection unit
module hazard_detection_unit(clk, EX_instruction, ID_instruction,
                               EX_rd, ID_rd, ID_rs1, ID_rs2,
                               stall);
    `include "constants.svh"

    input logic clk;
    input logic [`WORD_SIZE - 1:0] EX_instruction;      // instruction from EX stage
    input logic [`WORD_SIZE - 1:0] ID_instruction;      // instruction from ID stage
    input logic [4:0] EX_rd;
    input logic [4:0] ID_rd, ID_rs1, ID_rs2;
    output logic stall; 

    // check if EX instruction is a load instruction
    logic isLoad; 
    always_comb begin
        if (EX_instruction[6:0] == load) begin
            isLoad = 1'b1;
        end else begin
            isLoad = 1'b0;
        end
    end
//    logic need_store; 
//    always_comb begin 
//        if (ID_instruction == add && ID_instruction == sub ) begin  // find all instructions that implments storing out value to register be
//            need_store = 1'b1; 
//        end else begin 
//            need_store = 1'b0;
//        end 
//    end 

    // hazard detection
    always_comb begin
       if(isLoad && ((EX_rd == ID_rs1) || (EX_rd == ID_rs2) || (EX_rd == ID_rd))) begin
           stall = 1'b1; // input into if_id and make sure that instruction and pc(address) from fetch are repeated 
       end else begin 
           stall = 1'b0;
        end 
    end

endmodule