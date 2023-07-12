; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ex      de, hl

    ; draw empty playfield
    ld		hl, Tetra_Data.PLAYFIELD_TILES        ; RAM address (source)
    ld      b, 10    ; size of line
    ld      c, 20    ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ; ---- draw current piece
    ; adjust y position
    ld      h, 0
    ld      l, (iy + TETRA_VARS.PIECE_Y)
    add     hl, hl  ; multiply by 32
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    push    hl
        call    GET_USEFUL_WINDOW_BASE_NAMTBL
    pop     de
    add     hl, de
    

    ; adjust x position
    ld      d, 0
    ld      e, (iy + TETRA_VARS.PIECE_X)
    add     hl, de
    ld      de, 32  ; next line
    add     hl, de
    
    push    hl
        call    BIOS_SETWRT
        ;ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile) ; blue tile
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE)
        call    .drawPieceTile
        ; out     (PORT_0), a

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 1)
        call    .drawPieceTile
        ; out     (PORT_0), a

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 2)
        call    .drawPieceTile
        ; out     (PORT_0), a

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 3)
        call    .drawPieceTile
        ; out     (PORT_0), a
    pop     hl

    ld      de, 32  ; next line
    add     hl, de

    push    hl
        call    BIOS_SETWRT
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 4)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 5)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 6)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 7)
        call    .drawPieceTile
    pop     hl

    ld      de, 32  ; next line
    add     hl, de

    push    hl
        call    BIOS_SETWRT
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 8)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 9)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 10)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 11)
        call    .drawPieceTile
    pop     hl

    ld      de, 32  ; next line
    add     hl, de

    push    hl
        call    BIOS_SETWRT
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 12)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 13)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 14)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 15)
        call    .drawPieceTile
    pop     hl

    ; ; debug
    ; call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ; call    BIOS_SETWRT
    ; ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile) ; blue tile
    ; out     (PORT_0), a


    ret

.drawPieceTile:
    or      a
    jp      nz, .drawPieceTile_nz

    ld      a, TILE_EMPTY_BLACK

.drawPieceTile_nz:
    out     (PORT_0), a
    ret