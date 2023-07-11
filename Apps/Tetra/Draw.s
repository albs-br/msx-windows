; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ex      de, hl

    ; draw empty playfield
    ld		hl, Tetra_Data.PLAYFIELD_TILES        ; RAM address (source)
    ld      b, 10    ; size of line
    ld      c, 5     ; number of lines
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
    
    call    BIOS_SETWRT
    ;ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile) ; blue tile
    ld      a, (iy + TETRA_VARS.CURRENT_PIECE)
    out     (PORT_0), a

    ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 1)
    out     (PORT_0), a

    ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 2)
    out     (PORT_0), a

    ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 3)
    out     (PORT_0), a


    ; ; debug
    ; call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ; call    BIOS_SETWRT
    ; ld      a, (ix + PROCESS_STRUCT_IX.vramStartTile) ; blue tile
    ; out     (PORT_0), a


    ret
