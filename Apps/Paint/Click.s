; Input
;   IX = base addr of this process slot on RAM

    call    GET_MOUSE_POSITION_IN_TILES
    ; ; ---- convert mouse position in pixels (x, y) to tiles (col, line)
    ; ld      a, (OS.mouseY)
    ; ; dec     a       ; because of the Y + 1 TMS9918 bug

    ; ; divide by 8
    ; srl     a ; shift right n, bit 7 = 0, carry = 0
    ; srl     a ; shift right n, bit 7 = 0, carry = 0
    ; srl     a ; shift right n, bit 7 = 0, carry = 0
    ; ld      h, a


    ; ld      a, (OS.mouseX)

    ; ; divide by 8
    ; srl     a ; shift right n, bit 7 = 0, carry = 0
    ; srl     a ; shift right n, bit 7 = 0, carry = 0
    ; srl     a ; shift right n, bit 7 = 0, carry = 0
    ; ld      l, a

    call    _CONVERT_COL_LINE_TO_LINEAR

    ld      bc, NAMTBL
    add     hl, bc



    call    BIOS_SETWRT
    ld      a, TILE_EMPTY_BLACK
    out     (PORT_0), a
    
    ret