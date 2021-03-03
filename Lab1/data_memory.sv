// alu.sv  output out -> input address 
// register_file.sv  output read_out_1 = input write_data 
// 

`define NUMBER_OF_WORDS	    2048		// number of words in data memory	
`define WORD_SIZE			32
`define HALF_WORD			16
`define IO_ADDRESS_HIGH		32'h0002ffff
`define IO_ADDRESS_LOW		32'h0002fff0
`define TESTING
`define DATA_FILE_0			"./assets/data0_extended.hex"
`define DATA_FILE_1			"./assets/data1_extended.hex"
`define DATA_FILE_2			"./assets/data2_extended.hex"
`define DATA_FILE_3			"./assets/data3_extended.hex"

// for store operations:
// data is from rs2, so write data should be connected to rs2


// 0x0000 8000 - 0x0000 ffff is for initialized data
// 0x0001 0000 - 0x0001 7fff is for stack (and i guess heap)
// 0x0002 fff0 - 0x0002 ffff is for io operations
module data_memory(clk, reset, read_en, is_signed, address, xfer_size, write_en, write_data, read_data, serial_txd);
	`include "constants.svh"
	
	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic is_signed;						// for read operations
	input logic [1:0]xfer_size;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data;
	output logic serial_txd;

	// address offset
	localparam offset = 32'h8000;
	logic [`WORD_SIZE - 1:0]address_after_offset;
	assign address_after_offset = (address - offset)/4;

	// buffer the inputs for three clock cycles
	logic [`WORD_SIZE - 1:0] address_delay;
	logic read_en_delay_1, read_en_delay_2, read_en_delay_3;
	logic write_en_delay_1, write_en_delay_2;
	logic is_signed_delay_1, is_signed_delay_2, is_signed_delay_3;						
	logic [1:0]xfer_size_delay_1, xfer_size_delay_2, xfer_size_delay_3;
	logic [`WORD_SIZE - 1:0]write_data_delay_1;
	

	// dff delay
	always_ff@(posedge clk) begin
		address_delay <= address;

		read_en_delay_1 <= read_en;
		read_en_delay_2 <= read_en_delay_1;
		read_en_delay_3 <= read_en_delay_2;

		write_en_delay_1 <= write_en;
		write_en_delay_2 <= write_en_delay_1;

		is_signed_delay_1 <= is_signed;
		is_signed_delay_2 <= is_signed_delay_1;
		is_signed_delay_3 <= is_signed_delay_2;

		xfer_size_delay_1 <= xfer_size;
		xfer_size_delay_2 <= xfer_size_delay_1;
		xfer_size_delay_3 <= xfer_size_delay_2;

		write_data_delay_1 <= write_data;
	end


	// data memory size in bytes
	localparam data_memory_size = `WORD_SIZE * `NUMBER_OF_WORDS;

	// initialize data memory
	logic [7:0] data_memory_bank_0 [`NUMBER_OF_WORDS - 1:0];
	logic [7:0] data_memory_bank_1 [`NUMBER_OF_WORDS - 1:0];
	logic [7:0] data_memory_bank_2 [`NUMBER_OF_WORDS - 1:0];
	logic [7:0] data_memory_bank_3 [`NUMBER_OF_WORDS - 1:0];
	initial begin
		$readmemh(`DATA_FILE_0, data_memory_bank_0);
		$readmemh(`DATA_FILE_1, data_memory_bank_1);
		$readmemh(`DATA_FILE_2, data_memory_bank_2);
		$readmemh(`DATA_FILE_3, data_memory_bank_3);
	end
	
	// serial transmitter for io operations
	logic [7:0]serial_tx_data;
	logic tx_data_available, serial_tx_ready;
`ifndef TESTING
	serial_transmitter serial_out(.clock(clk), .reset(reset), .tx_data(serial_tx_data), 
									.tx_data_available(tx_data_available), 
									.tx_ready(serial_tx_ready),
									.serial_tx(serial_txd));
`endif	
	always_ff@(posedge clk) begin
		if (reset) begin
			serial_tx_data <= 8'bx;
			tx_data_available <= 1'b0;
		end else if (write_en_delay_2 && (address >= `IO_ADDRESS_LOW) 
										&& (address <= `IO_ADDRESS_HIGH)) begin
