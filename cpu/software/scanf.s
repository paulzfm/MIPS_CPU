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