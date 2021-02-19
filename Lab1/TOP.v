module TOP
(
	input            CLK100MHZ,
	input      [1:0] btn,
	output           uart_tx_out
);

    reg rst;
    reg halt;
    
    wire [7:0] console_out;
    wire       console_out_valid;

  rv32i riskingVee(
    .clk(CLK100MHZ),
    .rst(rst),
    .halt(halt),
    .console_out(console_out),
    .console_out_valid(console_out_valid)
  );

  uart_fifo_tx
  #(
    .DATA_WIDTH(8),
    .FIFO_ADDR_WIDTH(10),
    .BAUD_RATE(115200),
    .CLK_FREQ(100_000_000)
  )
    to_usb
  (
    .clk(CLK100MHZ),
    .rst(rst),
    .data(console_out),
    .valid(console_out_valid),
    .tx(uart_tx_out) 
  );

always @(posedge CLK100MHZ) begin
    rst <= btn[0];
    halt <= btn[1];
end

endmodule  //TOP

