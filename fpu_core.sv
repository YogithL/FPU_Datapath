
module fpu_core import fpu_pkg::*;(
    input logic[15:0] A, B,
    input opcode_t op,
    input logic acc,
    output logic[15:0] result,
    );

    //UNPACKING
    logic A_sign;
        assign A_sign = A[15];
    logic B_sign;
        assign B_sign = B[15];

    logic[7:0] A_exp;
        assign A_exp = A[14:7];
    logic[7:0] B_exp;
        assign B_exp = B[14:7];

    logic[6:0] A_mant;
        assign A_mant = A[6:0];
    logic[6:0] B_mant;
        assign B_mant = B[6:0];

    //ERROR FLAGS
    logic flag_A_NAN;
        assign flag_A_NAN = (A[14:6] == 9'h1FF); //(A_exp == 8'b255) && (A_mant[6] == 1'b1)
    logic flag_B_NAN;
        assign flag_B_NAN = (B[14:6] == 9'h1FF); //(B_exp == 8'b255) && (B_mant[6] == 1'b1)

    logic flag_overflow;
    logic flag_underflow;
    
    logic flag_div_by_zero;
        assign flag_div_by_zero = (op == DIV) && (A[14:0] != 0) && (B[14:0] == 0);
    logic flag_NAN; 
        assign flag_NAN = (flag_A_NAN || flag_B_NAN) ||
        // Infinity / Infinity
        ((op == DIV) && (A[14:0] == 15'h7F80) && (B[14:0] == 15'h7F80)) ||
        
        // 0 / 0
        ((op == DIV) && (A[14:0] == 15'h0000) && (B[14:0] == 15'h0000)) ||
        
        // 0 * Infinity or Infinity * 0
        ((op == MUL) && (A[14:0] == 15'h0000) && (B[14:0] == 15'h7F80)) ||
        ((op == MUL) && (A[14:0] == 15'h7F80) && (B[14:0] == 15'h0000)) ||
        
        // +Infinity + -Infinity
        ((op == ADD) && (A[14:0] == 15'h7F80) && (B[14:0] == 15'h7F80) && (A[15] != B[15])) ||
        
        // Infinity - Infinity
        ((op == SUB) && (A[14:0] == 15'h7F80) && (B[14:0] == 15'h7F80) && (A[15] == B[15]));                           
    
    //FINAL RESULT
    logic result_sign;
    logic[7:0] result_exp;
    logic[6:0] result_mant;

    //MAGNITUDE COMPARISON
    logic a_greater;
        assign a_greater = (A[14:0] > B[14:0]);
    logic a_b_equal;
        assign a_b_equal = (A[14:0] == B[14:0]);
    
    //SIGN GENERATION
    sign_gen signGen(
            .a_greater(a_greater),
            .a_b_equal(a_b_equal),
            .A_sign(A_sign),
            .B_sign(B_sign),
            .op(op),
            .sign(result_sign)
        );
    
    //ALIGNMENT FOR ADD/SUB
    logic[7:0] mantissa_to_align;
    logic[3:0] shift_amt;

    logic[7:0] larger_exp;
    logic[7:0] aligned_mant;
    logic[2:0] GRS;

    always_comb begin
        if(a_greater) begin
            shift_amt = A - B;
            mantissa_to_align = {1'b1, B_mant};   
            larger_exp = A_exp; 
        end

        else begin
            shift_amt = B - A;
            mantissa_to_align = {1'b1, A_mant};
            larger_exp = B_exp;
        end
    end

    alignmentShifter alignmentShifter(
            .mantissa_in(mantissa_to_align),
            .shift_amt(shift_amt),
            .mantissa_out(aligned_mant),
            .G(GRS[2]),
            .R(GRS[1]),
            .S(GRS[0])
        );
    
    //ADD/SUB MANTISSA CALC
    logic eff_sub;
    
    logic[10:0] mantissa_post_arth;
    logic[7:0] larger_mantissa = a_greater ? ({1'b1, A_mant}) : ({1'b1, B_mant});

    always_comb begin
    end

    









endmodule