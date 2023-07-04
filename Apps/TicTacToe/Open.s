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

    ex      de, hl

    ld      b, 3 ; repeat for the 3 parts of the screen
.loop:
    push    bc
        ld		hl, PATTBL
        add     hl, de

        call    BIOS_SETWRT

        ld      hl, TicTacToe_Data.TILE_X_pattern
        ld      b, TicTacToe_Data.TILE_X_pattern_size
    .innerLoop:
            outi
            jp      nz, .innerLoop ; this uses exactly 29 cycles (t-states)


    ; tile colors
        ld		hl, COLTBL
        add     hl, de

        call    BIOS_SETWRT

        ld      a, (TicTacToe_Data.TILE_X_color)
        ld      b, TicTacToe_Data.TILE_X_pattern_size
    .innerLoop_1:
            out     (c), a
            dec     b
            jp      nz, .innerLoop_1 ; this uses more than 29 cycles (t-states)

        ; DE += 256 * 8
        ex      de, hl
            ld      de, 256 * 8
            add     hl, de
        ex      de, hl
    pop     bc

    djnz    .loop


    ; init playfield
    xor     a
    ld      b, 9
    push    iy
    .loop_1:
        ld      (iy + TICTACTOE_VARS.PLAYFIELD), a
        inc     iy
        djnz    .loop_1
    pop     iy


    ; debug
    ld      a, 1
    ld      (iy + TICTACTOE_VARS.PLAYFIELD), a
    ld      a, 2
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 1), a
    ld      a, 1
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 2), a

    ld      a, 1
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 3), a
    ld      a, 2
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 4), a
    ld      a, 0
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 5), a

    ld      a, 1
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 6), a
    ld      a, 1
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 7), a
    ld      a, 1
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 8), a

    ret
