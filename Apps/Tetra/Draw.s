; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process



    ; ; draw empty playfield
    ; ld		hl, Tetra_Data.PLAYFIELD_TILES        ; RAM address (source)
    ; ld      b, 10    ; size of line
    ; ld      c, 20    ; number of lines
    ; call    DRAW_ON_WINDOW_USEFUL_AREA

    ; --- copy from playfield to playfield buffer

    ; set DE to destiny
    ld      de, TETRA_VARS.PLAYFIELD_BUFFER
    push    iy ; HL = IY
    pop     hl
    add     hl, de
    push    hl

        ; set HL to source
        ld      de, TETRA_VARS.PLAYFIELD
        push    iy ; HL = IY
        pop     hl
        add     hl, de
    pop     de
    
    ld      bc, TETRA_CONSTANTS.PLAYFIELD_WIDTH * TETRA_CONSTANTS.PLAYFIELD_HEIGHT
    ldir



    ; ---- draw current piece on playfield buffer
    
    call    .ConvertPiece_XY_ToLinear

    ; HL += PLAYFIELD_BUFFER
    push    hl
        ld      de, TETRA_VARS.PLAYFIELD_BUFFER
        push    iy ; HL = IY
        pop     hl
        add     hl, de
    pop     de
    add     hl, de
    

    call    .PutPieceIntoPlayfield



    ; draw playfield on screen from playfield buffer
    ld      de, TETRA_VARS.PLAYFIELD_BUFFER
    push    iy ; HL = IY
    pop     hl
    add     hl, de
    ex      de, hl

    push    de
        call    GET_USEFUL_WINDOW_BASE_NAMTBL
        ld      de, 32
        add     hl, de
    pop     de


    ld      c, TETRA_CONSTANTS.PLAYFIELD_HEIGHT    ; number of lines
.outerLoop_1:
    call    BIOS_SETWRT

    push    hl
            ld      b, TETRA_CONSTANTS.PLAYFIELD_WIDTH    ; size of line
        .loop_1:
            ld      a, (de)
            or      a
            jr      nz, .drawPlayfield_cont

            ld      a, TILE_EMPTY_BLACK
        .drawPlayfield_cont:
            out     (PORT_0), a
            inc     de
            djnz    .loop_1
    pop     hl

    ; HL += 32
    push    de
        ld      de, 32
        add     hl, de
    pop     de

    dec     c
    jp      nz, .outerLoop_1



    ret

; Input:
;   HL = piece linear position on playfield (it can be either PLAYFIELD or PLAYFIELD_BUFFER)
.PutPieceIntoPlayfield:
    ;push    hl
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 1)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 2)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 3)
        call    .drawPieceTile
    ;pop     hl

    ld      de, TETRA_CONSTANTS.PLAYFIELD_WIDTH - 4 ; next line
    add     hl, de

    ; push    hl
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 4)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 5)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 6)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 7)
        call    .drawPieceTile
    ; pop     hl

    ld      de, TETRA_CONSTANTS.PLAYFIELD_WIDTH - 4 ; next line
    add     hl, de

    ; push    hl
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 8)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 9)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 10)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 11)
        call    .drawPieceTile
    ; pop     hl

    ld      de, TETRA_CONSTANTS.PLAYFIELD_WIDTH - 4 ; next line
    add     hl, de

    ; push    hl
        ; call    BIOS_SETWRT
        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 12)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 13)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 14)
        call    .drawPieceTile

        ld      a, (iy + TETRA_VARS.CURRENT_PIECE + 15)
        call    .drawPieceTile
    ; pop     hl
    
    ret

.drawPieceTile:
    or      a
    jr      z, .drawPieceTile_ignore

.drawPieceTile_cont:
    ld      (hl), a
.drawPieceTile_ignore:
    inc     hl
    ret

; ------

; Input:
;   IY should point to process vars addr
; Output:
;   HL: linear addr of piece on playfield
.ConvertPiece_XY_ToLinear:

    ; adjust y position
    ; HL = PIECE_Y * PLAYFIELD_WIDTH
    ld      hl, 0
    ld      de, TETRA_CONSTANTS.PLAYFIELD_WIDTH
    ld      a, (iy + TETRA_VARS.PIECE_Y)
    or      a
    jp      z, .ConvertPiece_XY_ToLinear_skip_Mult
    ld      b, a
.ConvertPiece_XY_ToLinear_loop_Mult:
    add     hl, de
    djnz    .ConvertPiece_XY_ToLinear_loop_Mult    
.ConvertPiece_XY_ToLinear_skip_Mult:

    ; adjust x position
    ld      d, 0
    ld      e, (iy + TETRA_VARS.PIECE_X)
    add     hl, de

    ret