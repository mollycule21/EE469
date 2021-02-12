module decoder_3_8 (input logic [4:0] A,
								input en, 
								output logic [31:0] B); 
	
	logic [3:0] out; 
								
	decoder_2_4 d2_4 (.en, .in(A[4:3]), .out(.out)); 
	decoder_3_8 d3_8_1 ( .en(out[3]), .in(A[2:0], .out(B[31:24])); 
	decoder_3_8 d3_8_2 ( .en(out[2]), .in(A[2:0], .out(B[23:16]));  
	decoder_3_8 d3_8_3 ( .en(out[1]), .in(A[2:0], .out(B[16:8])); 
	decoder_3_8 d3_8_4 ( .en(out[0]), .in(A[2:0], .out(B[7:0])); 
	

endmodule 

