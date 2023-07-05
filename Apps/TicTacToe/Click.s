; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process
;   HL = click position in tiles relative to window useful area top left, L = column, H = line

    ;ld      b, 1 ; player 1 (X)
    ld      b, 2 ; player 2 (O)


    ld      a, l

    ; if (x == 0 || x == 1) isCol_0
    or      a
    jp      z, .isCol_0
    cp      1
    jp      z, .isCol_0

    ret

.isCol_0:

    ld      a, h

    ; if (y == 2 || y == 3) isCel_0_0
    cp      2
    jp      z, .isCel_0_0
    cp      3
    jp      z, .isCel_0_0

    ; if (y == 5 || y == 6) isCel_0_1
    cp      5
    jp      z, .isCel_0_1
    cp      6
    jp      z, .isCel_0_1

    ; if (y == 8 || y == 9) isCel_0_2
    cp      8
    jp      z, .isCel_0_2
    cp      9
    jp      z, .isCel_0_2

    ret

; .isCel_0_0:
;     ld      a, (iy + TICTACTOE_VARS.PLAYFIELD)
;     or      a
;     ret     nz
;     ld      (iy + TICTACTOE_VARS.PLAYFIELD), b
;     jp      .drawAndReturn

.isCel_0_0:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 0
    jp      .setCell

.isCel_0_1:
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 3), b
    jp      .setCell

.isCel_0_2:
    ld      (iy + TICTACTOE_VARS.PLAYFIELD + 6), b
    jp      .setCell

.setCell:
    push    iy  ; HL = IY
    pop     hl

    ; go to correct cell
    add     hl, de
    
    ; if cell is already occupied return
    ld      a, (hl)
    or      a
    ret     nz

    ld      (hl), b

    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE
    ret
