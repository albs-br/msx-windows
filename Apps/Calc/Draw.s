; Input
;   IX = base addr of this process slot on RAM


    call    _GET_WINDOW_BASE_NAMTBL

    ld      bc, 1 ; go to one column right
    add     hl, bc

    ex      de, hl

    ; draw calc display
    push    de
        ld		hl, Calc_Data.CALC_DISPLAY_TILES                        ; RAM address (source)
        ; ;ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)		        ; VRAM address (destiny)
        ; ld		bc, 12	                                                ; Block length
        ; call 	BIOS_LDIRVM
        ld      b, 12   ; size of line
        ld      iyl, 2  ; number of lines
        call    DRAW_ON_WINDOW_USEFUL_AREA
    pop     hl


    ; draw calc keypad
    ld      bc, 32 * 2 ; two lines below
    add     hl, bc
    ex      de, hl                                                      ; DE = VRAM address (destiny)
    ld		hl, Calc_Data.CALC_KEYPAD_TILES                             ; HL = RAM address (source)
    ld      b, 12   ; size of line
    ld      iyl, 12 ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret
