NOP
NOP
LI R1 0x1
NOP
NOP

    LI R0 0xBF
    SLL R0 R0 0x0000
    ; write fifo2
    SW R0 R5 0x7
    NOP
    NOP
    LW R0 R2 0x5
    NOP
    NOP

SCANF:
    NOP
    NOP; you should MFPC to R1
    NOP; use R6 and return value save in R0
    LI R6 0x00BF 
    SLL R6 R6 0x0000 
    LW R6 R2 0x0005
    NOP
    NOP
    NOP
    NOP
    NOP
    BNEZ R2 SCANF
    LW R6 R0 0X0006
MYNOP:
NOP
NOP
NOP
NOP
NOP
NOP
NOP
B MYNOP
NOP
NOP