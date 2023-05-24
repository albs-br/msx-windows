_MOUSE_OVER:

    ; get screenMapping value under mouse cursor
    ld      a, (OS.currentTileMouseOver)
    and     1111 0000 b ; get hi nibble

    cp      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
    jp      z, .over_WindowCloseButton

    ; restore button if mouse is no longer over it
    ; if (mouseOverCloseButton) .notOver_WindowCloseButton

    ret

.over_WindowCloseButton:

    ; if (mouseOverCloseButton) ret

    ; set flag mouseOverCloseButton to true

    ; update pattern and color of tile TILE_MOUSE_OVER

    ; ; ; NOT WORKING
    ; ; ; ; update NAMTBL of current mouse cursor position
    ; ; ; call    _MOUSE_XY_TO_NAMTBL
    ; ; ; call    BIOS_SETWRT
    ; ; ; ld      a, TILE_FONT_UPPERCASE_A + 1 ; 'B' ; debug
    ; ; ; out     (PORT_0), a

    ; get process id

    ; get close button position of this window on NAMTBL

    ; update NAMTBL
    ; call    BIOS_SETWRT
    ; ld      a, TILE_FONT_UPPERCASE_A + 1 ; 'B' ; debug
    ; out     (PORT_0), a

    ret

.notOver_WindowCloseButton:

    ; reset flag mouseOverCloseButton

    ; update NAMTBL of current mouse cursor position

    ret


_MOUSE_XY_TO_NAMTBL:
; convert mouse position in pixels (x, y) to tiles (col, line)
    ld      a, (OS.mouseY)
    ; dec     a       ; because of the Y + 1 TMS9918 bug

    ; divide by 8
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      h, a


    ld      a, (OS.mouseX)

    ; divide by 8
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      l, a


    call    _CONVERT_COL_LINE_TO_LINEAR

    ld      bc, NAMTBL
    add     hl, bc

    ret