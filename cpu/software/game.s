NOP
NOP; you should MFPC to R1
NOP; use R6 and return value save in R0

SCANF:
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
    SW R6 R1 0x0001
    SW R6 R2 0x0002


loop_prefix_space:
    MFPC R1
    ADDIU R1 0x0002
    B SCANF
    NOP
    LI R2 0x20
    CMP R1 R2
    BTNEZ loop_prefix_space
    NOP
    MOVE R5 R1

loop_process_number:
    MFPC R1
    ADDIU R1 0x0002
    B SCANF
    NOP
    LI R2 0x20
    CMP R1 R2
    BTEQZ loop_process_fin
    NOP
    LI R2 0x30
    ; R1 = number
    SUBU R1 R2 R1
    ; R5 = R5 * 10 + R1
    MOVE R2 R5
    ADDU R5 R5 R5
    SLL R2 R2 0x03
    ADDU R5 R2 R5
    ADDU R5 R1 R5

    B loop_process_number
    NOP

loop_process_fin:
    ; reset register
    LI R6 0xD0
    SLL R6 R6 0x0000
    LW R6 R1 0x0001
    LW R6 R2 0x0002

    JR R1
    NOP


; clear 0xc0
; C0 for hardware int
LI R0 0xC0
SLL R0 R0 0x0000
LI R1 0x00
SW R0 R1 0x00
; E0 for hardware int
; E000 is length of list
; E001 is start of buffer
; each data has 4 length
LI R0 0xE0
SLL R0 R0 0x0000
LI R1 0x00
SW R0 R1 0x00



main:
    MFPC R1
    ADDIU R1 0x0002
    ; R1 = scanf
    B SCANF
    NOP
    ; R6 = 'l'
    ; R4 = bolder 4
    LI R4 0x02
    LI R6 0x6C
    CMP R6 R1
    BTNEZ draw_line
    NOP
    ; R6 = 'L'
    ; R4 = bolder 10
    LI R4 0x05
    LI R6 0x4C
    CMP R6 R1
    BTNEZ draw_line
    NOP

draw_line:
    ; R5 = bolder
    MFPC R1
    ADDIU R1 0x0002
    B read_int
    NOP



    B main
    NOP