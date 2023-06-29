; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    BIOS_CHSNS ; Tests the status of the keyboard buffer; Output: Zero flag set if buffer is empty, otherwise not set
    jp      z, .return ; ret     z

    call    BIOS_CHGET
    ; check lowercase ASCII chars (97-122)
    ; if (A < 97) ret
    cp      97
    ret     c
    ; if (A >= 122 + 1) ret
    cp      122 + 1
    ret     nc

    ; ld      d, a ; save char of keypressed



    ; ; if(keypressed) ret
    ; ld      a, (iy + NOTEPAD_VARS.KEYPRESSED)
    ; or      a
    ; ret     nz



    ; ld      a, 1
    ; ld      (iy + NOTEPAD_VARS.KEYPRESSED), a


    ; ld      a, d ; restore char of keypressed


    ; A = A - ASCII_CODE_LOWERCASE_A + TILE_FONT_LOWERCASE_A
    ld      b, TILE_FONT_LOWERCASE_A - ASCII_CODE_LOWERCASE_A
    add     b

    ; put A value in current cursor position
    ld      d, 0
    ld      e, (iy + NOTEPAD_VARS.CURSOR_POSITION)
    push    iy
        add     iy, de
        ld      (iy + NOTEPAD_VARS.TEXT_START), a
    pop     iy
    
    ; cursor++
    inc     (iy + NOTEPAD_VARS.CURSOR_POSITION)

    ; put TEXT_END_OF_FILE value in current cursor position
    ld      a, TEXT_END_OF_FILE
    ld      d, 0
    ld      e, (iy + NOTEPAD_VARS.CURSOR_POSITION)
    push    iy
        add     iy, de
        ld      (iy + NOTEPAD_VARS.TEXT_START), a
    pop     iy


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

.return:
    ; xor     a
    ; ld      (iy + NOTEPAD_VARS.KEYPRESSED), a

    ret