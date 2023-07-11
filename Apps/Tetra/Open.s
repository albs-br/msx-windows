; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    ld		hl, Tetra_Data.TILE_BLUE_pattern
    ld      de, Tetra_Data.TILE_BLUE_colors
    call    SET_CUSTOM_TILE

    ; debug
    ; ---load piece
    ; push    ix, iy
    ;     ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile) ; blue tile
    ;     ld      (iy + TETRA_VARS.CURRENT_PIECE), a
    ; pop     iy, ix

    push    iy ; DE = IY + TETRA_VARS.CURRENT_PIECE
    pop     hl
    ld      de, TETRA_VARS.CURRENT_PIECE
    add     hl, de
    ex      de, hl

    ld      hl, Tetra_Data.PIECE_SQUARE

    ld      b, 16
.loop:
    ld      a, (hl)
    or      a
    jp      z, .next

    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile) ; blue tile

.next:
    ld      (de), a
    inc     hl
    inc     de
    djnz    .loop

    ; init vars
    ld      a, 2
    ld      (iy + TETRA_VARS.PIECE_X), a
    
    ; push    iy ; HL = IY
    ; pop     hl
    
    ; ld      de, TETRA_VARS.PIECE_X
    ; add     hl, de

    ; ld      (hl), a
    
    ld      a, 0
    ld      (iy + TETRA_VARS.PIECE_Y), a


    ret
