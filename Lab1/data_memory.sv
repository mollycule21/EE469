// alu.sv  output out -> input address 
// register_file.sv  output read_out_1 = input write_data 
// 

`define NUMBER_OF_WORDS	32		// number of words in data memory	
`define WORD_SIZE			32
`define HALF_WORD			16

module data_memory(clk, reset, read_en, address, xfer_size, write_en, write_data, read_data);
	`include "constants.svh"
	
	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic [2:0]xfer_size;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data;
	
	
	// data memory size in bytes
	localparam data_memory_size = `WORD_SIZE * `NUMBER_OF_WORDS;

	// initialize data memory
	logic [7:0] data_memory [data_memory_size - 1:0];
	logic [7:0] temp_memory [data_memory_size - 1:0];
	// each element is 8 bits, how many of 8 bits we have [32*2048

	// set everything in data memory to 0
	logic [31:0] j;
	/* initial begin
		for (j = 0; j < `NUMBER_OF_WORDS; j = j + 1) begin
			 data_memory[j] = 32'd0; // uncomment when not hardcode testing 
//			if (j == 8) begin // hardcode start 
//				temp_memory[j] = {8'b01010101}; 
//			end else if (j == 16) begin 
//				temp_memory[j + 1'b1] = {8'b01010101}; //17
//				// temp_memory[j] = {8'b00110011}; //16
//			end else if (j == 20) begin 
//				temp_memory[j+3] = {5'd0, 3'b111}; 
//				temp_memory[j+2] = {6'd0, 2'b11};
//				temp_memory[j+1] = {7'd0, 1'b1}; 
//				temp_memory[j]   = {8'd0}; 
//			end else begin 
//				temp_memory[j] = 32'd0; 
//			end  // hardcode end 
		end
		
	end */
	
	initial begin 
		$readmemb("data_memory_test.txt", data_memory);
	end 
	
	// integer i; 
	
	// DFF logic for read operation
	always_ff@(posedge clk) begin
		// make sure address is not out of bound
		assert(address <= data_memory_size); // assert: whatever inside (), has to be met, or will output error 

		if (reset) begin
			// set everything in data memory to 0
			for (j = 0; j < `NUMBER_OF_WORDS; j = j + j) begin
				data_memory[j] <= 8'd0;
			end
			// data_memory = temp_memory;
		// consider each size scenario
		end else if (read_en && (xfer_size == XFER_BYTE)) begin
			read_data[`WORD_SIZE - 1:8] 	<= 24'd0;
			read_data[7:0] 					<= data_memory[address];
		
		end else if (read_en && (xfer_size == XFER_HALF)) begin
			read_data <= {16'd0, data_memory[address], data_memory[(address + 32'd1)]};
		
		end else if (read_en && (xfer_size == XFER_WORD)) begin // 4 bytes total
			read_data					<= {data_memory[address + 32'd3], 
											data_memory[address + 32'd2], 
											data_memory[address + 32'd1], 
											data_memory[address]};
		end else begin 
			read_data = 32'dx; 
		end 
	end 
												
	always_ff @(posedge clk) begin 
		assert(address <= data_memory_size);
		
		if (write_en && xfer_size == XFER_BYTE) begin
			data_memory[address]		<= write_data[7:0];
			read_data					<= 32'bx;
		
		end else if (write_en && xfer_size == XFER_HALF) begin
			data_memory[address]			<= write_data[7:0];
			data_memory[address + 32'd1]	<= write_data[15:8];
			read_data					<= 32'bx;
		
		end else if  (write_en && xfer_size == XFER_WORD) begin 
			data_memory[address]				<= write_data[7:0];
			data_memory[address + 32'd1]	<= write_data[15:8];
			data_memory[address + 32'd2]	<= write_data[24:16];
			data_memory[address + 32'd3]  <= write_data[31:25];
			read_data <= 32'dx; 
		end else begin 
			read_data = 32'dx; 
		end
	end 

endmodule

module data_memory_tb(); 

	`include "constants.svh"

	logic clk, reset;
	logic [`WORD_SIZE - 1:0]address;
	logic read_en, write_en;
	logic [2:0]xfer_size;
	logic [`WORD_SIZE - 1:0]write_data;
	logic [`WORD_SIZE - 1:0]read_data;
	
	
	
	data_memory dut (.clk, .reset, .read_en, .address, .xfer_size, .write_en, .write_data, .read_data);

	
	parameter CLOCK_PERIOD = 100; 
	
	initial begin 
		clk = 1; 
		forever #(CLOCK_PERIOD/2) clk = ~clk;
	end 
	
	initial begin 
		xfer_size <= XFER_BYTE; address <= 32'd8; write_data = {24'd0, 8'b11001100};
		
		reset <= 1; 												repeat (2) @(posedge clk); //read_data = 32'd0; 
		reset <= 0;													repeat (2) @(posedge clk); 
		
 
						read_en <= 0; write_en <= 0; 			repeat (2) @(posedge clk); // read_data = don't care 
						read_en <= 1; 								@(posedge clk); // read_data = {24'd0, 4'd5, 4'd5}
												  write_en <= 1; 	@(posedge clk); // read_data = 32'dx, data_memory[8] = 8'b11001100
								read_en <= 0; write_en <= 0; 	@(posedge clk);		  
								
		xfer_size <= XFER_HALF; address <= 32'd16; write_data = {16'd0, 16'b1111000010101010};
	
		reset <= 1; 												@(posedge clk); // read_data = 32'd0; 
		reset <= 0;													@(posedge clk); 	
		
								read_en <= 0; write_en <= 0; 	@(posedge clk); // read_data = don't care 
								read_en <= 1; 						@(posedge clk); // read_data = {16'd0, 8'b01010101,8'b00110011};
												  write_en <= 1; 	@(posedge clk); /* read_data = 32'dx, data_memory[17] = 8'b11110000, 
																															data_memory[16] = 8'b10101010; */
								read_en <= 0; write_en <= 0;	@(posedge clk);		  		
		
		xfer_size <= XFER_WORD; address <= 32'd20; write_data = {8'd0, 5'b11111, 3'd0, 4'b1111, 4'd0, 3'b111, 5'd0};
						
		reset <= 1; 												@(posedge clk); // read_data = 32'd0; 
		reset <= 0;													@(posedge clk); 	
		
								read_en <= 0; write_en <= 0; 	@(posedge clk); // read_data = don't care 
								read_en <= 1; 						@(posedge clk); // read_data = {5'd0, 3'b1111, 6'd0, 2'b11, 7'd0, 1'b1, 8'd0 };
												  write_en <= 1; 	@(posedge clk); /* read_data = 32'dx, 	data_memory[23] = {8'd0} 
																															data_memory[22] = {5'b11111, 3'd0}
																															data_memory[21] = {4'b1111, 4'd0}
																															data_memory[20] = {3'b111, 5'd0}*/
								read_en <= 0; write_en <= 0;	@(posedge clk);		  						

		$stop;  
	end 
	
	
endmodule
