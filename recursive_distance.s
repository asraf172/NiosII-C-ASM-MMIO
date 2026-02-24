.global _start

_start:
    movia sp, 0x1000
    mov   r11, r0          # n = 0

    movia r8, NUM1
    ldw   r6, 0(r8)        # x1
    ldw   r7, 4(r8)        # y1 

    movia r8, NUM2 
    ldw   r9, 0(r8)        # x2
    ldw   r10, 4(r8)       # y2

    sub   r4, r10, r7
    bge   r4, r0, POS_Y
    sub   r4, r0, r4
POS_Y:
    mov   r5, r4
    call  MUL
    mov   r12, r2          # r12 = (y2-y1)^2


    sub   r4, r9, r6
    bge   r4, r0, POS_X 
    sub   r4, r0, r4
POS_X:
    mov   r5, r4
    call  MUL
    add   r12, r12, r2     # r12 = d^2

    mov   r10, r12         
    addi  r11, r11, 1      # n = 1
    call  COUNT_SEG        # r2 = תוצאה סופית


    movi  r13, 10
    blt   r2, r13, ONE_DIGIT


    call  DIVIDE           # r14=tens, r2=units
    br    DISPLAY_TWO

ONE_DIGIT:
    mov   r14, r0          # tens = 0

DISPLAY_TWO:
    movia r8, seven_seg

    # units → HEX0
    slli  r9, r2, 2
    add   r9, r8, r9
    ldw   r15, 0(r9)

    # tens → HEX1 
    slli  r9, r14, 2
    add   r9, r8, r9
    ldw   r16, 0(r9)
    slli  r16, r16, 8

    or    r15, r15, r16

    movia r17, 0x10000020
    stwio r15, 0(r17)

END:
    br END

COUNT_SEG:
    subi  sp, sp, 4
    stw   ra, 0(sp)

    mov   r4, r11
    mov   r5, r11
    call  MUL              # r2 = n^2

    bgt   r2, r10, BASE_CASE

    addi  r11, r11, 1
    call  COUNT_SEG
    addi  r2, r2, 1

    ldw   ra, 0(sp)
    addi  sp, sp, 4
    ret

BASE_CASE:
    mov   r2, r0
    ldw   ra, 0(sp)
    addi  sp, sp, 4
    ret


MUL:
    mov   r2, r0
MUL_LOOP:
    beq   r5, r0, MUL_RET
    andi  r3, r5, 1
    beq   r3, r0, SKIP
    add   r2, r2, r4
SKIP:
    slli  r4, r4, 1
    srli  r5, r5, 1
    br    MUL_LOOP
MUL_RET:
    ret


DIVIDE:
    movi  r13, 10
    mov   r4, r2
    mov   r14, r0          # tens = 0
DIV_LOOP:
    blt   r4, r13, DIV_END
    sub   r4, r4, r13
    addi  r14, r14, 1
    br    DIV_LOOP
DIV_END:
    mov   r2, r4           # units
    ret

NUM1:
    .word 1, 2
NUM2:
    .word 4,6

seven_seg:
    .word 0x3F   # 0
    .word 0x06   # 1
    .word 0x5B   # 2
    .word 0x4F   # 3
    .word 0x66   # 4
    .word 0x6D   # 5
    .word 0x7D   # 6
    .word 0x07   # 7
    .word 0x7F   # 8
    .word 0x6F   # 9

.end
