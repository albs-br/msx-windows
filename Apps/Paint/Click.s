; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process
;   HL = click position in tiles relative to window useful area top left, L = column, H = line

    push    hl
        call    GET_MOUSE_POSITION_IN_TILES

        ; TODO
        ; check if user clicked left toolbar

        call    _CONVERT_COL_LINE_TO_LINEAR

        ld      bc, NAMTBL
        add     hl, bc



        call    BIOS_SETWRT
        ld      a, (iy + PAINT_VARS.CURRENT_COLOR)
        ; ld      a, TILE_EMPTY_BLACK
        out     (PORT_0), a
    pop     hl

    ; TODO: check if user clicked on toolbar buttons
    ; ld      a, h
    ; cp      2

    ret