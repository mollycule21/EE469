module decoder_3_8 (input en,
								input logic [2:0] in, 
								output logic [7:0] out); 

								
	assign out [0] = (~in[2] & ~in[1] & ~in[0]); // 000
	assign out [1] = (~in[2] & ~in[1] & in[0]); 	// 001
	assign out [2] = (~in[0] & in[1] & ~in[0]); 	// 010
	assign out [3] = (~in[0] & in[1] & in[0]);  	// 011
	assign out [4] = (in[2] & ~in[1] & ~in[0]); 	// 100
	assign out [5] = (in[2] & ~in[1] & in[0]); 	// 101
	assign out [6] = (in[0] & in[1] & ~in[0]); 	// 110
	assign out [7] = (in[0] & in[1] & in[0]);  	// 111
	

endmodule 

