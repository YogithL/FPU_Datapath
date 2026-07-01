
module sign_gen(
    input logic a_greater,
    input logic a_b_equal,
    input logic A_sign,
    input logic B_sign,
    input opcode_t op,
    output logic sign
    );

    always_comb begin
        case(op)
            DIV, MUL: sign = A_sign ^ B_sign;
            
            ADD: begin
                if(A_sign == B_sign)
                    sign = A_sign;
                else if(a_b_equal)
                    sign = 1'b0;
                else
                    sign = a_greater ? A_sign : B_sign;
            end
            
            SUB: begin
                if(A_sign != B_sign)
                    sign = A_sign;
                else if(a_b_equal)
                    sign = 1'b0;
                else
                    sign = a_greater ? A_sign : !B_sign;
            end
            
            NEG: sign = !A_sign;
            ABS: sign = 1'b0;
            SLT: sign = 1'b0;
            NOP: sign = 1'b0;
            
            default: sign = 1'b0;
        endcase
    end

endmodule