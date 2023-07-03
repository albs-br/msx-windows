; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ex      de, hl

    ; draw playfield
    ld		hl, TicTacToe_Data.PLAYFIELD                        ; RAM address (source)
    ld      b, 8    ; size of line
    ld      c, 10   ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret
