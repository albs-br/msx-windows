; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ex      de, hl

    ; draw playfield
    ld		hl, TicTacToe_Data.PLAYFIELD_TILES        ; RAM address (source)
    ld      b, 8    ; size of line
    ld      c, 10   ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ; ; debug
    ; call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ; call    BIOS_SETWRT
    ; ld      a,  (ix + PROCESS_STRUCT_IX.vramStartTile)
    ; out     (PORT_0), a

    ; inc     a
    ; out     (PORT_0), a


    ; read playfield array and update screen
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 64 ; 2 lines below
    add     hl, de 
    ld      c, 3 ; 3 lines of playfield
    push    iy
        .loop_2:
            push    hl
                ld      b, 3 ; 3 columns of playfield
                .loop_1:
                    push    hl
                        ld      a, (iy + TICTACTOE_VARS.PLAYFIELD)
                        or      a
                        jp      z, .next

                        cp      1
                        jp      z, .draw_X

                        cp      2
                        jp      z, .draw_O

                    .next:
                    pop     hl

                    inc     iy
                    ld      de, 3
                    add     hl, de
                djnz    .loop_1
            pop     hl
            ld      de, 32 * 3 ; 3 lines below
            add     hl, de
        dec     c
        jp      nz, .loop_2
    pop     iy


    ret

.draw_O:
    ld      a,  (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     4
    jp      .drawPiece

.draw_X:

    ld      a,  (ix + PROCESS_STRUCT_IX.vramStartTile)
    jp      .drawPiece

.drawPiece:
    push    af
        call    BIOS_SETWRT
    pop     af

    out     (PORT_0), a

    ld      de, 32
    add     hl, de ;go to next line

    inc     a
    out     (PORT_0), a


    push    af
        call    BIOS_SETWRT
    pop     af

    ; ld      a,  (ix + PROCESS_STRUCT_IX.vramStartTile)

    inc     a
    out     (PORT_0), a

    nop
    nop
    nop
    inc     a
    out     (PORT_0), a

    jp      .next