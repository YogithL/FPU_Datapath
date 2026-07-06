import math

def make_lut_8bit():
    lut = []

    for i in range(128):
        val = 1.0 / (1.0 + i / 128.0)
        int_val = int(round(val * 256))
        
        if int_val > 255:
            int_val = 255
        
        lut.append(int_val)
    return lut


def round_half_even(x):
    floor = math.floor(x)
    frac = x - floor
    
    if frac < 0.5:
        return floor
    elif frac > 0.5:
        return floor + 1
    else:
        if floor % 2 == 0:
            return floor
        else:
            return floor + 1


def hardware_model(N_mant, D_mant, N_exp, D_exp, N_sign, D_sign, lut):
    R_sign = N_sign ^ D_sign
    R_exp = N_exp - D_exp + 127
    
    D_recip = lut[D_mant]
    
    Raw_mant = N_mant * D_recip

    #Align Mantissa
    Aligned_mant = Raw_mant
    
    if (Aligned_mant & 0x8000) == 0:
        Aligned_mant = Aligned_mant << 1
        R_exp = R_exp - 1
    
    #Normalize Mantissa
    sticky_bits = Aligned_mant & 0x003F
    
    if sticky_bits != 0:
        S = 1
    else:
        S = 0
        
    Aligned_mant = Aligned_mant >> 6
    Norm_mant = (Aligned_mant << 1) | S

    #Round Mantissa
    LGRS = Norm_mant & 0x0F
    Truncated_mant = Norm_mant >> 3

    if (LGRS & 0b0111 == 4):
        if (LGRS & 0x8 == 8):
            Round_mant = Truncated_mant + 1
        else:
            Round_mant = Truncated_mant
    elif (LGRS & 0b0111 > 4):
        Round_mant = Truncated_mant + 1
    else:
        Round_mant = Truncated_mant
    
    #Overflow check
    if Round_mant == 0x100:
        Round_mant = Round_mant >> 1  
        R_exp = R_exp + 1     

    #Final Result
    R_mant = Round_mant

    if R_exp >= 255:
        R_exp = 255  
    elif R_exp < 1:
        R_exp = 0

    return (R_sign << 15) | (R_exp << 7) | R_mant

    
    