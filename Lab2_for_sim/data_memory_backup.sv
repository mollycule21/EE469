// alu.sv  output out -> input address 
// register_file.sv  output read_out_1 = input write_data 
// 

`define NUMBER_OF_WORDS	    2048		// number of words in data memory	
`define WORD_SIZE			32
`define HALF_WORD			16
`define IO_ADDRESS_HIGH		32'h0002ffff
`define IO_ADDRESS_LOW		32'h0002fff0
`define TESTING
`define DATA_FILE_0			"../assets/data0_extended.hex"
`define DATA_FILE_1			"../assets/data1_extended.hex"
`define DATA_FILE_2			"../assets/data2_extended.hex"
`define DATA_FILE_3			"../assets/data3_extended.hex"

// for store operations:
// data is from rs2, so write data should be connected to rs2


// 0x0000 8000 - 0x0000 ffff is for initialized data
// 0x0001 0000 - 0x0001 7fff is for stack (and i guess heap)
// 0x0002 fff0 - 0x0002 ffff is for io operations
module data_memory(clk, reset, read_en, is_signed, address, xfer_size, write_en, write_data, read_data, HEX_out, io_flag_01, io_flag_23,
					prev_read_data);
	`include "constants.svh"
	
	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic is_signed;						// for read operations
	input logic [1:0]xfer_size;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data, prev_read_data;
	output logic [7:0] HEX_out;
	output logic io_flag_01, io_flag_23; 


module data_memory_tb(); 

	`include "constants.svh"

	logic clk, reset;
	logic [`WORD_SIZE - 1:0]address;
	logic read_en, write_en, is_signed;
	logic [1:0]xfer_size;
	logic [`WORD_SIZE - 1:0]write_data;
	logic [`WORD_SIZE - 1:0]read_data, prev_read_data;
	logic [7:0] HEX_out;
	logic io_flag_01, io_flag_23;
	
	// input logic clk, reset;
		// input logic is_signed;	
		// input logic read_en, write_en;
		// input logic [1:0]xfer_size;
		// input logic [`WORD_SIZE - 1:0]write_data;
		// input logic [`WORD_SIZE - 1:0]address;

						// for read operations
	
	
	// dut	
	data_memory dut(.clk, .reset, .read_en, .is_signed, .address, .xfer_size, .write_en, .write_data, 
					.read_data, .HEX_out, .io_flag_01, .io_flag_23, .prev_read_data);

	
	// set up clock	
	parameter CLOCK_PERIOD = 100; 
	initial begin 
		clk <= 1; 
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end 

	// localparam [1:0]XFER_BYTE 	= 2'b00;
	// localparam [1:0]XFER_HALF	= 2'b01;
	// localparam [1:0]XFER_WORD	= 2'b10;
	initial begin 
		reset <= 1;												@(posedge clk);
		reset <= 0;	is_signed <= 0;	prev_read_data = 32'd96;	@(posedge clk);
		// write to 0x2
		read_en <= 0; write_en <= 1; xfer_size <= 2'b00; 
		write_data <= 32'hff; address <= 32'h2; 	@(posedge clk);
		
		// write to 0x3
		write_data <= 32'h11; address <= 32'h3;		@(posedge clk);
		// write to 0x4
		write_data <= 32'h22; address <= 32'h4;		@(posedge clk);
		// write to 0x5
		write_data <= 32'h33; address <= 32'h5;		@(posedge clk);
		
		
		// read from 0x2
		read_en <= 1; write_en <= 0; is_signed <= 0; 
		write_data <= 32'd30; address <= 32'h2;		@(posedge clk);
		// read from 0x3
		address <= 32'h3;							@(posedge clk);
		// read from 0x4
		xfer_size <= 2'b01 ; address <= 32'h4;	@(posedge clk);
		
		// write to 0x6
		write_en <= 1; read_en <= 0; xfer_size <= 2'b01;	
		address <= 32'h6; write_data <= 32'h667788;				@(posedge clk);
		// read from 0x6
		write_en <= 0; read_en <= 1; 							@(posedge clk);
		// write to 0x7
		write_en <= 1; read_en <= 0; xfer_size <= 2'b10;
		address <= 32'h7; write_data <= 32'h33445566;			@(posedge clk);
		// read from 0x7
		write_en <= 0; read_en <= 1;							@(posedge clk);
																@(posedge clk);
		$stop;  
	end 
	
	
endmodule

