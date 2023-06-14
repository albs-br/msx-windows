; Input
;   IX = base addr of this process slot on RAM

    call    READ_KEYBOARD
    or      a
    ret     z


    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; A = A - 65 + TILE_FONT_LOWERCASE_A
    ld      b, TILE_FONT_LOWERCASE_A - ASCII_CODE_A
    add     b
    ld      (hl), a
    
    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ; get base NAMTBL of the window
    ; ; push    hl ; ix = hl
    ; ; pop     ix
    ; ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ; ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    ; call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ld      bc, NAMTBL + (32 * 5) + 1 ; 5 lines below and one column right
    ; add     hl, bc

    ; call    _GET_WINDOW_BASE_NAMTBL


    ; ; debug
    ; ; write a test char (units of seconds from system time)

    ; ; two lines below
    ; ld      bc, 32 * 2
    ; add     hl, bc

    ; ld      de, TEST_NOTEPAD_WORK_EVENT_STRING
    ; call    _DRAW_STRING

    ; call    BIOS_SETWRT
    ; ld      a, (OS.currentTime_Seconds)
    ; and     0000 1111 b     ; get only low nibble (0-10 in BCD)

    ; ld      b, TILE_FONT_NUMBERS_0 + 0
    ; add     b
    ; out     (PORT_0), a

    ret


; TEST_NOTEPAD_WORK_EVENT_STRING: db 'N WORK', 0