NOP
NOP
LI R0 0x3
LI R1 0x50
LI R2 0x50
LI R3 0x70
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_complex_lines
NOP
NOP
NOP
LI R0 0x3
LI R1 0x60
LI R2 0xa0
LI R3 0x50
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_complex_lines
NOP
NOP
NOP
NOP
LI R0 0x3
LI R1 0x40
LI R2 0xf0
LI R3 0x90
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_complex_lines
NOP
NOP
NOP
NOP
LI R0 0x3
LI R1 0xd8
SLL R1 R1 0x1
LI R2 0x50
LI R3 0x60
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_complex_lines
NOP
NOP
    LI R0 0x3
    LI R1 0x75
    SLL R1 R1 0x2
    LI R2 0x50
    LI R3 0xa0
    LI R4 0x0
    MFPC R5
    ADDIU R5 0x2
    B draw_complex_lines
NOP
NOP
NOP
NOP
LI R0 0x3
LI R1 0xe0
SLL R1 R1 0x1
LI R2 0xa0
LI R3 0x50
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_complex_lines
NOP
NOP
NOP
    LI R0 0x3
    LI R1 0x83
    SLL R1 R1 0x2
    ADDIU R1 0x2
    LI R2 0xa0
    LI R3 0x50
    LI R4 0x0
    MFPC R5
    ADDIU R5 0x2
    B draw_complex_lines
NOP
NOP
NOP
NOP
LI R0 0x3
LI R1 0xd0
SLL R1 R1 0x1
LI R2 0xf0
LI R3 0x90
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_complex_lines
NOP
NOP
NOP
NOP
LI R0 0x3
LI R1 0xf0
LI R2 0xf0
LI R3 0x90
LI R4 0x2
MFPC R5
ADDIU R5 0x2
B draw_triangle
NOP
NOP
NOP
NOP
NOP
B 0xBE
NOP


draw_triangle:
    ;R1 = col   
    ;R2 = row
    ;R3 = lenth
    ;R4 = type;0 1 2 3 4 5 6 7
    ;R5 = return address
    LI R6 0x90
    SLL R6 R6 0x0
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
    AND R4 R0
    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    NOP


    ADDIU R4 0xFD
    AND R4 R0

    LI R6 0x94
    SLL R6 R6 0x0
    LW R6 R1 0x1
    LW R6 R2 0x2

    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    NOP

    
    draw_triangle_do_nothing:
        LI R6 0x90
        SLL R6 R6 0x0
        LW R6 R0 0x20
        LW R6 R1 0x21
        LW R6 R2 0x22
        LW R6 R3 0x23
        LW R6 R4 0x24
        LW R6 R5 0x25
        JR R5
        NOP
        
        
        
NOP
NOP
LI R0 0x1
LI R1 0x50
LI R2 0x50
LI R3 0x1
LI R4 0x7
LI R5 0x0
draw_complex_lines:
    ;R0 = border
    ;R1 = col   
    ;R2 = row
    ;R3 = lenth
    ;R4 = type;0 1 2 3 4 5 6 7
    ;R5 = return address
    LI R6 0x92
    SLL R6 R6 0x0
    SW R6 R1 0x01
    SW R6 R2 0x02
    SW R6 R3 0x03
    SW R6 R4 0x04
    SW R6 R5 0x05
    SW R6 R0 0x00

draw_complex_lines_line:
    NOP
    BEQZ R0 draw_complex_lines_do_nothing
    NOP
    MFPC R5
    ADDIU R5 0x3
    B draw_single_line
    NOP
    ADDIU R0 0xFF
    NOP
    NOP
    

    LI R6 0x0
    CMP r4 R6
    BTEQZ complex_line_case0
    NOP
    LI R6 0x1
    CMP r4 R6
    BTEQZ complex_line_case1
    NOP
    LI R6 0x2
    CMP r4 R6
    BTEQZ complex_line_case2
    NOP
    LI R6 0x3
    CMP r4 R6
    BTEQZ complex_line_case3
    NOP
    LI R6 0x4
    CMP r4 R6
    BTEQZ complex_line_case4
    NOP
    LI R6 0x5
    CMP r4 R6
    BTEQZ complex_line_case5
    NOP
    LI R6 0x6
    CMP r4 R6
    BTEQZ complex_line_case6
    NOP
    LI R6 0x7
    CMP r4 R6
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
        ADDIU R1 0xFF
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
        LI R6 0x92
        SLL R6 R6 0x0
        LW R6 R1 0x01
        LW R6 R2 0x02
        LW R6 R3 0x03
        LW R6 R4 0x04
        LW R6 R5 0x05
        LW R6 R0 0x00
        NOP
        NOP
        JR R5
        NOP
        
        
        
