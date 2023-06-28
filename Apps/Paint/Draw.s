; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ; if (windowState == MAXIMIZED) HL++
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MAXIMIZED
    jp      nz, .skip_1
    inc     hl
.skip_1:

    ex      de, hl

    ; draw paint left toolbar
    push    de
        ld		hl, Paint_Data.PAINT_TOOLBAR                        ; RAM address (source)
        ld      b, 3   ; size of line
        ld      c, 1 + 8 + 4 ; number of lines
        call    DRAW_ON_WINDOW_USEFUL_AREA
    pop     hl

    ret
