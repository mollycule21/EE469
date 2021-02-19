module uart_fifo_tx
  #(parameter
    DATA_WIDTH = 8,
    FIFO_ADDR_WIDTH = 10,
    BAUD_RATE  = 115200,
    CLK_FREQ   = 100_000_000
   )(
    input logic                   clk,
    input logic                   rst,
    input logic [DATA_WIDTH-1:0]  data,
    input logic                   valid,
    output logic                  tx
   );
   
    logic                   fifo_empty;
    logic [DATA_WIDTH-1:0]  fifo_output;

    logic uart_ready;
    uart_tx #(
      .DATA_WIDTH(DATA_WIDTH),
      .BAUD_RATE(BAUD_RATE),
      .CLK_FREQ(CLK_FREQ)
    )
    uart_tx_internal   
    (
      .clk(clk),
      .rst(rst),
      .data(fifo_output),
      .valid(!fifo_empty),
      .sig(tx),
      .ready(uart_ready)
    );


  fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(FIFO_ADDR_WIDTH)
  ) 
  input_fifo
  (
    .clk(clk), 
    .rst(rst), 
    .push(valid), 
    .pop(uart_ready), 
    .in(data), 
    .out(fifo_output), 
    .empty(fifo_empty), 
    .full()
  );

endmodule