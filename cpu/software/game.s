; clear 0xc0
; C0 for hardware int
LI R0 0xC0
SLL R0 R0 0x0000
LI R1 0x00
SW R0 R1 0x00

; E0 for data list
; E000 is length of list
; E001 is start of buffer
; each data has 6 length

LI R0 0xE0
SLL R0 R0 0x0000
LI R1 0x00
SW R0 R1 0x00



main:
    B refresh_vga
    MFPC R1
    ADDIU R1 0x0002
    ; R1 = scanf
    B SCANF
    NOP
    ; R6 = 'l'
    ; R4 = bolder 4
    LI R5 0x00
    LI R4 0x02
    LI R6 0x6C
    CMP R6 R0
    BTEQZ draw_add_list
    NOP
    ; R6 = 'L'
    ; R4 = bolder 10
    LI R5 0x00
    LI R4 0x05
    LI R6 0x4C
    CMP R6 R0
    BTEQZ draw_add_list
    NOP

    ; R6 = 'r'
    ; R4 = bolder 10


    LI R5 0x01
    LI R4 0x05
    LI R6 0x72
    CMP R6 R0
    BTEQZ draw_add_list
    NOP

    ; R6 = 'R'
    ; R4 = bolder 10
    LI R5 0x01
    LI R4 0x05
    LI R6 0x52
    CMP R6 R0
    BTEQZ draw_add_list
    NOP

    ; R6 = 't'
    ; R4 = bolder 10
    LI R5 0x10
    LI R4 0x05
    LI R6 0x74
    CMP R6 R0
    BTEQZ draw_add_list
    NOP

    ; R6 = 'T'
    ; R4 = bolder 10
    LI R5 0x10
    LI R4 0x05
    LI R6 0x54
    CMP R6 R0
    BTEQZ draw_add_list
    NOP

    ; R6 = 'c'
    LI R6 0x63
    CMP R6 R0
    BTEQZ remove_list
    NOP

    B main
    
refresh_vga:
    
remove_list:
    LI R0 0xE0
    SLL R0 R0 0x0000
    LW R0 R2 0x00
    ADDIU R2 R2 0xFF
    LW R0 R2 0x00
    B main

draw_add_list:
    ; R4 = bolder

    ; R2 = list length * 6
    LI R0 0xE0
    SLL R0 R0 0x0000
    LW R0 R2 0x00
    MOVE R3 R2
    SLL R2 R2 0x02
    ADDU R2 R3 R2
    ADDU R2 R3 R2

    ; R3 = list start buffer
    LI R3 0xE0
    SLL R3 R3 0x0000
    ADDIU R3 0x01
    ADDU R3 R2 R3 

    ; R5 = type 0x00
    ; type 
    SW R3 R5 0x00
    ; R4 = bolder 0x01
    SW R3 R4 0x01

    ; startcol
    MFPC R1
    ADDIU R1 0x0002
    B read_int
    NOP
    SW R3 R5 0x02

    ; startrow
    MFPC R1
    ADDIU R1 0x0003
    B read_int
    NOP
    SW R3 R5 0x03

    ; endcol
    MFPC R1
    ADDIU R1 0x0002
    B read_int
    NOP
    SW R3 R5 0x04

    ; endrow
    MFPC R1
    ADDIU R1 0x0002
    B read_int
    NOP
    SW R3 R5 0x05

    B main
    NOP




SCANF:
    NOP
    NOP; you should MFPC to R1
    NOP; use R6 and return value save in R0
    LI R6 0x00BF 
    SLL R6 R6 0x0000 
    LW R6 R0 0x0005
    BEQZ R0 SCANF
    LW R6 R0 0X0006
    JR R1

NOP
NOP

read_int:
    ; return R5 = int 
    ; R1 = MFPC
    LI R6 0xD0
    SLL R6 R6 0x0000
    SW R6 R0 0x0000
    SW R6 R1 0x0001
    SW R6 R2 0x0002


    loop_prefix_space:
        MFPC R1
        ADDIU R1 0x0002
        B SCANF
        NOP
        LI R2 0x20
        CMP R0 R2
        BTEQZ loop_prefix_space
        NOP
        MOVE R5 R0
        LI R2 0x30
        SUBU R5 R2 R5

    loop_process_number:
        MFPC R1
        ADDIU R1 0x

        0002
        B SCANF
        NOP
        LI R2 0x20
        CMP R0 R2
        BTEQZ loop_process_fin
        NOP
        LI R2 0x30
        ; R0 = number
        SUBU R0 R2 R0
        ; R5 = R5 * 10 + R0
        MOVE R2 R5
        ADDU R5 R5 R5
        SLL R2 R2 0x03
        ADDU R5 R2 R5
        ADDU R5 R0 R5

        B loop_process_number
        NOP

    loop_process_fin:
        ; reset register
        LI R6 0xD0
        SLL R6 R6 0x0000
        LW R6 R0 0x0000
        LW R6 R1 0x0001
        LW R6 R2 0x0002


        JR R1
        NOP
