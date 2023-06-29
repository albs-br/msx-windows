; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; ; get RAM variables area of this process
    ; ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ; ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; push    hl ; IY = HL
    ; pop     iy

    ; cursor = 0
    xor     a
    ld      (iy + NOTEPAD_VARS.CURSOR_POSITION), a

    ; set empty text
    ld      a, TEXT_END_OF_FILE
    ld      (iy + NOTEPAD_VARS.TEXT_START), a

    ; clear keyboard buffer
    call    BIOS_KILBUF

    ; xor     a
    ; ld      (iy + NOTEPAD_VARS.KEYPRESSED), a


    ret
