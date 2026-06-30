
module rounder(
    input logic[7:0] mantissa_in,
    input logic[8:0] exp_in,
    input logic G, R, S,
    output logic[7:0] mantissa_out,
    output logic[8:0] exp_out,
    output logic flag_overflow
    );

    logic round_up;
    logic[8:0] rounded_mantissa;
    logic flag_overflow;
        assign flag_overflow = exp_out[8] | (&exp_out[7:0]);

    always_comb begin
        round_up = G & (R | S | mantissa_in[0]);

        rounded_mantissa = {1'b0, mantissa_in} + {8'b0, round_up};

        if(rounded_mantissa[8]) begin
            mantissa_out = rounded_mantissa[8:1];
            exp_out = exp_in + 9'd1;
        end

        else begin
            mantissa_out = rounded_mantissa[7:0];
            exp_out = exp_in;
        end
    end

endmodule