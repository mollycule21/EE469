// module test_tb(); 
// 	`include "constants.svh"

// 	logic clk, reset;  
//     // logic [31:0] EX_out_1, EX_out_2; 
//     logic do_WB;
//     logic [31:0] WB_data; 
//     logic [31:0] ex_alu_output, data_mem_output_final, wb_data_out; 

//     // testing fetch and decode 
//     // top dut (.reset(reset), .clk(clk), .do_WB(do_WB), .WB_data(WB_data), .EX_out_1(EX_out_1), .EX_out_2(EX_out_2)); 

//     // testing up to after alu

//     top dut (.reset(reset), .clk(clk), .do_WB(do_WB), .WB_data(WB_data), 
//                     .ex_alu_output(ex_alu_output), .data_mem_output_final(data_mem_output_final), .wb_data_out(wb_data_out));

//     parameter CLOCK_PERIOD = 50;
//     initial begin
//         clk <= 0;
//         forever #(CLOCK_PERIOD/2) clk <= ~clk;
//     end
    
//     initial begin
//         // reset is binded to KEY[3]
//         reset  <= 1'b1;    @(posedge clk);
//         reset  <= 1'b0;    @(posedge clk);
//                            @(posedge clk);

//         do_WB <= 1'b0; 
//         WB_data <= 32'd20; 
//         // EX_out_1 <= 32'd11; 
//         // EX_out_2 <= 32'd12;
//         ex_alu_output <= 32'd11; 
//         data_mem_output_final <= 32'd12; 
//         wb_data_out <= 32'd13; 
//                             @(posedge clk);
//                             repeat (5) @(posedge clk);
//         $stop;
//     end
// endmodule

// testing up to  alu_output - waveform saved as test2
// module test_tb(); 
// 	`include "constants.svh"

// 	logic clk, reset;  
//     // logic [31:0] EX_out_1, EX_out_2; 
//     logic do_WB;
//     logic [31:0] WB_data; 
//     logic [31:0] data_mem_output_final, wb_data_out; 

//     // testing up to after alu

//     top dut (.reset(reset), .clk(clk), .do_WB(do_WB), .WB_data(WB_data), 
//                    .data_mem_output_final(data_mem_output_final), .wb_data_out(wb_data_out));

//     parameter CLOCK_PERIOD = 50;
//     initial begin
//         clk <= 0;
//         forever #(CLOCK_PERIOD/2) clk <= ~clk;
//     end
    
//     initial begin
//         // reset is binded to KEY[3]
//         reset  <= 1'b1;    @(posedge clk);
//         reset  <= 1'b0;    @(posedge clk);
//                            @(posedge clk);

//         do_WB <= 1'b0; 
//         WB_data <= 32'd20; 
//         data_mem_output_final <= 32'd12; 
//         wb_data_out <= 32'd13; 
//                             @(posedge clk);
//                             repeat (20) @(posedge clk);
//         $stop;
//     end
// endmodule

// testing up to the end - waveform saved as test3
module test_tb(); 
	`include "constants.svh"

	logic clk, reset;  

    // testing up to after alu

    top dut (.reset(reset), .clk(clk));

    parameter CLOCK_PERIOD = 50;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
    
    // test cases 
    //         000000000000_01101_010_01011_0000011     lw a1, 0(a3)
    // 1) if the desination of the previous instruction equals the source register of current instruction 
    //    EX: data forwarding where alu_output overides read_out from register 
    //        register[5] = register [1] + register [2] // rd = rs1 + rs2
    //        register[4] = register [5] + register [7] 

    //        0000000_01100_01011_000_01111_0110011    // add a5, a1, a2 // register[15] = register [11] + register[12] = 1+2 = 3
    //        0000000_10001_01111_000_01110_0110011    // add a4, a5, a7 // register[14] = register[15] + register[17] = 3 + 8 = 11

    //    2) if the desination of the instruction before previous instruction equals the source register of current instruction 
    //    EX: data forwarding where data_mem_output overides read_out from register 
    //        register[5] = register [1] + register [2] // rd = rs1 + rs2
    //        registter[10] = register[20] + 4; 
    //        register[4] = register [5] + register [7] 

    //        0000000_01100_01011_000_01111_0110011    // add a5, a1, a2 // register[15] = register[11] + register[12] = 1 + 2 = 3 
    //        0100000_01010_11100_000_01010_0110011    // sub a0, t3, a0 // register[10] = register[28] - register[10] = 5 - 4 = 1 
    //        0000000_10001_01111_000_01110_0110011    // add a4, a5, a7 // register[14] = register[15] + register[17] = 3 + 8 = 11

    //    3) if the desination of the 3 instructions before current instruction equals the source register of current instruction 
    //    EX: data forwarding where wb_output overides read_out from register 
    //        register[5] = register [1] + register [2] // rd = rs1 + rs2 
    //        registter[10] = register[20] + 4; 
    //        register[11] = reigster[100] + 1; 
    //        register[4] = register [5] + register [7]; 

    //        0000000_01100_01011_000_01111_0110011    // add a5, a1, a2 // register[15] = register[11] + register[12] = 1 + 2 = 3 
    //        0000000_00000_00110_100_00110_0110011    // xor t1, t1, zero // register[6] = register[6] ^ 0 = 1^ 0 = 16
    //        0100000_01010_11100_000_01010_0110011    // sub a0, t3, a0 // register[10] = register[28] - register[10] = 5 - 1 = 4 
    //        0000000_10001_01111_000_01110_0110011    // add a4, a5, a7 register[14] = register[15] + register[17] = 3 + 8 = 11


    initial begin
        // reset is binded to KEY[3]
        reset  <= 1'b1;    @(posedge clk);
        reset  <= 1'b0;    @(posedge clk);
                           @(posedge clk);
                            @(posedge clk);
                            repeat (20) @(posedge clk);
        $stop;
    end
endmodule


// 000000000000_01101_010_01011_0000011     lw a1, 0(a3)