`ifdef TESTING
			$write("I/O: %02h\n", write_data_delay_1[7:0]);
`else
			tx_data_available 	<= 1'b1;
			serial_tx_data 		<= write_data_delay_1[7:0];
`endif
		end else begin
			serial_tx_data <= 8'bx;
			tx_data_available <= 1'b0;
		end
	end
//`ifndef TESTING
//    // Serial transmitter
//    logic [7:0] serial_tx_data;
//    logic serial_tx_data_available, serial_tx_ready;
//    serial_transmitter serial_out (
//      .clock                (clk),
//      .reset                (reset),
//      .tx_data              (serial_tx_data),
//      .tx_data_available    (serial_tx_data_available),
//      .tx_ready             (serial_tx_ready),
//      .serial_tx            (serial_txd)
//    );
//
//    // Dummy data to demonstrate serial transmission
//    logic last_serial_tx_ready;
//    assign serial_tx_data_available = write_en_delay_2
//									& (address >= `IO_ADDRESS_LOW)
//									& (address <= `IO_ADDRESS_HIGH);
//
//    always_ff @(posedge clk) begin
//      if (reset) begin
//        last_serial_tx_ready <= 1'b0;
//      end else if (serial_tx_ready && !last_serial_tx_ready) begin
//		serial_tx_data <= write_data_delay_1[7:0];
//        last_serial_tx_ready <= serial_tx_ready;
//      end else begin
//        last_serial_tx_ready <= serial_tx_ready;
//      end
//    end
//`endif




	logic [31:0] bank_num;
	assign bank_num = (address - offset) % 4;

	logic [7:0] read_byte_bank_0,
				read_byte_bank_1,
				read_byte_bank_2,
				read_byte_bank_3;

	// read and write operations
	always_ff@(posedge clk) begin
		if (read_en_delay_2) begin
			read_byte_bank_0 <= data_memory_bank_0[address_after_offset];
			read_byte_bank_1 <= data_memory_bank_1[address_after_offset];
			read_byte_bank_2 <= data_memory_bank_2[address_after_offset];
			read_byte_bank_3 <= data_memory_bank_3[address_after_offset];
		end else if (write_en_delay_2 && xfer_size_delay_2 == XFER_BYTE
			&& (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)) begin
				if (bank_num == 0) begin
					data_memory_bank_0[address_after_offset] <= write_data_delay_1[7:0];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else if (bank_num == 1) begin
					data_memory_bank_1[address_after_offset] <= write_data_delay_1[7:0];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else if (bank_num == 2) begin
					data_memory_bank_2[address_after_offset] <= write_data_delay_1[7:0];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else if (bank_num == 3) begin
					data_memory_bank_3[address_after_offset] <= write_data_delay_1[7:0];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else begin
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end
		end else if (write_en_delay_2 && xfer_size_delay_2 == XFER_HALF
			&& (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)) begin
				if (bank_num == 0) begin
					data_memory_bank_0[address_after_offset]			<= write_data_delay_1[7:0];
					data_memory_bank_1[address_after_offset]			<= write_data_delay_1[15:8];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else if (bank_num == 1) begin
					data_memory_bank_1[address_after_offset]			<= write_data_delay_1[7:0];
					data_memory_bank_2[address_after_offset]			<= write_data_delay_1[15:8];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else if (bank_num == 2) begin
					data_memory_bank_2[address_after_offset]			<= write_data_delay_1[7:0];
					data_memory_bank_3[address_after_offset]			<= write_data_delay_1[15:8];
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end else begin
					read_byte_bank_0 <= 8'bx;
					read_byte_bank_1 <= 8'bx;
					read_byte_bank_2 <= 8'bx;
					read_byte_bank_3 <= 8'bx;
				end
		end else if (write_en_delay_2 && xfer_size_delay_2 == XFER_WORD
			&& (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)) begin
				data_memory_bank_0[address_after_offset]			<= write_data_delay_1[7:0];
				data_memory_bank_1[address_after_offset]			<= write_data_delay_1[15:8];
				data_memory_bank_2[address_after_offset]			<= write_data_delay_1[23:16];
				data_memory_bank_3[address_after_offset]  			<= write_data_delay_1[31:24];
				read_byte_bank_0 <= 8'bx;
				read_byte_bank_1 <= 8'bx;
				read_byte_bank_2 <= 8'bx;
				read_byte_bank_3 <= 8'bx;
		end else begin
			read_byte_bank_0 <= 8'bx;
			read_byte_bank_1 <= 8'bx;
			read_byte_bank_2 <= 8'bx;
			read_byte_bank_3 <= 8'bx;
		end
	end


	logic [`WORD_SIZE - 1:0] bank_num_delayed;
	always_ff@(posedge clk) begin
		bank_num_delayed <= bank_num;
	end

	always_comb begin
		if (read_en_delay_3 && xfer_size_delay_3 == XFER_BYTE
			&& (address_delay < `IO_ADDRESS_LOW || address_delay > `IO_ADDRESS_HIGH) && is_signed_delay_3) begin
				if (bank_num_delayed == 0) read_data = 32'($signed(read_byte_bank_0));
				else if (bank_num_delayed == 1) read_data = 32'($signed(read_byte_bank_1));
				else if (bank_num_delayed == 2) read_data = 32'($signed(read_byte_bank_2));
				else if (bank_num_delayed == 3) read_data = 32'($signed(read_byte_bank_3));
				else read_data = 32'bx;
		end else if (read_en_delay_3 && xfer_size_delay_3 == XFER_BYTE
			&& (address_delay < `IO_ADDRESS_LOW || address_delay > `IO_ADDRESS_HIGH) && ~is_signed_delay_3) begin
				if (bank_num_delayed == 0) read_data = 32'(read_byte_bank_0);
				else if (bank_num_delayed == 1) read_data = 32'(read_byte_bank_1);
				else if (bank_num_delayed == 2) read_data = 32'(read_byte_bank_2);
				else if (bank_num_delayed == 3) read_data = 32'(read_byte_bank_3);
				else read_data = 32'bx;
		end else if (read_en_delay_3 && xfer_size_delay_3 == XFER_HALF
			&& (address_delay < `IO_ADDRESS_LOW ||  address_delay > `IO_ADDRESS_HIGH) && is_signed_delay_3) begin
				if (bank_num_delayed == 0) begin
					read_data = 32'($signed({read_byte_bank_1, read_byte_bank_0})); 
				end else if (bank_num_delayed == 1) begin
					read_data = 32'($signed({read_byte_bank_2, read_byte_bank_1})); 
				end else if (bank_num_delayed == 2) begin
					read_data = 32'($signed({read_byte_bank_3, read_byte_bank_2}));
				end else begin
					read_data = 32'bx;
				end
		end else if (read_en_delay_3 && xfer_size_delay_3 == XFER_HALF
			&& (address_delay < `IO_ADDRESS_LOW ||  address_delay > `IO_ADDRESS_HIGH) && ~is_signed_delay_3) begin
				if (bank_num_delayed == 0) begin
					read_data = 32'({read_byte_bank_1, read_byte_bank_0}); 
				end else if (bank_num_delayed == 1) begin
					read_data = 32'({read_byte_bank_2, read_byte_bank_1}); 
				end else if (bank_num_delayed == 2) begin
					read_data = 32'({read_byte_bank_3, read_byte_bank_2});
				end else begin
					read_data = 32'bx;
				end
		end else if (read_en_delay_3 && xfer_size_delay_3 == XFER_WORD
			&& (address_delay < `IO_ADDRESS_LOW ||  address_delay > `IO_ADDRESS_HIGH)) begin 
				read_data						= {read_byte_bank_3, 
													read_byte_bank_2, 
													read_byte_bank_1, 
													read_byte_bank_0};
		end else begin
			read_data = 32'bx;
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
