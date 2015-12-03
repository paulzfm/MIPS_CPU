draw_single_line:
    ;R1 = col   
    ;R2 = row
    ;R3 = lenth
    ;R4 = type;0 1 2 3 4 5 6 7
    ;R5 = return address

    LI R6 0x90
    SLL R6 0x0
    SW R6 R0 0X0
    SW R6 R1 0X1
    SW R6 R2 0X2
    SW R6 R3 0X3
    SW R6 R4 0X4
    SW R6 R5 0X5


draw_single_line_point:
    MFPC R5
    ADDIU R5 0x3
    B drawpixis
    NOP
    BEQZ R3 draw_single_line_do_nothing
    NOP
    ADDIU R3 0xFF

    CMP r4 0x0
    BTEQZ single_line_case0
    NOP
    CMP r4 0x1
    BTEQZ single_line_case1
    NOP
    CMP r4 0x2
    BTEQZ single_line_case2
    NOP
    CMP r4 0x3
    BTEQZ single_line_case3
    NOP
    CMP r4 0x4
    BTEQZ single_line_case4
    NOP
    CMP r4 0x5
    BTEQZ single_line_case5
    NOP
    CMP r4 0x6
    BTEQZ single_line_case6
    NOP
    CMP r4 0x7
    BTEQZ single_line_case7
    NOP

    single_line_case0:
        ADDIU R2 0x1
        B draw_single_line_point
        NOP
    single_line_case1:
        ADDIU R1 0x1
        ADDIU R2 0x1
        B draw_single_line_point
        NOP
    single_line_case2:
        ADDIU R1 0x1
        B draw_single_line_point
        NOP
    single_line_case3:
        ADDIU R1 0x1
        ADDIU R2 0xFF
        B draw_single_line_point
        NOP
    single_line_case4:
        ADDIU R2 0xFF
        B draw_single_line_point
        NOP
    single_line_case5:
        ADDIU R1 0xFF
        ADDIU R2 0xFF
        B draw_single_line_point
        NOP
    single_line_case6:
        ADDIU R1 0xFF
        B draw_single_line_point
        NOP
    single_line_case7:
        ADDIU R1 0xFF
        ADDIU R2 0x1
        B draw_single_line_point
        NOP


    draw_single_line_do_nothing:
        LI R6 0x90
        SLL R6 0x0
        SW R6 R1 0xA
        SW R6 R2 0xB
        LW R6 R0 0X0
        LW R6 R1 0X1
        LW R6 R2 0X2
        LW R6 R3 0X3
        LW R6 R4 0X4
        LW R6 R5 0X5
        JR R5
        NOP
