
module fpu_system(
    input clk,
    input reset_n,
    input logic data_ready,
    input logic[15:0] A, B, //I/O Registers
    input opcode_t op, //I/O Registers
    input acc, //I/O Registers
    output logic[15:0] accumulate_register, //Register in FPU_System 
    output logic result_ready
    );

    logic[15:0] datapath_result;
    logic accumulate_register_enable;
    logic[15:0] input_a;
        assign input_a = acc ? accumulate_register : A;
        
    always_ff @(posedge clk or negedge reset_n) begin
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