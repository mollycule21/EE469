// alu.sv  output out -> input address 
// register_file.sv  output read_out_1 = input write_data 
// 

`define NUMBER_OF_WORDS	    1024		// number of words in data memory	
`define WORD_SIZE			32
`define HALF_WORD			16

// for store operations:
// data is from rs2, so write data should be connected to rs2
// for load operations:
// 
module data_memory(clk, reset, read_en, is_signed, address, xfer_size, write_en, write_data, read_data);
	`include "constants.svh"
	
	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic is_signed;						// for read operations
	input logic [1:0]xfer_size;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data;
	
	// buffer the inputs for three clock cycles
	logic read_en_delay_1, read_en_delay_2;
	logic write_en_delay_1, write_en_delay_2;
	logic is_signed_delay_1, is_signed_delay_2;						
	logic [1:0]xfer_size_delay_1, xfer_size_delay_2;
	logic [`WORD_SIZE - 1:0]write_data_delay_1;
	

	// dff delay
	always_ff@(posedge clk) begin
		read_en_delay_1 <= read_en;
		read_en_delay_2 <= read_en_delay_1;

		write_en_delay_1 <= write_en;
		write_en_delay_2 <= write_en_delay_1;

		is_signed_delay_1 <= is_signed;
		is_signed_delay_2 <= is_signed_delay_1;

		xfer_size_delay_1 <= xfer_size;
		xfer_size_delay_2 <= xfer_size_delay_1;

		write_data_delay_1 <= write_data;
	end


	// data memory size in bytes
	localparam data_memory_size = `WORD_SIZE * `NUMBER_OF_WORDS;

	// initialize data memory
	logic [7:0] data_memory [data_memory_size - 1:0];
	
	// DFF logic for read operation
	always_ff@(posedge clk) begin
		// make sure address is not out of bound
	//	assert(address <= data_memory_size); // assert: whatever inside (), has to be met, or will output error 

		if (reset) begin
		end else if (read_en_delay_2) begin
			case(xfer_size_delay_2)
			XFER_BYTE: begin
				// check for signess
				if (data_memory[address][7] && is_signed_delay_2) 
					read_data[`WORD_SIZE - 1:8] <= 24'hffffff;
				else read_data[`WORD_SIZE - 1:8] 	<= 24'b0;

					read_data[7:0] 					<= data_memory[address];
			end
			XFER_HALF: begin
				// check for signess
				if (data_memory[address + 32'd1][7] && is_signed_delay_2) begin
					read_data[`WORD_SIZE - 1:16] <= 16'hffff;
				end else begin
					read_data[`WORD_SIZE - 1:16] <= 16'b0;
				end

				read_data[15:0] <= {data_memory[address + 32'd1], 
									data_memory[address]};
			end
			XFER_WORD: begin
				read_data						<= {data_memory[address + 32'd3], 
													data_memory[address + 32'd2], 
													data_memory[address + 32'd1], 
													data_memory[address]};
			end
			default: read_data <= 32'bx;
			endcase
		end else if (write_en_delay_2) begin
			case(xfer_size_delay_2)
			XFER_BYTE: begin
				data_memory[address]			<= write_data_delay_1[7:0];
				read_data <= 32'bx;
			end
			XFER_HALF: begin 
				data_memory[address]			<= write_data_delay_1[7:0];
				data_memory[address + 32'd1]	<= write_data_delay_1[15:8];
				read_data <= 32'bx;
			end
			XFER_WORD: begin
				data_memory[address]			<= write_data_delay_1[7:0];
				data_memory[address + 32'd1]	<= write_data_delay_1[15:8];
				data_memory[address + 32'd2]	<= write_data_delay_1[23:16];
				data_memory[address + 32'd3]  	<= write_data_delay_1[31:24];
				read_data <= 32'bx;
			end
			default: read_data <= 32'bx;
			endcase
		end else begin
			read_data <= 32'bx;
		end 
	end 

endmodule

//module data_memory_tb(); 
//
//	`include "constants.svh"
//
//	logic clk, reset;
//	logic [`WORD_SIZE - 1:0]address;
//	logic read_en, write_en, is_signed;
//	logic [2:0]xfer_size;
//	logic [`WORD_SIZE - 1:0]write_data;
//	logic [`WORD_SIZE - 1:0]read_data;
//	
//	
//	// dut	
//	data_memory dut (.clk, .reset, .read_en, .is_signed, .address, .xfer_size, .write_en, .write_data, .read_data);
//
//	// set up clock	
//	parameter CLOCK_PERIOD = 100; 
//	initial begin 
//		clk <= 1; 
//		forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	end 
//
//	// set up output
//	initial begin
//		$dumpfile("data_memory.vcd");
//		$dumpvars(0, clk, reset, read_en, is_signed, address, xfer_size,
//					write_en, write_data, read_data);
//	end
//	
//	initial begin 
//		reset <= 1;									@(posedge clk);
//		reset <= 0;	is_signed <= 0;					@(posedge clk);
//		// write to 0x2
//		read_en <= 0; write_en <= 1; xfer_size <= XFER_BYTE; 
//		write_data <= 32'hff; address <= 32'h2; 	@(posedge clk);
//		// write to 0x3
//		write_data <= 32'h11; address <= 32'h3;		@(posedge clk);
//		// write to 0x4
//		write_data <= 32'h22; address <= 32'h4;		@(posedge clk);
//		// write to 0x5
//		write_data <= 32'h33; address <= 32'h5;		@(posedge clk);
//		// read from 0x2
//		read_en <= 1; write_en <= 0; is_signed <= 1; 
//		write_data <= 32'hx; address <= 32'h2;		@(posedge clk);
//		// read from 0x3
//		address <= 32'h3;							@(posedge clk);
//		// read from 0x4
//		xfer_size <= XFER_HALF; address <= 32'h4;	@(posedge clk);
//		// write to 0x6
//		write_en <= 1; read_en <= 0; xfer_size <= XFER_HALF;	
//		address <= 32'h6; write_data <= 32'h667788;				@(posedge clk);
//		// read from 0x6
//		write_en <= 0; read_en <= 1; 							@(posedge clk);
//		// write to 0x7
//		write_en <= 1; read_en <= 0; xfer_size <= XFER_WORD;
//		address <= 32'h7; write_data <= 32'h33445566;			@(posedge clk);
//		// read from 0x7
//		write_en <= 0; read_en <= 1;							@(posedge clk);
//																@(posedge clk);
//		$finish;  
//	end 
//	
//	
//endmodule
