
module halfAdder(
    input logic A, B, 
    output logic sum, carry
    );

    assign sum = A ^ B;
    assign carry = A & B;

endmodule
