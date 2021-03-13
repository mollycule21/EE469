
`define WORD_SIZE 32

module  mem_to_mem_hazard (mem_wb_dmo, dmo, wb_dmo_load_inst, ex_mem_instruction, mem_wb_instruction);
    
    output logic [`WORD_SIZE -1:0] mem_wb_dmo; // dmo = data_memory_output, outputs final data before it gets clocked at mem_wb pipe 
    input logic [`WORD_SIZE -1:0] dmo ; // output from data memory, overide this data if needed 
    input logic [`WORD_SIZE -1:0] wb_dmo_load_inst; // data that we're overiding with if previous instruction is not load and current instruction is not stored 
    input logic [`WORD_SIZE - 1:0] ex_mem_instruction; // current instruction 
    input logic [`WORD_SIZE - 1:0] mem_wb_instruction; // previous instruction 
    `include "constants.svh"

// rs1	= instruction[19:15];  for register of source
// rd  = instruction[11:7]; for register of load 


logic [3:0] store_type, load_type; 
// check to see if we need to overide 
always_comb begin 
    // funct_3	= instruction[14:12]; // checks what type stored and load 
        if ((ex_mem_instruction[6:0] == store) && (mem_wb_instruction[6:0] == load) && 
                ( ex_mem_instruction[19:15] == mem_wb_instruction[11:7])) begin 
                    
            overide  = 1'b1; 
            store_type = ex_mem_instruction[14:12]; 
            load_type = mem_wb_instruction[14:12];
        end else begin 
            overide = 1'b0; 
        end 
    end

// perform overide or leave alone 
    always_comb begin 
        // SB 
        if (overide && ((store_type == SB)) begin //
              // overidng dmo with previous output from load instruction before it gets clocked at mem_wb pipe 
            mem_wb_dmo <= {24'd0, wb_dmo_load_inst[7:0]}; // same outputs for all load types
        // SH, SHU
        end else if ((overide && ((store_type == SH))) begin 
            if (load_type == LBU) begin 
                mem_wb_dmo = {16'd0, dmo[15:8], wb_dmo_load_inst[7:0]}; 
            end else if (load_type == LB) begin
                mem_wb_dmo = 32'($signed({dmo[15:8], wb_dmo_load_inst[7:0]}));
            end else begin 
                mem_wb_dmo = {16'd0, wb_dmo_load_inst[15:0]}; 
            end 
        // SW 
        end else if ((overide && (store_type == SW))) begin 
            if (load_type == LBU) begin 
                mem_wb_dmo = {dmo[31:8], wb_dmo_load_inst[7:0]};
            end else if (load_type == LB) begin
                mem_wb_dmo = 32'($signed({dmo[31:8], wb_dmo_load_inst[7:0]}));
            end else if (load_type == LHU) begin 
                mem_wb_dmo = {dmo[31:16], wb_dmo_load_inst[15:0]};
            end else if (load_tyep == LH) begin
                mem_wb_dmo = 32'($signed({dmo[31:16], wb_dmo_load_inst[15:0]}));
            end else begin 
                mem_wb_dmo = wb_dmo_load_inst; 
            end 
        end else begin 
                mem_wb_dmo = dmo; // no overwriting occurs 
        end 
    end 
endmodule 

module mem_to_mem_hazard_tb();
    logic [`WORD_SIZE -1:0] mem_wb_dmo; // dmo = data_memory_output, outputs final data before it gets clocked at mem_wb pipe 
    logic [`WORD_SIZE -1:0] dmo ; // output from data memory, overide this data if needed 
    logic [`WORD_SIZE -1:0] wb_dmo_load_inst; // data that we're overiding with if previous instruction is not load and current instruction is not stored 
    logic [`WORD_SIZE - 1:0] ex_mem_instruction; // current instruction 
    logic [`WORD_SIZE - 1:0] mem_wb_instruction; // previous instruction 
    `include "constants.svh"

    mem_to_mem_hazard dut (.mem_wb_dmo, .dmo, .wb_dmo_load_inst, .ex_mem_instruction, .mem_wb_instruction);

    // Set clock 
    parameter CLOCK_PERIOD= 100; 
    initial begin 
        logic clk <= 1; 
        forever #(CLOCK_PERIOD/2) clk <= ~clk; 
    end 
    // rs1	= instruction[19:15];  for register of source
    // rd  = instruction[11:7]; for register of load 


logic [3:0] store_type, load_type; 
// check to see if we need to overide 
always_comb begin 
    // funct_3	= instruction[14:12]; // checks what type stored and load 
        if ((ex_mem_instruction[6:0] == store) && (mem_wb_instruction[6:0] == load) && 
                (ex_mem_instruction[19:15] == mem_wb_instruction[11:7])) begin 


    // Set inputs for test 
    initial begin 
        @(posedge clk); 
        mem_wb_dmo <= 32'd100;
        dmo <= 32'd200;

        ex_mem_instruction [31:20] <= 12'd0; 
        ex_mem_instruction [19:15] <= 5'd5;  // store R5
        ex_mem_instruction [14:7] <= 8'd0; 
        ex_mem_instruction [6:0] <= store;  // store instruction 
        
        mem_wb_instruction [31:12] <= 20'd0; 
        mem_wb_instruction[11:7] <= 5'd5    // load R5                 
        mem_wb_instruction [6:0] <= load; // load instruction                                 
        @(posedge clk); // enables overwite, might print out mem_wb_dmo from dmo 
        
        // SB 
        ex_mem_instruction[14:2] <= SB; 
        @(posedge clk); 
        mem_wb_instruction[14:2] <= LB; 
        
        // SH
        @(posedge clk);
        ex_mem_instruction[14:2] <= SH;
        @(posedge clk); 
        mem_wb_instruction[14:2] <= LB;
        =@(posedge clk); 
        mem_wb_instruction[14:2] <= LBU; 

    
endmodule 
