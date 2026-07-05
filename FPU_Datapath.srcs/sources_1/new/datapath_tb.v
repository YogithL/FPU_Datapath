`timescale 1ns / 1ps
`include "fpu_pkg.v"

module datapath_tb();
    reg clk;
    reg reset_n;
    reg data_ready;
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] op;
    reg acc;

    wire [15:0] accumulate_register;
    wire result_ready;
    wire flag_NAN;
    wire flag_overflow;
    wire flag_underflow;
    
    
    fpu_system dut(
        .clk(clk),
        .reset_n(reset_n),
        .data_ready(data_ready),
        .A(A),
        .B(B),
        .op(op),
        .acc(acc),
        .accumulate_register(accumulate_register),
        .result_ready(result_ready),
        .flag_NAN(flag_NAN),
        .flag_overflow(flag_overflow),
        .flag_underflow(flag_underflow)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        // Initialize signals
        reset_n = 0;
        data_ready = 0;
        A = 16'h0000;
        B = 16'h0000;
        op = 3'b000;
        acc = 0;
        
        @(negedge clk);
        reset_n = 1;
        
        //MUL: 2.0 * 3.0 = 6.0 (16'h40C0)
        @(negedge clk);
        A = 16'h4000;
        B = 16'h4080;
        op = `MUL; 
        data_ready = 1;
        
        @(negedge clk); 
        data_ready = 0;
        
        //DIV: 6.0 / 2.0 = 3.0 (16'h4080)
        @(negedge clk);
        A = 16'h40C0;
        B = 16'h4000;
        op = `DIV;
        data_ready = 1;
        
        @(negedge clk);
        data_ready = 0;
        
        //ADD: 2.0 + 3.0 = 5.0 (16'h40A0)
        @(negedge clk);
        A = 16'h4000;
        B = 16'h4080;
        op = `ADD;
        data_ready = 1;
        
        @(negedge clk); 
        data_ready = 0;

        //SUB: 5.0 - 2.0 = 3.0 (16'h4080)
        @(negedge clk); 
        A = 16'h40A0;
        B = 16'h4000;
        op = `SUB;
        data_ready = 1;
        
        @(negedge clk); 
        data_ready = 0;

        @(negedge clk); 
        $finish;
    end

endmodule
