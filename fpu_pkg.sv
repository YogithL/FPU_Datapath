
package fpu_pkg;
    typedef enum logic[2:0]
    {
        ADD = 3'b000,
        SUB = 3'b001,
        MUL = 3'b010,
        DIV = 3'b011,
        NEG = 3'b100,
        ABS = 3'b101,
        SLT = 3'b110,
        NOP = 3'b111
    } opcode_t;

    typedef enum logic
    {
        ADD_EFF = 1'b0,
        SUB_EFF = 1'b1
    } eff_add_sub;
    
endpackage