draw_single_line:
    ;R1 = col   
    ;R2 = row
    ;R3 = lenth
    ;R4 = type;0 1 2 3 4 5 6 7
    ;R5 = return address

    LI R6 0x93
    SLL R6 R6 0x0
    SW R6 R1 0x1
    SW R6 R2 0x2
    SW R6 R3 0x3
    SW R6 R4 0x4
    SW R6 R5 0x5
    SW R6 R0 0x0


draw_single_line_point:
    MFPC R5
    ADDIU R5 0x3
    B draw_pixis
    NOP
    BEQZ R3 draw_single_line_do_nothing
    NOP
    ADDIU R3 0xFF

    LI R0 0x0
    CMP r4 R0
    BTEQZ single_line_case0
    NOP
    LI R0 0x1
    CMP r4 R0
    BTEQZ single_line_case1
    NOP
    LI R0 0x2
    CMP r4 R0
    BTEQZ single_line_case2
    NOP
    LI R0 0x3
    CMP r4 R0
    BTEQZ single_line_case3
    NOP
    LI R0 0x4
    CMP r4 R0
    BTEQZ single_line_case4
    NOP
    LI R0 0x5
    CMP r4 R0
    BTEQZ single_line_case5
    NOP
    LI R0 0x6
    CMP r4 R0
    BTEQZ single_line_case6
    NOP
    LI R0 0x7
    CMP r4 R0
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
        LI R6 0x94
        SLL R6 R6 0x0
        SW R6 R1 0x1
        SW R6 R2 0x2
        LI R6 0x93
        SLL R6 R6 0x0
        LW R6 R0 0x0
        LW R6 R1 0x1
        LW R6 R2 0x2
        LW R6 R3 0x3
        LW R6 R4 0x4
        LW R6 R5 0x5
        NOP
        NOP
        JR R5
        NOP
        
        
draw_pixis:


    LI R6 0xE0
    SLL R6 R6 0x0000
    ADDIU R6 0x40
    SW R6 R1 0x0001
    SW R6 R2 0x0002
    SW R6 R3 0x0003
    SW R6 R4 0x0004
    SW R6 R5 0x0005


    MFPC R5
    ADDIU R5 0x0002
    B calc_vga_addr_data
    NOP
    
    LI R6 0x9F
    SLL R6 R6 0x0000
    LW R6 R2 0x0
    NOP
    NOP
    ADDU R4 R2 R4
    ;LI R6 0xF0
    ;LL R6 R6 0x0000
    ;ADDIU R6 0x40
    ;LW R6 R4 0x0004
    
    LI R5 0xBF
    SLL R5 R5 0x0000
    ; R3 = addr
    SW R5 R3 0x08
    ; R4 = data
    SW R5 R4 0x09


    LI R6 0xE0
    SLL R6 R6 0x0000
    ADDIU R6 0x40
    LW R6 R1 0x0001
    LW R6 R2 0x0002
    LW R6 R5 0x0005
    LW R6 R3 0x0003
    LW R6 R4 0x0004
    NOP
    NOP
    NOP
    NOP
    NOP
    JR R5
    NOP
    
    
calc_vga_addr_data:
    ; input R1 = col 0 - 639  R2 = row 0 - 479  
    ; output R3 = addr R4 = data should add 1 if want to the color is white
    ; use R6 R7 save R6 bf30

    LI R6 0xE0
    SLL R6 R6 0x0000
    ADDIU R6 0x10
    SW R6 R0 0x0000

    ; R3 = (R2 * 640 + R1) / 8
    ; R3 = R2 * 80 + R1 / 8
    ; R4 = (R2 * 640 + R1) mod 8
    ; R4 = R1 mod 8
    
    ; R7 = R1 / 8
    MOVE R6 R1
    SRA R6 R6 0x03
    ; R6 = 60 * R1
    MOVE R0 R2
    SLL R0 R0 0x0004
    ADDU R0 R6 R6 
    SLL R0 R0 0x0002
    ADDU R0 R6 R6
    ; R3 = R7
    MOVE R3 R6

    ; R7 = R1 mod 8
    ; R6 = (R1 >> 3)  << 3
    MOVE R6 R1
    MOVE R0 R1
    SRA R0 R0 0x0003
    SLL R0 R0 0x0003
    ; R7 = (R7 - R6) << 13
    SUBU R6 R0 R6
    SLL R6 R6 0x0000
    SLL R6 R6 0x0005
    ; R4 = R7
    MOVE R4 R6


    LI R6 0xE0
    SLL R6 R6 0x0000
    ADDIU R6 0x10
    LW R6 R0 0x0000

    JR R5
    NOP
