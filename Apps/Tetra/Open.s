; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; init seed of random numbers
    ld      a, (BIOS_JIFFY)
    or      0x80
    ld      (Seed), a

    xor     a
    ld		hl, Tetra_Data.TILE_pattern
    ld      de, Tetra_Data.TILE_BLUE_colors
    call    SET_CUSTOM_TILE

    ld      a, 1
    ld		hl, Tetra_Data.TILE_pattern
    ld      de, Tetra_Data.TILE_RED_colors
    call    SET_CUSTOM_TILE

    ld      a, 2
    ld		hl, Tetra_Data.TILE_pattern
    ld      de, Tetra_Data.TILE_YELLOW_colors
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
    ld      de, TETRA_VARS.PLAYFIELD + 9 + (17*10)
    push    iy ; HL = IY
    pop     hl
    add     hl, de
    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    ld      (hl), a


    call    .LoadRandomPiece


    ; init vars
    xor     a
    ld      (iy + TETRA_VARS.COUNTER), a

    ret

; ------
.LoadRandomPiece:

    ; generate random number between 1 and 7
    call    RandomNumber
    and     0000 0111 b ; keep value in the 0-7 range
    or      a           ; repeat if A=0
    jp      z, .LoadRandomPiece

    cp      1
    jp      z, .loadPiece_Square

    cp      2
    jp      z, .loadPiece_L

    cp      3
    jp      z, .loadPiece_I

    ; TODO
    ; else ; debug
    jp      z, .loadPiece_I

    ret

.loadPiece_Square:
    ld      c, TETRA_CONSTANTS.PIECE_TYPE_SQUARE
    ld      hl, Tetra_Data.PIECE_SQUARE
    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)       ; blue tile
    call    .LoadPiece
    ret
    
.loadPiece_L:
    ld      c, TETRA_CONSTANTS.PIECE_TYPE_L
    ld      hl, Tetra_Data.PIECE_L
    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     2 ; yellow tile
    call    .LoadPiece
    ret

.loadPiece_I:
    ld      c, TETRA_CONSTANTS.PIECE_TYPE_I
    ld      hl, Tetra_Data.PIECE_I
    ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile)
    inc     a   ; red tile
    call    .LoadPiece
    ret
; TODO
; ---------

; Inputs:
;   C: piece type number
;   HL: addr of 4x4 matrix with piece
;   A: tile number
.LoadPiece:
    ld      (iy + TETRA_VARS.CURRENT_PIECE_TYPE), c
    ld      c, a

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


    ; init piece vars
    ld      a, 2
    ld      (iy + TETRA_VARS.PIECE_X), a
    
    ld      a, 0
    ld      (iy + TETRA_VARS.PIECE_Y), a

    ret