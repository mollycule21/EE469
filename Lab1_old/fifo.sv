module fifo
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 10
)(
    input    logic                  clk, 
    input    logic                  rst, 
    input    logic                  push, 
    input    logic                  pop, 
    input    logic [DATA_WIDTH-1:0] in, 
    output   logic [DATA_WIDTH-1:0] out, 
    output   logic                  empty, 
    output   logic                  full
);

  localparam DEPTH = 2**ADDR_WIDTH;


  logic [DATA_WIDTH-1:0] data[DEPTH];
  logic [ADDR_WIDTH:0] rptr, wptr;		

  assign out = data[rptr[ADDR_WIDTH-1:0]];
  assign empty = (wptr == rptr);
  assign full = ((rptr[ADDR_WIDTH-1:0] == wptr[ADDR_WIDTH-1:0]) && (rptr[ADDR_WIDTH] ^ wptr[ADDR_WIDTH]));


  always @(posedge clk) begin
    if (rst) begin
      rptr <= 0;
      wptr <= 0;
    end else if (pop && ~empty) begin
      rptr <= rptr + 1'b1;
    end else if (push && ~full) begin
      data[wptr[ADDR_WIDTH-1:0]] <= in;
      wptr <= wptr + 1'b1;
		end 
  end

endmodule