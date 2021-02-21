module decoder_2_4 (input en, 
								input logic [1:0] in,
								output logic [3:0] out); 

								
	assign out [0] = en & (~in[0] & ~in[1]);
	assign out [1] = en & (in[0] & (~in[1]); 
	assign out [2] = en & (~in[0] & in[1]); 
	assign out [3] = en & (in[0] & in[1]); 

endmodule 

