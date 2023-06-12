; Input
;   IX = base addr of this process slot on RAM


    call    _GET_WINDOW_BASE_NAMTBL

    ld      bc, 32 + 1
    add     hl, bc ; go to next line, one column right

    ex      de, hl

    ; draw calc display
    push    de
        ld		hl, Calc_Data.CALC_DISPLAY_TILES                        ; RAM address (source)
        ;ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)		        ; VRAM address (destiny)
        ld		bc, 12	                                                ; Block length
        call 	BIOS_LDIRVM
    pop     hl


    ; draw calc keypad
    ld      bc, 32
    add     hl, bc ; go to next line
    ex      de, hl                                                      ; DE = VRAM address (destiny)
    ld		hl, Calc_Data.CALC_KEYPAD_TILES                             ; HL = RAM address (source)
    ld      b, 12 ; size of line
    ld      c, 12 ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret
