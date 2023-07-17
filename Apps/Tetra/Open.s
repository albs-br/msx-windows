; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    xor     a
    ld		hl, Tetra_Data.TILE_pattern
    ld      de, Tetra_Data.TILE_BLUE_colors
    call    SET_CUSTOM_TILE

    ld      a, 1
    ld		hl, Tetra_Data.TILE_pattern
    ld      de, Tetra_Data.TILE_RED_colors
    call    SET_CUSTOM_TILE

    ; init empty playfield and playfield buffer
    ld      de, TETRA_VARS.PLAYFIELD
    push    iy ; HL = IY
    pop     hl
    add     hl, de
    push    hl
        ld      de, TETRA_VARS.PLAYFIELD_BUFFER
        push    iy ; HL = IY
        pop     hl
        add     hl, de
        ex      de, hl
    pop     hl
    xor     a
    ld      b, TETRA_CONSTANTS.PLAYFIELD_WIDTH * TETRA_CONSTANTS.PLAYFIELD_HEIGHT
.loop_1:
    ld      (hl), a
    ld      (de), a
    inc     hl
    inc     de
    djnz    .loop_1

    ; debug
    ; ---load piece

    ; ---- parameters
    ld      a, TETRA_CONSTANTS.PIECE_TYPE_SQUARE
    
    ;ld      hl, Tetra_Data.PIECE_SQUARE
    ; ld      hl, Tetra_Data.PIECE_I
    ld      hl, Tetra_Data.PIECE_L

    ; blue tile
    ld      c, (ix + PROCESS_STRUCT_IX.vramStartTile)
    
    ; ; red tile
    ; ld      c, (ix + PROCESS_STRUCT_IX.vramStartTile)
    ; inc     c


    ; --- subroutine

    ld      (iy + TETRA_VARS.CURRENT_PIECE_TYPE), a

    push    hl
        push    iy ; DE = IY + TETRA_VARS.CURRENT_PIECE
        pop     hl
        ld      de, TETRA_VARS.CURRENT_PIECE
        add     hl, de
        ex      de, hl
    pop     hl

    ld      b, 16
.loop:
    ld      a, (hl)
    or      a
    jp      z, .next

    ld      a, c

.next:
    ld      (de), a
    inc     hl
    inc     de
    djnz    .loop

    ; init vars
    ld      a, 2
    ld      (iy + TETRA_VARS.PIECE_X), a
    
    ld      a, 0
    ld      (iy + TETRA_VARS.PIECE_Y), a

    xor     a
    ld      (iy + TETRA_VARS.COUNTER), a

    ret

; Inputs:
;   A: piece type number
;   HL: addr of 4x4 matrix with piece
;   C: tile number
.LoadPiece:
    ret