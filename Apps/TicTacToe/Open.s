; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    ld		hl, TicTacToe_Data.TILE_X_pattern_0
    ld      de, TicTacToe_Data.TILE_X_colors
    call    SET_CUSTOM_TILE

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    inc     a
    ld		hl, TicTacToe_Data.TILE_X_pattern_1
    ld      de, TicTacToe_Data.TILE_X_colors
    call    SET_CUSTOM_TILE

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     2
    ld		hl, TicTacToe_Data.TILE_X_pattern_2
    ld      de, TicTacToe_Data.TILE_X_colors
    call    SET_CUSTOM_TILE

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     3
    ld		hl, TicTacToe_Data.TILE_X_pattern_3
    ld      de, TicTacToe_Data.TILE_X_colors
    call    SET_CUSTOM_TILE



    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     4
    ld		hl, TicTacToe_Data.TILE_O_pattern_0
    ld      de, TicTacToe_Data.TILE_O_colors
    call    SET_CUSTOM_TILE

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     5
    ld		hl, TicTacToe_Data.TILE_O_pattern_1
    ld      de, TicTacToe_Data.TILE_O_colors
    call    SET_CUSTOM_TILE

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     6
    ld		hl, TicTacToe_Data.TILE_O_pattern_2
    ld      de, TicTacToe_Data.TILE_O_colors
    call    SET_CUSTOM_TILE

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     7
    ld		hl, TicTacToe_Data.TILE_O_pattern_3
    ld      de, TicTacToe_Data.TILE_O_colors
    call    SET_CUSTOM_TILE



    ; init playfield
    xor     a
    ld      b, 9
    push    iy
    .loop_1:
        ld      (iy + TICTACTOE_VARS.PLAYFIELD), a
        inc     iy
        djnz    .loop_1
    pop     iy


    ld      a, 1
    ld      (iy + TICTACTOE_VARS.CURRENT_PLAYER), a


    ; debug
    ; ld      a, 1
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD), a
    ; ld      a, 2
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 1), a
    ; ld      a, 1
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 2), a

    ; ld      a, 1
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 3), a
    ; ld      a, 2
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 4), a
    ; ld      a, 0
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 5), a

    ; ld      a, 1
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 6), a
    ; ld      a, 2
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 7), a
    ; ld      a, 1
    ; ld      (iy + TICTACTOE_VARS.PLAYFIELD + 8), a

    ret
