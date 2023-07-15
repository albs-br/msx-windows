; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process


    
    ld      a, (BIOS_NEWKEY + 8)

    push    af
        
        bit     7, a    ; check if right key is pressed
        jp      z, .keyPressed_Right

        bit     4, a    ; check if left key is pressed
        jp      z, .keyPressed_Left

        .continue:

    pop     af

    ; update old keyboard state
    ld      (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8), a

    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ret

.keyPressed_Right:
    ; check if key was previously released
    ; ld      a, (OS.oldKeyboardMatrix + 8)
    ld      a, (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8)
    bit     7, a ; right key
    jp      z, .continue

    ; execute key pressed code here
    call    .piece_Right

    jp      .continue

.keyPressed_Left:
    ; TODO
    jp      .continue

.piece_Right:

    ld      d, (iy + TETRA_VARS.PIECE_X)
    inc     d
    ld      e, (iy + TETRA_VARS.PIECE_Y)
    call    .isPiecePositionValid
    ret     z

    ld      a, (iy + TETRA_VARS.PIECE_X)
    inc     a
    ld      (iy + TETRA_VARS.PIECE_X), a

    ret

; check if new piece position is valid
.isPiecePositionValid:

    ; --- loop through all tiles of the 4x4 current piece matrix
    ld      bc, TETRA_VARS.CURRENT_PIECE
    push    iy ; HL = IY
    pop     hl
    add     hl, bc

    ld      b, 4 ; 4x4 matrix line
    ld      c, 0 ; matrix column counter
.isPiecePositionValid_loop:
    ld      a, (hl)
    or      a
    jp      z, .isPiecePositionValid_next

    ; check if tile is inside playfield boundaries
    ; if ((D + C) > 9) .return_Z
    ld      a, d
    add     c
    cp      9
    jp      nc, .return_Z

.isPiecePositionValid_next:
    inc     hl
    inc     c
    djnz    .isPiecePositionValid_loop

    ; return NZ (piece position is valid)
    xor     a
    inc     a
    ret

.return_Z:
    xor     a
    ret