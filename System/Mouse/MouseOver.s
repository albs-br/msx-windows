_MOUSE_OVER:

    ; get screenMapping value under mouse cursor
    ld      a, (OS.currentTileMouseOver)

    ; first check if the cursor is on desktop/taskbar
    cp      SCREEN_MAPPING_DESKTOP ; 255
    ret     z
    cp      SCREEN_MAPPING_TASKBAR ; 254
    ret     z


    ; get process id and put it in C
    and     0000 1111 b ; get low nibble
    ld      c, a

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

    ; get process addr
    call    _GET_PROCESS_BY_ID
    ret     nz

    ; ; ---- get close button position of this window on NAMTBL
        
    ;     ; set IX to process addr
    ;     push    hl
    ;     pop     ix
    ;     call    _GET_WINDOW_TITLE_BASE_NAMTBL
    ;     ; add width - n
    ;     ld      c, (ix + PROCESS_STRUCT_IX.width) ; process.width
    ;     ld      b, 0
    ;     add     hl, bc
        

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