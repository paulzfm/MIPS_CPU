NOP
NOP
; save system registers
LI R7 0xBF
SLL R7 R7 0x0000
ADDIU R7 0x10
SW R7 R0 0x0000
SW R7 R1 0x0001
SW R7 R2 0x0002
SW R7 R3 0x0003
SW R7 R4 0x0004
SW R7 R5 0x0005
SW R7 R6 0x0006


; R0 = keyboard data 
LI R7 0xBF
SLL R7 R7 0x0000
LW R7 R0 0x0004
; LI R0 0x0A


; R1 = enter
LI R1 0x0A
; cmp R0 and enter
CMP R0 R1
BTEQZ enter_function
NOP
; R1 = slash
LI R1 0x08
; cmp R0 and slash
CMP R0 R1
BTEQZ slash_function
NOP


char_function:
    ; start of put R0 to next keyboard buffer

    ; R1 = data[0xC000] number of keyboard buffer
    LI R1 0xC0
    SLL R1 R1 0x0000
    LW R1 R1 0x0000

    ; R2 = 0xC001 start of keyboard buffer
    LI R2 0xC0
    SLL R2 R2 0x0000
    ADDIU R2 0x01

    ; R4 = R2 + R1 
    ADDU R1 R2 R4
    SW R4 R0 0x0000

    ; R5 = 0xC000
    LI R5 0xC0
    SLL R5 R5 0x0000
    ; R1 = R1 + 1
    ADDIU R1 0x01
    SW R5 R1 0x0000



    B enter_vga_flush
    NOP

slash_function:
    ; R1 = data[0xC000] number of keyboard buffer
    LI R1 0xC0
    SLL R1 R1 0x0000
    LW R1 R1 0x0000


    ; R2 = 0
    LI R2 0x00
    CMP R1 R2

    ; not equal R1 != 0
    BTEQZ enter_vga_flush
    NOP

    ; R1 = R1 + 1
    ADDIU R1 0xFF
    ; R5 = 0xC000
    LI R5 0xC0
    SLL R5 R5 0x0000
    SW R5 R1 0x0000

    B enter_vga_flush
    NOP


enter_function:
    ; R1 = data[0xC000] number of keyboard buffer
    LI R1 0xC0
    SLL R1 R1 0x0000
    LW R1 R1 0x0000
    ; R2 = 0xC001 start of keyboard buffer
    LI R2 0xC0
    SLL R2 R2 0x0000
    ADDIU R2 0x01
    ; R3 = offset of R2, init = 0, end = R1
    LI R3 0x00

enter_send_to_fifo2_loop:
    CMP R3 R1
    BTEQZ enter_send_to_fifo2_fin
    NOP
    ; finish send to fifo2

    ; R4 = R2 + R3
    ADDU R2 R3 R4
    ; R5 = data[R4] = data[R2 + R3]
    LW R4 R5 0x0000
    ; R0 = bf07
    LI R0 0xBF
    SLL R0 R0 0x0000
    ADDIU R0 0x07
    ; write fifo2
    SW R0 R5 0x0000
    ADDIU R3 0x01
    B enter_send_to_fifo2_loop
    NOP
    ; reset number
enter_send_to_fifo2_fin:
    ; write an extra space
    LI R0 0xBF
    SLL R0 R0 0x0000
    ADDIU R0 0x07
    LI R5 0x20
    SW R0 R5 0x0000
    ; reset length c000
    LI R2 0x00
    LI R1 0xC0
    SLL R1 R1 0x0000
    SW R1 R2 0x00


enter_vga_flush:
    ; R1 = 0 - 639 init [10, 610) column
    ; R2 = 0 - 479 init [450, 470) row
    ; each symbol is 20 * 20

    ; R1 = 10
    LI R1 0x0A

    ; R0 = 470
    LI R0 0xEB
    SLL R0 R0 0x01
    

clear_vga_bottom:
    ; R5 = 610 0b1001100010
    LI R5 0x98
    SLL R5 R5 0x02
    ADDIU R5 0x02
    ; R1 = R5 = 610 end
    CMP R1 R5
    BTEQZ draw_char_start
    NOP
    ; R2 = 450
    LI R2 0xE1
    SLL R2 R2 0x0001
clear_column:
    ; clear R1 R2 pixis
    MFPC R5
    ADDIU R5 0x0002
    B calc_vga_addr_data
    NOP
    ; R5 = bf00
    LI R5 0xBF
    SLL R5 R5 0x0000
    ; R3 = addr
    SW R5 R3 0x08
    ; R4 = data
    SW R5 R4 0x09

    ; R2 = R2 + 1 and cmp
    ADDIU R2 0x01
    ; R2 = R0 = 470
    CMP R2 R0
    BTNEZ clear_column
    NOP
