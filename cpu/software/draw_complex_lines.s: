draw_complex_lines:
    ;R0 = border
    ;R1 = col   
    ;R2 = row
    ;R3 = lenth
    ;R4 = type;0 1 2 3 4 5 6 7
    ;R5 = return address
    LI R6 0x90
    SLL R6 0x0
    SW R6 R0 0X10
    SW R6 R1 0X11
    SW R6 R2 0X12
    SW R6 R3 0X13
    SW R6 R4 0X14
    SW R6 R5 0X15

draw_complex_lines_line:
    BEQZ R0 draw_complex_lines_do_nothing
    NOP
    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    NOP
    ADDIU R0 0xFF

    CMP r4 0x0
    BTEQZ complex_line_case0
    NOP
    CMP r4 0x1
    BTEQZ complex_line_case1
    NOP
    CMP r4 0x2
    BTEQZ complex_line_case2
    NOP
    CMP r4 0x3
    BTEQZ complex_line_case3
    NOP
    CMP r4 0x4
    BTEQZ complex_line_case4
    NOP
    CMP r4 0x5
    BTEQZ complex_line_case5
    NOP
    CMP r4 0x6
    BTEQZ complex_line_case6
    NOP
    CMP r4 0x7
    BTEQZ complex_line_case7
    NOP

    complex_line_case0:
        ADDIU R1 0x1
        B draw_complex_lines_line
        NOP
    complex_line_case1:
        ADDIU R1 0x1
        ADDIU R2 0xFF
        B draw_complex_lines_line
        NOP
    complex_line_case2:
        ADDIU R2 0xFF
        B draw_complex_lines_line
        NOP
    complex_line_case3:
        ADDIU R1 0xFF
        ADDIU R2 0xFF
        B draw_complex_lines_line
        NOP
    complex_line_case4:
        ADDIU R1 01F
        B draw_complex_lines_line
        NOP
    complex_line_case5:
        ADDIU R1 0xFF
        ADDIU R2 0x1
        B draw_complex_lines_line
        NOP
    complex_line_case6:
        ADDIU R2 0x1
        B draw_complex_lines_line
        NOP
    complex_line_case7:
        ADDIU R1 0x1
        ADDIU R2 0x1
        B draw_complex_lines_line
        NOP



    draw_complex_lines_do_nothing:
        LI R6 0x90
        SLL R6 0x0
        LW R6 R0 0X10
        LW R6 R1 0X11
        LW R6 R2 0X12
        LW R6 R3 0X13
        LW R6 R4 0X14
        LW R6 R5 0X15
        JR R5
        NOP