`timescale 1ps/10fs

module register (out, in, clk, reset);
    output logic [WIDTH-1:0] out;
    input  logic [WIDTH-1:0] in;
    input  logic clk, reset;
	 
	 logic [31:0] register; 
	
	 always_ff @ (posedge clk) begin 
		if(reset) begin 
			out <= 32'd0; 
		end else begin 
			out <= register[in];
		end 
	 end 
	 
endmodule



//module register_testbench();
//    logic [63:0] q;
//    logic [63:0] d;
//    logic reset, clk;
//
//    parameter ClockDelay = 10000;
//    initial begin // Set up the clock
//		clk <= 0;
//		forever #(ClockDelay/2) clk <= ~clk;
//	end
//
//    register dut(.q, .d, .clk, .reset);
//
//    initial begin
//                                 @(posedge clk);
//        reset <= 1; d <= 64'd2;  @(posedge clk);
//                                 @(posedge clk);
//                    d <= 64'd8;  @(posedge clk);
//                                 @(posedge clk);
//                    d <= 64'd64; @(posedge clk);
//                                 @(posedge clk);
//                                 @(posedge clk);
//        $stop;
//    end
//endmodule
