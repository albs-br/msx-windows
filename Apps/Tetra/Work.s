; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process


    ; ld      a, 8                    ; 8th line
    ; call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix

    ld      a, (BIOS_NEWKEY + 8)

    push    af
        
        bit     7, a    ; check if right key is pressed
        jp      z, .keyPressed_Right

        bit     4, a    ; check if left key is pressed
        jp      z, .keyPressed_Left

        bit     5, a    ; check if up key is pressed
        jp      z, .keyPressed_Up

        .continue:

    pop     af

    ; update old keyboard state
    ld      (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8), a

    ; do below code only at each n frames
    ; ld      a, (BIOS_JIFFY)
    ; and     0011 1111 b
    ; jp      nz, .draw
    
    ld      a, (iy + TETRA_VARS.COUNTER)
    inc     a
    ld      (iy + TETRA_VARS.COUNTER), a
    cp      60
    jp      nz, .draw

    xor     a
    ld      (iy + TETRA_VARS.COUNTER), a

    ; ld      d, (iy + TETRA_VARS.PIECE_X)
    ; ld      e, (iy + TETRA_VARS.PIECE_Y)
    ; inc     e
    ; call    .isPiecePositionValid
    ; ret     z

    inc     (iy + TETRA_VARS.PIECE_Y)

.draw:
    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ret

; ---------

.keyPressed_Right:
    ; check if key was previously released
    ld      a, (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8)
    bit     7, a ; right key
    jp      z, .continue

    ; execute key pressed code here
    call    .piece_Right

    jp      .continue

.keyPressed_Left:
    ; ; check if key was previously released
    ; ld      a, (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8)
    ; bit     4, a ; left key
    ; jp      z, .continue

    ; execute key pressed code here
    call    .piece_Left

    jp      .continue

.keyPressed_Up:
    ; check if key was previously released
    ld      a, (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8)
    bit     5, a ; up key
    jp      z, .continue

    ; execute key pressed code here

    ; --- rotate piece

    ; HL = TETRA_VARS.CURRENT_PIECE
    push    iy
    pop     hl
    ld      de, TETRA_VARS.CURRENT_PIECE
    add     hl, de

    push    hl
        ; DE = TETRA_VARS.CURRENT_PIECE_TEMP
        push    iy
        pop     hl
        ld      de, TETRA_VARS.CURRENT_PIECE_TEMP
        add     hl, de
        ex      de, hl
    pop     hl

    push    hl, de
        call    .RotatePiece_Right
    pop     hl, de

    ; TODO:
    ; check if new piece position is valid

    ; CURRENT_PIECE = CURRENT_PIECE_TEMP
    ld      bc, 4 * 4
    ldir

    jp      .continue

; ----------

.piece_Left:

    ld      d, (iy + TETRA_VARS.PIECE_X)
    dec     d
    ld      e, (iy + TETRA_VARS.PIECE_Y)
    call    .isPiecePositionValid
    ret     z

    ; ld      a, (iy + TETRA_VARS.PIECE_X)
    ; dec     a
    ; ld      (iy + TETRA_VARS.PIECE_X), a

    dec     (iy + TETRA_VARS.PIECE_X)

    ; ; call "Draw" event of this process
    ; ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ; ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    ; call    JP_DE

    ret

.piece_Right:

    ld      d, (iy + TETRA_VARS.PIECE_X)
    inc     d
    ld      e, (iy + TETRA_VARS.PIECE_Y)
    call    .isPiecePositionValid
    ret     z

    ; ld      a, (iy + TETRA_VARS.PIECE_X)
    ; inc     a
    ; ld      (iy + TETRA_VARS.PIECE_X), a

    inc     (iy + TETRA_VARS.PIECE_X)

    ; ; call "Draw" event of this process
    ; ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ; ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    ; call    JP_DE

    ret

; Check if new piece position is valid
; Inputs:
;   D: piece x
;   E: piece y
; Output:
;   Z: not valid
;   NZ: valid
.isPiecePositionValid:

    ; --- loop through all tiles of the 4x4 current piece matrix
    ld      bc, TETRA_VARS.CURRENT_PIECE
    push    iy ; HL = IY
    pop     hl
    add     hl, bc

    ld      b, 4 * 4 ; matrix size
    ld      c, 0 ; matrix column counter
.isPiecePositionValid_loop:
    ; check if this matrix position position has tile or is empty
    ld      a, (hl)
    or      a
    jp      z, .isPiecePositionValid_next

    ; check if tile is inside playfield boundaries
    
    ; --- check X
    ; if ((D + C) > 9) .return_Z
    ld      a, d
    add     c
    cp      9 + 1
    jp      nc, .return_Z

    ; if ((D + C) < 0) .return_Z
    ld      a, d
    add     c
    cp      0
    jp      c, .return_Z

    ; ; --- check Y
    ; ; if ((E + (C >> 2)) >= PLAYFIELD_HEIGHT) .return_Z
    ; ld      a, c ; get column
    ; srl     a
    ; srl     a

    ; ld      a, e
    ; add     c
    ; cp      0
    ; jp      c, .return_Z



.isPiecePositionValid_next:
    inc     hl
    ld      a, c
    inc     a
    and     0000 0011 b ; keep in the 0-3 range
    ld      c, a
    djnz    .isPiecePositionValid_loop

    ; return NZ (piece position is valid)
    xor     a
    inc     a
    ret

.return_Z:
    xor     a
    ret

; ---------------------------------

; Inputs:
;	HL: source addr (matrix of 4x4 blocks)
;	DE: destiny addr (matrix of 4x4 blocks)
.RotatePiece_Right:

	push	ix, iy

		push	hl ; IX = HL
		pop	    ix
		push	de ; IY = DE
		pop	    iy

		; line 0 to column 3
		inc	    iy ; IY += 3
		inc	    iy
		inc	    iy
		call	.RotatePiece_LineToCol

		; line 1 to column 2
		inc	    ix ; IX+=4
		inc	    ix
		inc	    ix
		inc	    ix
		dec	    iy ; IY--
		call	.RotatePiece_LineToCol

		; line 2 to column 1
		inc	    ix ; IX+=4
		inc	    ix
		inc	    ix
		inc	    ix
		dec	    iy ; IY--
		call	.RotatePiece_LineToCol

		; line 3 to column 0
		inc	    ix ; IX+=4
		inc	    ix
		inc	    ix
		inc	    ix
		dec	    iy ; IY--
		call	.RotatePiece_LineToCol

	pop	    iy, ix

	ret

.RotatePiece_LineToCol:
	ld	    a, (ix + 0)
	ld	    (iy + 0), a

	ld	    a, (ix + 1)
	ld	    (iy + 4), a

	ld	    a, (ix + 2)
	ld	    (iy + 8), a

	ld	    a, (ix + 3)
	ld	    (iy + 12), a

	ret