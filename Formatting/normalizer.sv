
module normalizer(
    input logic[11:0] raw_in,
    input logic[8:0] exp_in,
    output logic[7:0] mantissa_out,
    output logic[8:0] exp_out,
    output logic G, R, S,
    output logic flag_underflow
    );

    logic[3:0] shift_amt;
    logic[11:0] shifted;
    logic flag_underflow;
        assign flag_underflow = shift_amt >= exp_in;

    always_comb begin
        if(raw_in[11]) begin
            shifted = raw_in >> 1;
            shifted[0] = raw_in[1] | raw_in[0];
            exp_out = exp_in + 9'd1;
        end
        
        else begin
            casez(raw_in[10:0])
                11'b1??????????: shift_amt = 4'd0;
                11'b01?????????: shift_amt = 4'd1;
                11'b001????????: shift_amt = 4'd2;
                11'b0001???????: shift_amt = 4'd3;
                11'b00001??????: shift_amt = 4'd4;
                11'b000001?????: shift_amt = 4'd5;
                11'b0000001????: shift_amt = 4'd6;
                11'b00000001???: shift_amt = 4'd7;
                11'b000000001??: shift_amt = 4'd8;
                11'b0000000001?: shift_amt = 4'd9;
                11'b00000000001: shift_amt = 4'd10;
                default: shift_amt = 4'd0;
            endcase

            shifted = raw_in << shift_amt;
            exp_out = exp_in - shift_amt;
        end

        mantissa_out = shifted[10:3];
        G = shifted[2];
        R = shifted[1];
        S = shifted[0];
    end

endmodule