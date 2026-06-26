                    
module fullAdder(input logic A, B, Cin,
                 output logic sum, carry
                );

    assign sum = A ^ B ^ Cin;
    assign carry = (Cin & (A | B)) | (A & B);

endmodule

