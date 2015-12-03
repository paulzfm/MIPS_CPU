draw_triangle:
    ;R1 = col   
    ;R2 = row
    ;R3 = lenth
    ;R4 = type;0 1 2 3 4 5 6 7
    ;R5 = return address
    LI R6 0x90
    SLL R6 0x0
    SW R6 R0 0x20
    SW R6 R1 0x21
    SW R6 R2 0x22
    SW R6 R3 0x23
    SW R6 R4 0x24
    SW R6 R5 0x25

    LI R0 0x07
    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    NOP

    ADDIU R4 0x02
    ADD R4 R0
    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    nop


    ADDIU R4 0xFD
    ADD R4 R0

    SW R6 R1 0xA
    SW R6 R2 0xB

    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    nop

    
    draw_triangle_do_nothing:
        LW R6 R0 0x20
        LW R6 R1 0x21
        LW R6 R2 0x22
        LW R6 R3 0x23
        LW R6 R4 0x24
        LW R6 R5 0x25
        JR R5
        NOP