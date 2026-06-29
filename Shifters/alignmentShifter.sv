module alignmentShifter(
    input logic[7:0] mantissa_in,
    input logic[4:0] shift_amt,
    output logic[7:0] mantissa_out,
    output logic G, R, S
    );

    logic[18:0] wide;
    logic[18:0] shifted;

    always_comb begin
        wide = {mantissa_in, 11'b0};

        if(shift_amt >= 5'd11) begin
            mantissa_out = 8'b0;
            
            G = 1'b0;
            R = 1'b0;
            S = |mantissa_in;
        end 
        
        else begin
            shifted = wide >> shift_amt;
            
            mantissa_out = shifted[18:11];
            G = shifted[10];
            R = shifted[9];
            S = |shifted[8:0];
        end
    end

endmodule