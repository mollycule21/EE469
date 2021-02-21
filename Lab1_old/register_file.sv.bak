// UART = "usb port" 
// 1) code from computer 
// 2) rv32-i complier compiles code into binary form and exports a file 
// 3) take files and send it to hardware 
// 4) instruction memory will read memory file and load all contents inside memeory file into 2D array 
// 5) use address to specify which apart of 2D arrary we want to acces 


module register_file (input logic [4:0] read_reg_1, read_reg_2, wr_reg, 
						input logic [31:0] wr_data,  
						input logic wr_en, 
						input clk; 
						output logic [31:0] read_out_1, read_out_2);
	
	//need to implement register? 
	logic [31:0][31:0] register;

	assign read_out_1 = register[read_reg_1];
	assign read_out_2 = register[read_reg_2];

	always @(posedge clk) begin 
		if (wr_en) begin 
			register[wr_reg] <= wr_data; 
		end 
	end 

endmodule 
			