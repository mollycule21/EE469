/*
Name: Veen Oung

Description: A simple D flip-flop logic with positive edge
             with enable. If enabled, set the output value
             to be the input value. Otherwise, retain the
             output value to its previous value.
*/
module D_FF_enable (q, d, en, clk);
    output logic q;
    input  logic d, en, clk;

    logic carryOver;
    logic [1:0] temp;

    assign temp[0] = q;
    assign temp[1] = d;
    D_FF dff1 (.q(q), .d(carryOver), .reset(1'b0), .clk(clk));

    mux2_1 dffEnable(.out(carryOver), .i0(temp[0]), .i1(temp[1]), .sel(en));
endmodule

module D_FF_enable_testbench();
    logic q;
    logic d, en, clk;

    D_FF_enable dut (.q, .d, .en, .clk);

    initial begin
        q = 0; d = 0; en = 0; clk = 0; #50;
                              clk = 1; #50;
                              clk = 0; #50;
                              clk = 1; #50;
                              clk = 0; #50;
                              
               d = 1;         clk = 0; #50;
                              clk = 1; #50;
                              clk = 0; #50;
                              clk = 1; #50;
                              clk = 0; #50;

                      en = 1; clk = 0; #50;
                              clk = 1; #50;
                              clk = 0; #50;
                              clk = 1; #50;
                              clk = 0; #50;
               
    end
endmodule