add_row:
    ADDIU R1 0x01
    B clear_vga_bottom
    NOP

calc_vga_addr_data:
    ; input R1 = col 0 - 639  R2 = row 0 - 479  
    ; output R3 = addr R4 = data should add 1 if want to the color is white
    ; use R6 R7 save R6 bf30

    LI R7 0xBF
    SLL R7 R7 0x0000
    ADDIU R7 0x30
    SW R7 R6 0x0000

    ; R3 = (R1 * 480 + R2) / 8
    ; R3 = R1 * 60 + R2 / 8
    ; R4 = (R1 * 480 + R2) mod 8
    ; R4 = R2 mod 8
    
    ; R7 = R2 / 8
    MOVE R7 R2
    SRA R7 R7 0x03
    ; R6 = 60 * R1
    MOVE R6 R1
    SLL R6 R6 0x0002
    ADDU R6 R7 R7 
    SLL R6 R6 0x0001
    ADDU R6 R7 R7
    SLL R6 R6 0x0001
    ADDU R6 R7 R7
    SLL R6 R6 0x0001
    ADDU R6 R7 R7
    ; R3 = R7
    MOVE R3 R7

    ; R7 = R2 mod 8
    ; R6 = (R2 >> 3)  << 3
    MOVE R7 R2
    MOVE R6 R2
    SRA R6 R6 0x0003
    SLL R6 R6 0x0003
    ; R7 = (R7 - R6) << 13
    SUBU R7 R6 R7
    SLL R7 R7 0x0000
    SLL R7 R7 0x0005
    ; R4 = R7
    MOVE R4 R7


    LI R7 0xBF
    SLL R7 R7 0x0000
    ADDIU R7 0x30
    LW R7 R6 0x0000

    JR R5
    NOP

draw_char_start:
    ; R0 = data[0xC000] number of keyboard buffer
    
    ;  0xC001 start of keyboard buffer
    ; LI R0 0xC0
    ; SLL R0 R0 0x0000
    ; ADDIU R0 0x01
    ; R6 = offset = 0
    LI R6 0x00

    ; R1 = 0 - 639 init [10, 610) column
    ; R2 = 0 - 479 init [450, 470) row
    ; each symbol is 20 * 20
    LI R1 0x0A
    LI R2 0xE1
    SLL R2 R2 0x0001


draw_char_loop:
    LI R0 0xC0
    SLL R0 R0 0x0000
    LW R0 R0 0x0000
    CMP R6 R0
    BTEQZ prepare_exit
    NOP

    ; R3 R4 offset of pixis
    LI R3 0x00
    LI R4 0x00
    MFPC R5
    ADDIU R5 0x0002
    B draw_pixis
    NOP

    LI R3 0x01
    LI R4 0x01
    MFPC R5
    ADDIU R5 0x0002
    B draw_pixis
    NOP

    LI R3 0x02
    LI R4 0x02
    MFPC R5
    ADDIU R5 0x0002
    B draw_pixis
    NOP
    
    ADDIU R6 0x0001
    ADDIU R1 0x0014
    B draw_char_loop
    NOP

draw_pixis:
    ; SAVE R1 R2 R5
    ; USE R1 R2 R3 R4 R5 R7
    ; change R7

    LI R7 0xBF
    SLL R7 R7 0x0000
    ADDIU R7 0x40
    SW R7 R1 0x0000
    SW R7 R2 0x0001
    SW R7 R5 0x0002


    ADDU R1 R3 R1
    ADDU R2 R4 R2
    MFPC R5
    ADDIU R5 0x0002
    B calc_vga_addr_data
    NOP
    ADDIU R4 0x0001

    LI R5 0xBF
    SLL R5 R5 0x0000
    ; R3 = addr
    SW R5 R3 0x08
    ; R4 = data
    SW R5 R4 0x09


    LI R7 0xBF
    SLL R7 R7 0x0000
    ADDIU R7 0x40
    LW R7 R1 0x0000
    LW R7 R2 0x0001
    LW R7 R5 0x0002
    JR R5
    NOP



prepare_exit:
    ; load system registers
    LI R7 0xBF
    SLL R7 R7 0x0000
    ADDIU R7 0x10
    LW R7 R0 0x0000
    LW R7 R1 0x0001
    LW R7 R2 0x0002
    LW R7 R3 0x0003
    LW R7 R4 0x0004
    LW R7 R5 0x0005
    LW R7 R6 0x0006


