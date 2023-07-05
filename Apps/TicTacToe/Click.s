; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process
;   HL = click position in tiles relative to window useful area top left, L = column, H = line

    ;ld      b, 1 ; player 1 (X)
    ; ld      b, 2 ; player 2 (O)
    ld      a, (iy + TICTACTOE_VARS.CURRENT_PLAYER)
    ld      b, a




    ld      a, l

    ; if (x == 0 || x == 1) isCol_0
    or      a
    jp      z, .isCol_0
    cp      1
    jp      z, .isCol_0

    ; if (x == 3 || x == 4) isCol_1
    cp      3
    jp      z, .isCol_1
    cp      4
    jp      z, .isCol_1

    ; if (x == 6 || x == 7) isCol_2
    cp      6
    jp      z, .isCol_2
    cp      7
    jp      z, .isCol_2

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

.isCol_1:

    ld      a, h

    ; if (y == 2 || y == 3) isCel_1_0
    cp      2
    jp      z, .isCel_1_0
    cp      3
    jp      z, .isCel_1_0

    ; if (y == 5 || y == 6) isCel_1_1
    cp      5
    jp      z, .isCel_1_1
    cp      6
    jp      z, .isCel_1_1

    ; if (y == 8 || y == 9) isCel_1_2
    cp      8
    jp      z, .isCel_1_2
    cp      9
    jp      z, .isCel_1_2

    ret

.isCol_2:

    ld      a, h

    ; if (y == 2 || y == 3) isCel_2_0
    cp      2
    jp      z, .isCel_2_0
    cp      3
    jp      z, .isCel_2_0

    ; if (y == 5 || y == 6) isCel_2_1
    cp      5
    jp      z, .isCel_2_1
    cp      6
    jp      z, .isCel_2_1

    ; if (y == 8 || y == 9) isCel_2_2
    cp      8
    jp      z, .isCel_2_2
    cp      9
    jp      z, .isCel_2_2

    ret


.isCel_0_0:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 0
    jp      .setCell

.isCel_0_1:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 3
    jp      .setCell

.isCel_0_2:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 6
    jp      .setCell

; ----

.isCel_1_0:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 1
    jp      .setCell

.isCel_1_1:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 4
    jp      .setCell

.isCel_1_2:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 7
    jp      .setCell

; ----

.isCel_2_0:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 2
    jp      .setCell

.isCel_2_1:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 5
    jp      .setCell

.isCel_2_2:
    ld      de, TICTACTOE_VARS.PLAYFIELD + 8
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



    ; alternate player for next turn
    ld      a, (iy + TICTACTOE_VARS.CURRENT_PLAYER)
    ; if (currentPlayer == 1) currentPlayer == 2 else currentPlayer == 1
    cp      1
    jp      z, .setPlayer_2

;setPlayer_1
    ld      a, 1
    jp      .continue

.setPlayer_2:
    ld      a, 2
.continue:
    ld      (iy + TICTACTOE_VARS.CURRENT_PLAYER), a





    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ret
