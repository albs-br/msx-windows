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

    ; TODO
    ; check if new piece position is valid

    ld      a, (iy + TETRA_VARS.PIECE_X)
    inc     a
    ld      (iy + TETRA_VARS.PIECE_X), a

    ret