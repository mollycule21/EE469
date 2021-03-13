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
//module data_memory(clk, reset, read_en, is_signed, address, xfer_size, write_en, write_data, read_data, HEX_out, io_flag_01, io_flag_23
//					);
//	`include "constants.svh"
//	
//	input logic clk, reset;
//	input logic [`WORD_SIZE - 1:0]address;
//	input logic read_en, write_en;
//	input logic is_signed;						// for read operations
//	input logic [1:0]xfer_size;
//	input logic [`WORD_SIZE - 1:0]write_data;
//	output logic [`WORD_SIZE - 1:0]read_data;
//	output logic [7:0] HEX_out;
//	output logic io_flag_01, io_flag_23; 
//
//	// address offset
//	//localparam offset = 32'h8000;
//	//logic [`WORD_SIZE - 1:0]address_after_offset;
//	//assign address_after_offset = (address - offset)/4;
//	logic [`WORD_SIZE - 1:0]address_after_offset;
//	assign address_after_offset = address / 4;
//
//	// data memory size in bytes
//	localparam data_memory_size = `WORD_SIZE * `NUMBER_OF_WORDS;
//
//	// initialize data memory
//	logic [7:0] data_memory_bank_0 [`NUMBER_OF_WORDS - 1:0];
//	logic [7:0] data_memory_bank_1 [`NUMBER_OF_WORDS - 1:0];
//	logic [7:0] data_memory_bank_2 [`NUMBER_OF_WORDS - 1:0];
//	logic [7:0] data_memory_bank_3 [`NUMBER_OF_WORDS - 1:0];
//	initial begin
//		$readmemh(`DATA_FILE_0, data_memory_bank_0);
//		$readmemh(`DATA_FILE_1, data_memory_bank_1);
//		$readmemh(`DATA_FILE_2, data_memory_bank_2);
//		$readmemh(`DATA_FILE_3, data_memory_bank_3);
//	end
//	
//	logic counter; 
//	always_ff@(posedge clk) begin
//		if (reset) begin
//			HEX_out <= 8'dx;
//			io_flag_01 <= 1'b0; 
//			io_flag_23 <= 1'b0; 
//			counter <= 1'b0; 
//		end else if (counter == 1'b0 && write_en && (address >= `IO_ADDRESS_LOW) 
//										&& (address <= `IO_ADDRESS_HIGH)) begin
//
//			$write("I/O: %02h\n", write_data[7:0]);
//			HEX_out <= write_data[7:0];
//			counter <= 1'b1;
//			io_flag_01 <= 1'b1;
//			io_flag_23 <= 1'b0;
//		end else if (counter == 1'b1 && write_en && (address >= `IO_ADDRESS_LOW) 
//										&& (address <= `IO_ADDRESS_HIGH)) begin
//
//			$write("I/O: %02h\n", write_data[7:0]);
//			HEX_out <= write_data[7:0];
//			counter <= 1'b0;
//			io_flag_01 <= 1'b0;
//			io_flag_23 <= 1'b1; 
//		end else begin
//			HEX_out <= 8'dx;
//			io_flag_01 <= 1'b0; 
//			io_flag_23 <= 1'b0;
//		end
//	end
//
//	// calculates bank number: 
//	logic [31:0] bank_num;
//	//assign bank_num = (address - offset) % 4;
//	assign bank_num = address % 4;
//
//	logic [7:0] read_byte_bank_0,
//				read_byte_bank_1,
//				read_byte_bank_2,
//				read_byte_bank_3;
//
//	// read and write operations
//	always_ff@(posedge clk) begin
//		// read data from current instruction 
//		if (read_en) begin
//			read_byte_bank_0 <= data_memory_bank_0[address_after_offset];
//			read_byte_bank_1 <= data_memory_bank_1[address_after_offset];
//			read_byte_bank_2 <= data_memory_bank_2[address_after_offset];
//			read_byte_bank_3 <= data_memory_bank_3[address_after_offset];
//		// read data from previous read instruction aka stay the same 
//		end else if (write_en && xfer_size == XFER_BYTE
//			&& (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)) begin
//				if (bank_num == 0) begin
//					data_memory_bank_0[address_after_offset] <= write_data[7:0];
//				end else if (bank_num == 1) begin
//					data_memory_bank_1[address_after_offset] <= write_data[7:0];
//				end else if (bank_num == 2) begin
//					data_memory_bank_2[address_after_offset] <= write_data[7:0];
//				end else if (bank_num == 3) begin
//					data_memory_bank_3[address_after_offset] <= write_data[7:0];
//				end else begin
//					data_memory_bank_3[address_after_offset] <= data_memory_bank_3[address_after_offset];
//				end
//		end else if (write_en && xfer_size == XFER_HALF
//			&& (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)) begin
//				if (bank_num == 0) begin
//					data_memory_bank_0[address_after_offset]			<= write_data[7:0];
//					data_memory_bank_1[address_after_offset]			<= write_data[15:8];
//				end else if (bank_num == 1) begin
//					data_memory_bank_1[address_after_offset]			<= write_data[7:0];
//					data_memory_bank_2[address_after_offset]			<= write_data[15:8];
//				end else if (bank_num == 2) begin
//					data_memory_bank_2[address_after_offset]			<= write_data[7:0];
//					data_memory_bank_3[address_after_offset]			<= write_data[15:8];
//				end else begin
//					data_memory_bank_3[address_after_offset] <= data_memory_bank_3[address_after_offset];
//				end
//		end else if (write_en && xfer_size == XFER_WORD
//			&& (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)) begin
//				data_memory_bank_0[address_after_offset]			<= write_data[7:0];
//				data_memory_bank_1[address_after_offset]			<= write_data[15:8];
//				data_memory_bank_2[address_after_offset]			<= write_data[23:16];
//				data_memory_bank_3[address_after_offset]  			<= write_data[31:24];
//		end else begin
//				data_memory_bank_3[address_after_offset] <= data_memory_bank_3[address_after_offset];
//		end
//	end
//
//
//	logic [`WORD_SIZE - 1:0] bank_numed;
//	always_ff@(posedge clk) begin
//		bank_numed <= bank_num;
//	end
//
//	logic read_en_delayed, is_signed_delayed;
//	logic [1:0]xfer_size_delayed;
//	logic [`WORD_SIZE - 1:0] address_delayed;
//	always_ff@(posedge clk) begin
//		read_en_delayed <= read_en;
//		is_signed_delayed <= is_signed;
//		xfer_size_delayed <= xfer_size;
//	end
//
//	always_comb begin
//		if (read_en_delayed && xfer_size_delayed == XFER_BYTE
//			&& (address_delayed < `IO_ADDRESS_LOW || address_delayed > `IO_ADDRESS_HIGH) && is_signed_delayed) begin
//				if (bank_numed == 0) read_data = 32'($signed(read_byte_bank_0));
//				else if (bank_numed == 1) read_data = 32'($signed(read_byte_bank_1));
//				else if (bank_numed == 2) read_data = 32'($signed(read_byte_bank_2));
//				else if (bank_numed == 3) read_data = 32'($signed(read_byte_bank_3));
//				else read_data = 32'bx;
//		end else if (read_en_delayed && xfer_size_delayed == XFER_BYTE
//			&& (address_delayed < `IO_ADDRESS_LOW || address_delayed > `IO_ADDRESS_HIGH) && ~is_signed_delayed) begin
//				if (bank_numed == 0) read_data = 32'(read_byte_bank_0);
//				else if (bank_numed == 1) read_data = 32'(read_byte_bank_1);
//				else if (bank_numed == 2) read_data = 32'(read_byte_bank_2);
//				else if (bank_numed == 3) read_data = 32'(read_byte_bank_3);
//				else read_data = 32'bx;
//		end else if (read_en_delayed && xfer_size_delayed == XFER_HALF
//			&& (address_delayed < `IO_ADDRESS_LOW ||  address_delayed > `IO_ADDRESS_HIGH) && is_signed_delayed) begin
//				if (bank_numed == 0) begin
//					read_data = 32'($signed({read_byte_bank_1, read_byte_bank_0})); 
//				end else if (bank_numed == 1) begin
//					read_data = 32'($signed({read_byte_bank_2, read_byte_bank_1})); 
//				end else if (bank_numed == 2) begin
//					read_data = 32'($signed({read_byte_bank_3, read_byte_bank_2}));
//				end else begin
//					read_data = 32'bx;
//				end
//		end else if (read_en_delayed && xfer_size_delayed == XFER_HALF
//			&& (address_delayed < `IO_ADDRESS_LOW ||  address_delayed > `IO_ADDRESS_HIGH) && ~is_signed_delayed) begin
//				if (bank_numed == 0) begin
//					read_data = 32'({read_byte_bank_1, read_byte_bank_0}); 
//				end else if (bank_numed == 1) begin
//					read_data = 32'({read_byte_bank_2, read_byte_bank_1}); 
//				end else if (bank_numed == 2) begin
//					read_data = 32'({read_byte_bank_3, read_byte_bank_2});
//				end else begin
//					read_data = 32'bx;
//				end
//		end else if (read_en_delayed && xfer_size_delayed == XFER_WORD
//			&& (address_delayed < `IO_ADDRESS_LOW ||  address_delayed > `IO_ADDRESS_HIGH)) begin 
//				read_data						= {read_byte_bank_3, 
//													read_byte_bank_2, 
//													read_byte_bank_1, 
//													read_byte_bank_0};
//		end else begin
//			read_data = 32'bx;
//		end 
//	end 
//
//endmodule
module data_memory(clk, reset, read_en, is_signed, address, xfer_size, write_en, write_data, read_data);
	`include "constants.svh"
	
	input logic clk, reset;
	input logic [`WORD_SIZE - 1:0]address;
	input logic read_en, write_en;
	input logic is_signed;						// for read operations
	input logic [1:0]xfer_size;
	input logic [`WORD_SIZE - 1:0]write_data;
	output logic [`WORD_SIZE - 1:0]read_data;

	// address offset
	localparam offset = 32'h1000;
	logic [`WORD_SIZE - 1:0]address_after_offset;
	always_comb begin
		address_after_offset = address / 4;
		//address_after_offset = (address - offset)/4;
	end

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
	logic  [7:0] data_memory_bank_0[`NUMBER_OF_WORDS - 1:0];
	logic  [7:0] data_memory_bank_1[`NUMBER_OF_WORDS - 1:0];
	logic  [7:0] data_memory_bank_2[`NUMBER_OF_WORDS - 1:0];
	logic  [7:0] data_memory_bank_3[`NUMBER_OF_WORDS - 1:0];
	initial begin
		$readmemh(`DATA_FILE_0, data_memory_bank_0);
		$readmemh(`DATA_FILE_1, data_memory_bank_1);
		$readmemh(`DATA_FILE_2, data_memory_bank_2);
		$readmemh(`DATA_FILE_3, data_memory_bank_3);
	end
	
	logic [31:0] bank_num;
	//assign bank_num = (address - offset) % 4;
	assign bank_num = address % 4;

	logic [7:0] read_byte_bank_0,
				read_byte_bank_1,
				read_byte_bank_2,
				read_byte_bank_3;
				
				
    logic write_byte_bank_0, write_byte_bank_1, write_byte_bank_2, write_byte_bank_3;
    assign write_byte_bank_0 = write_en && xfer_size == XFER_BYTE
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 0);
    assign write_byte_bank_1 = write_en && xfer_size == XFER_BYTE
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 1);
    assign write_byte_bank_2 = write_en && xfer_size == XFER_BYTE
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 2);
    assign write_byte_bank_3 = write_en && xfer_size == XFER_BYTE
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 3);
    
    logic write_half_bank_0, write_half_bank_1, write_half_bank_2, write_half_bank_3;
    assign write_half_bank_0 = write_en && xfer_size == XFER_HALF
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 0);
    assign write_half_bank_1 = write_en && xfer_size == XFER_HALF
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 1);
    assign write_half_bank_2 = write_en && xfer_size == XFER_HALF
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 2);
    assign write_half_bank_3 = write_en && xfer_size == XFER_HALF
                                && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH)
                                && (bank_num == 3);
                                
    logic write_word_all_bank;
    assign write_word_all_bank = write_en && xfer_size == XFER_WORD
                                    && (address < `IO_ADDRESS_LOW || address > `IO_ADDRESS_HIGH);

    // bank 0 read and write conditions
    always_ff@(posedge clk) begin
        if (read_en) begin
            read_byte_bank_0 <= data_memory_bank_0[address_after_offset];
		end

		if (write_byte_bank_0 | write_half_bank_0 | write_word_all_bank) begin
            data_memory_bank_0[address_after_offset] <= write_data[7:0];
        end
    end
    
    // bank 1 read and write conditions
    always_ff@(posedge clk) begin
        if (read_en) begin
            read_byte_bank_1 <= data_memory_bank_1[address_after_offset];
		end
		
		if (write_byte_bank_1 | write_half_bank_1) begin
            data_memory_bank_1[address_after_offset] <= write_data[7:0];
        end

		if (write_half_bank_0 | write_word_all_bank) begin
            data_memory_bank_1[address_after_offset] <= write_data[15:8];
        end
    end
    
    // bank 2 read and write conditions
    always_ff@(posedge clk) begin
        if (read_en) begin
            read_byte_bank_2 <= data_memory_bank_2[address_after_offset];
		end

		if (write_half_bank_1) begin
            data_memory_bank_2[address_after_offset] <= write_data[15:8];
        end

		if (write_byte_bank_2 | write_half_bank_2) begin
            data_memory_bank_2[address_after_offset] <= write_data[7:0];
        end

		if (write_word_all_bank) begin
            data_memory_bank_2[address_after_offset] <= write_data[23:16];
        end
    end
    
    // bank 3 read and write conditions
    always_ff@(posedge clk) begin
        if (read_en) begin
            read_byte_bank_3 <= data_memory_bank_3[address_after_offset];
		end

		if (write_byte_bank_3) begin
            data_memory_bank_3[address_after_offset] <= write_data[7:0];
        end

		if (write_half_bank_2) begin
            data_memory_bank_3[address_after_offset] <= write_data[15:8];
        end

		if (write_word_all_bank) begin
            data_memory_bank_3[address_after_offset] <= write_data[31:24];
        end
    end
    

	logic [`WORD_SIZE - 1:0] bank_num_delayed;
	always_ff@(posedge clk) begin
		bank_num_delayed <= bank_num;
	end

	always_comb begin
		if (read_en_delay_1 && xfer_size_delay_1 == XFER_BYTE
			&& (address_delay < `IO_ADDRESS_LOW || address_delay > `IO_ADDRESS_HIGH) && is_signed_delay_1) begin
				if (bank_num_delayed == 0) read_data = 32'($signed(read_byte_bank_0));
				else if (bank_num_delayed == 1) read_data = 32'($signed(read_byte_bank_1));
				else if (bank_num_delayed == 2) read_data = 32'($signed(read_byte_bank_2));
				else if (bank_num_delayed == 3) read_data = 32'($signed(read_byte_bank_3));
				else read_data = 32'b0;
		end else if (read_en_delay_1 && xfer_size_delay_1 == XFER_BYTE
			&& (address_delay < `IO_ADDRESS_LOW || address_delay > `IO_ADDRESS_HIGH) && ~is_signed_delay_1) begin
				if (bank_num_delayed == 0) read_data = 32'(read_byte_bank_0);
				else if (bank_num_delayed == 1) read_data = 32'(read_byte_bank_1);
				else if (bank_num_delayed == 2) read_data = 32'(read_byte_bank_2);
				else if (bank_num_delayed == 3) read_data = 32'(read_byte_bank_3);
				else read_data = 32'b0;
		end else if (read_en_delay_1 && xfer_size_delay_1 == XFER_HALF
			&& (address_delay < `IO_ADDRESS_LOW ||  address_delay > `IO_ADDRESS_HIGH) && is_signed_delay_1) begin
				if (bank_num_delayed == 0) begin
					read_data = 32'($signed({read_byte_bank_1, read_byte_bank_0})); 
				end else if (bank_num_delayed == 1) begin
					read_data = 32'($signed({read_byte_bank_2, read_byte_bank_1})); 
				end else if (bank_num_delayed == 2) begin
					read_data = 32'($signed({read_byte_bank_3, read_byte_bank_2}));
				end else begin
					read_data = 32'b0;
				end
		end else if (read_en_delay_1 && xfer_size_delay_1 == XFER_HALF
			&& (address_delay < `IO_ADDRESS_LOW ||  address_delay > `IO_ADDRESS_HIGH) && ~is_signed_delay_1) begin
				if (bank_num_delayed == 0) begin
					read_data = 32'({read_byte_bank_1, read_byte_bank_0}); 
				end else if (bank_num_delayed == 1) begin
					read_data = 32'({read_byte_bank_2, read_byte_bank_1}); 
				end else if (bank_num_delayed == 2) begin
					read_data = 32'({read_byte_bank_3, read_byte_bank_2});
				end else begin
					read_data = 32'b0;
				end
		end else if (read_en_delay_1 && xfer_size_delay_1 == XFER_WORD
			&& (address_delay < `IO_ADDRESS_LOW ||  address_delay > `IO_ADDRESS_HIGH)) begin 
				read_data						= {read_byte_bank_3, 
													read_byte_bank_2, 
													read_byte_bank_1, 
													read_byte_bank_0};
		end else begin
			read_data = 32'b0;
		end 
	end 

endmodule

module data_memory_tb(); 

	`include "constants.svh"

	logic clk, reset;
	logic [`WORD_SIZE - 1:0]address;
	logic read_en, write_en, is_signed;
	logic [1:0]xfer_size;
	logic [`WORD_SIZE - 1:0]write_data;
	logic [`WORD_SIZE - 1:0]read_data;
	
	// input logic clk, reset;
		// input logic is_signed;	
		// input logic read_en, write_en;
		// input logic [1:0]xfer_size;
		// input logic [`WORD_SIZE - 1:0]write_data;
		// input logic [`WORD_SIZE - 1:0]address;

		// for read operations
	
	
	// dut	
	data_memory dut(.clk, .reset, .read_en, .is_signed, .address, .xfer_size, .write_en, .write_data, 
					.read_data);

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
		reset <= 1;											@(posedge clk);
		reset <= 0;	is_signed <= 0;		@(posedge clk);
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

