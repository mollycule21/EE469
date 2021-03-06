module fsm (clk, reset, io_flag, in, out);

	input logic clk, reset;
	input logic [6:0] in; 
	input logic io_flag; 
	output logic[6:0] out;
	
	logic [6:0] out_ub;
	//int counter; 
	
	// @positive edge 
	 always_ff @(posedge clk) begin
		 if (reset) begin
			out <= ~7'b0000000;
			//counter <= 0;
		 end
		 // update 
		 else if (io_flag) begin 
			out <= in; 
			//counter <= counter + 1;
		end else begin 
			out <= out;
		end 
	end
	
//	always_comb begin
//		if (reset) begin
//			out = ~7'b0000000;
//		end if (counter % 2 == 0) begin
//			out_ub = out_ub; 
//		end else if (counter % 2 == 1) begin
//			out = out_ub;
//		end else begin
//			out = ~7'b0000000;
//		end
//	end
	
	// logic [6:0] buffer [2:0]; 
	
	// buf #(1000)(out, out_ub); 

endmodule
