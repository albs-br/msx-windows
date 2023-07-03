; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; ------- set custom tiles (tiles specific for this process)
    
    ; --- tile pattern
    ; calc PATTBL addr for custom tile
    ld      h, 0
    ld      l, (ix + PROCESS_STRUCT_IX.vramStartTile)

    add     hl, hl ; multiply HL by 8
    add     hl, hl
    add     hl, hl

    ld      c, PORT_0


    ; TODO: repeat for the 3 parts of the screen
    ex      de, hl
    push    de
        ld		hl, PATTBL
        add     hl, de

        call    BIOS_SETWRT

        ld      hl, TicTacToe_Data.TILE_X_pattern
        ld      b, TicTacToe_Data.TILE_X_pattern_size
    .innerLoop:
            outi
            jp      nz, .innerLoop ; this uses exactly 29 cycles (t-states)


    ; tile colors
    pop     de
    ld		hl, COLTBL
    add     hl, de

    call    BIOS_SETWRT

    ld      hl, TicTacToe_Data.TILE_X_colors
    ld      b, TicTacToe_Data.TILE_X_colors_size
.innerLoop_1:
        outi
        jp      nz, .innerLoop_1 ; this uses exactly 29 cycles (t-states)


    ret
