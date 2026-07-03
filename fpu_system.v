`include "fpu_pkg.v"

module fpu_system(
    input clk,
    input reset_n,
    input data_ready,
    input wire[15:0] A, B,
    input wire[2:0] op,
    input acc,
    output reg[15:0] accumulate_register,
    output reg result_ready
    );

    wire[15:0] datapath_result;
    wire accumulate_register_enable;
    wire[15:0] input_a;
        assign input_a = acc ? accumulate_register : A;
        
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            accumulate_register <= 16'b0;
            result_ready <= 1'b0;
        end

        else if(data_ready && accumulate_register_enable) begin
            accumulate_register <= datapath_result;
            result_ready <= 1'b1;
        end
        
        else begin
            result_ready <= 1'b0;
        end
    end

    fpu_core fpuCore(
        .A(input_a),
        .B(B),
        .op(op),
        .result(datapath_result),
        .accumulate_enable(accumulate_register_enable)
    );

endmodule