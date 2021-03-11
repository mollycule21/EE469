// This module displays the current level of the game

module display (in, out);
 input logic [4:0] in;
 output logic [6:0] out;

 parameter [6:0] nil = 7'b1111111;
 
 always_comb begin
 case (in)

	 5'd0: begin 
		  out = ~7'b0111111; // 0
	 end 
	 5'd1: begin
		 out = ~7'b0000110; // 1
	 end 
	 5'd2: begin 
		out = ~7'b1011011; // 2
	 end 
	 5'd3: begin
		 out = ~7'b1001111; // 3
	 end 
	 5'd4: begin
		 out = ~7'b1100110; // 4
	 end 
	 5'd5: begin 
		 out = ~7'b1101101; // 5
	 end 
	 5'd6: begin 
		 out = ~7'b1111101; // 6
	 end 
	 5'd7: begin
		 out = ~7'b0000111; // 7
	 end 
	 5'd8: begin 
		 out = ~7'b1111111; // 8
	 end 
	 5'd9: begin 
		 out = ~7'b1101111; // 9
	 end 
	 5'd10: begin 
		out = ~7'b1110111; // A
	 end 
	 5'd11: begin 
		out = ~7'b1111100; // b 
	 end 
	 5'd12: begin 
		out = ~7'b0111001; // C
	 end 
	 5'd13: begin 
		out = ~7'b1011110; // d
	 end 
	 5'd14: begin 
		out = ~7'b1111001; // E
	 end 
	 5'd15: begin 
		out = ~7'b11110001; // F
	 end 
	 5'd16: begin // off 
		out = nil; 
	 end 
	 default: begin 
		out = nil;
	 end 
	 
 endcase
 end

endmodule 
