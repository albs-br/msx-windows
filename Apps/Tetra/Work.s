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
    cp      30 ; game speed (eg. 30 - 90)
    jp      nz, .draw

    xor     a
    ld      (iy + TETRA_VARS.COUNTER), a

    ; ---- drop piece
    ld      d, (iy + TETRA_VARS.PIECE_X)
    ld      e, (iy + TETRA_VARS.PIECE_Y)
    inc     e
    ld      bc, TETRA_VARS.CURRENT_PIECE
    call    .isPiecePositionValid
    ; ret     z
    jp      z, .releasePiece

    inc     (iy + TETRA_VARS.PIECE_Y)

.draw:
    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ret

; ----------

.releasePiece:

    call    Tetra_Draw.ConvertPiece_XY_ToLinear

    ; HL += PLAYFIELD
    push    hl
        ld      de, TETRA_VARS.PLAYFIELD
        push    iy ; HL = IY
        pop     hl
        add     hl, de
    pop     de
    add     hl, de

    call    Tetra_Draw.PutPieceIntoPlayfield

    call    Tetra_Open.LoadRandomPiece

    jp      .draw

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
    ; check if key was previously released
    ld      a, (iy + TETRA_VARS.OLD_KEYBOARD_LINE_8)
    bit     4, a ; left key
    jp      z, .continue

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


    ; if (CURRENT_PIECE_TYPE == PIECE_TYPE_SQUARE) ret
    ld      a, (iy + TETRA_VARS.CURRENT_PIECE_TYPE)
    cp      TETRA_CONSTANTS.PIECE_TYPE_SQUARE
    jp      z, .continue

    push    hl, de
        call    .RotatePiece_Right

        ; check if new piece position is valid
        ld      d, (iy + TETRA_VARS.PIECE_X)
        ld      e, (iy + TETRA_VARS.PIECE_Y)
        ld      bc, TETRA_VARS.CURRENT_PIECE_TEMP
        call    .isPiecePositionValid

    pop     hl, de ; invert HL & DE
    jp      z, .continue

    ; CURRENT_PIECE = CURRENT_PIECE_TEMP
    ld      bc, 4 * 4
    ldir

    jp      .continue

; ----------

.piece_Left:

    ld      d, (iy + TETRA_VARS.PIECE_X)
    dec     d
    ld      e, (iy + TETRA_VARS.PIECE_Y)
    ld      bc, TETRA_VARS.CURRENT_PIECE
    call    .isPiecePositionValid
    ret     z

    dec     (iy + TETRA_VARS.PIECE_X)

    ret

.piece_Right:

    ld      d, (iy + TETRA_VARS.PIECE_X)
    inc     d
    ld      e, (iy + TETRA_VARS.PIECE_Y)
    ld      bc, TETRA_VARS.CURRENT_PIECE
    call    .isPiecePositionValid
    ret     z

    inc     (iy + TETRA_VARS.PIECE_X)

    ret

; ------------------------------------

; Check if new piece position is valid
; Inputs:
;   BC: delta addr of 4x4 piece matrix (TETRA_VARS.CURRENT_PIECE or TETRA_VARS.CURRENT_PIECE_TEMP)
;   D: piece x
;   E: piece y
; Output:
;   Z: not valid
;   NZ: valid
.isPiecePositionValid:

    ; save IX
    push    ix
    pop     hl
    ld      (OS.tempWord), hl

    ; IX = addr of linear position of piece on PLAYFIELD
    push      bc, de
        call      Tetra_Draw.ConvertPiece_DE_ToLinear

        ld        bc, TETRA_VARS.PLAYFIELD
        add       hl, bc
        
        push      hl ; IX = HL
        pop       ix
        
        push      iy ; BC = IY
        pop       bc

        add       ix, bc
    pop       de, bc

    ; --- loop through all tiles of the 4x4 current piece matrix
    ; ld      bc, TETRA_VARS.CURRENT_PIECE
    push    iy ; HL = IY
    pop     hl
    add     hl, bc

    ld      b, 0 ; matrix line counter 
.isPiecePositionValid_outerLoop:
        ld      c, 0 ; matrix column counter
    .isPiecePositionValid_innerLoop:
        ; check if this matrix position position has tile or is empty
        ld      a, (hl)
        or      a
        jp      z, .isPiecePositionValid_next

        ; ------- check if tile is inside playfield boundaries
        
        ; --- check X
        ld      a, d
        add     c

        ; if ((D + C) > 9) .return_Invalid
        cp      9 + 1
        jp      nc, .return_Invalid

        ; if ((D + C) < 0) .return_Invalid
        cp      0
        jp      c, .return_Invalid

        ; --- check Y
        ; if ((E + B) >= PLAYFIELD_HEIGHT) .return_Invalid
        ld      a, b
        add     e
        cp      TETRA_CONSTANTS.PLAYFIELD_HEIGHT
        jp      nc, .return_Invalid

        ; ------- check if tile is over an ocuppied playfield cell
        ld      a, (ix)
        or      a
        jp      nz, .return_Invalid

    .isPiecePositionValid_next:
        ; IX ++
        inc     ix

        inc     hl ; next piece matrix position

        inc     c
        ld      a, c
        cp      4
        jp      z, .isPiecePositionValid_nextLine

        jp      .isPiecePositionValid_innerLoop


.isPiecePositionValid_nextLine:
    ; IX += PLAYFIELD_WIDTH - 4
    push    bc
        ld      bc, TETRA_CONSTANTS.PLAYFIELD_WIDTH - 4
        add     ix, bc
    pop     bc

    inc     b
    ld      a, b
    cp      4
    jp      nz, .isPiecePositionValid_outerLoop

    ; if passed by all lines and columns and not found any invalid, return valid


    ; restore IX
    ld      ix, (OS.tempWord)

    ; return NZ (piece position is valid)
    xor     a
    inc     a
    ret

.return_Invalid:
    ; restore IX
    ld      ix, (OS.tempWord)

    xor     a
    ret

; ---------------------------------

; Inputs:
;	HL: source addr (matrix of 4x4 blocks)
;	DE: destiny addr (matrix of 4x4 blocks)
.RotatePiece_Right:

    ; if (CURRENT_PIECE_TYPE == PIECE_TYPE_I) rotatePiece_4x4 else rotatePiece_3x3
    ld      a, (iy + TETRA_VARS.CURRENT_PIECE_TYPE)
    cp      TETRA_CONSTANTS.PIECE_TYPE_I
    jp      nz, .rotatePiece_3x3_Right

	; --- Rotate piece 4x4
    push	ix, iy

        ; IX: source
        ; IY: dest
		push	hl ; IX = HL
		pop	    ix
		push	de ; IY = DE
		pop	    iy

		; line 0 to column 3
        ld      bc, 3 ; IY += 3
        add     iy, bc
		call	.RotatePiece_LineToCol

        inc     c ; BC = 4

		; line 1 to column 2
        add     ix, bc ; IX += 4
		dec	    iy ; IY--
		call	.RotatePiece_LineToCol

		; line 2 to column 1
        add     ix, bc ; IX += 4
		dec	    iy ; IY--
		call	.RotatePiece_LineToCol

		; line 3 to column 0
        add     ix, bc ; IX += 4
		dec	    iy ; IY--
		call	.RotatePiece_LineToCol

	pop	    iy, ix

	ret

.rotatePiece_3x3_Right:
	; --- Rotate piece 3x3
    push	ix, iy

        ; IX: source
        ; IY: dest
		push	hl ; IX = HL
		pop	    ix
		push	de ; IY = DE
		pop	    iy

		; line 0 to column 2
        ld      bc, 2 ; IY += 2
        add     iy, bc
		call	.RotatePiece_3x3_LineToCol

        inc     c ; BC = 4
        inc     c

		; line 1 to column 1
        add     ix, bc ; IX += 4
		dec	    iy ; IY--
		call	.RotatePiece_3x3_LineToCol

		; line 2 to column 0
        add     ix, bc ; IX += 4
		dec	    iy ; IY--
		call	.RotatePiece_3x3_LineToCol

        ; IY is positioned at top left of destiny matrix

        ; if first column is empty shift left the piece
        ; (piece should always be left aligned)
	    xor     a
        add     (iy + 0)
        add     (iy + 4)
        add     (iy + 8)
        jp      nz, .skip_ShiftPieceLeft

	    ; -- shift piece 1 position left
        ; first line
        ld	    a, (iy + 1) ; cell[0] = cell[1]
	    ld	    (iy + 0), a
        ld	    a, (iy + 2) ; cell[1] = cell[2]
	    ld	    (iy + 1), a
        xor     a           ; cell[2] = 0
	    ld	    (iy + 2), a

        ; second line
        ld	    a, (iy + 5)
	    ld	    (iy + 4), a
        ld	    a, (iy + 6)
	    ld	    (iy + 5), a
        xor     a
	    ld	    (iy + 6), a

        ; third line
        ld	    a, (iy + 9)
	    ld	    (iy + 8), a
        ld	    a, (iy + 10)
	    ld	    (iy + 9), a
        xor     a
	    ld	    (iy + 10), a

    .skip_ShiftPieceLeft:

        ; clear last column and last line
        xor     a
        ld	    (iy + 3), a
        ld	    (iy + 7), a
        ld	    (iy + 11), a
        ld	    (iy + 15), a
        ld	    (iy + 12), a
        ld	    (iy + 13), a
        ld	    (iy + 14), a


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

.RotatePiece_3x3_LineToCol:
	ld	    a, (ix + 0)
	ld	    (iy + 0), a

	ld	    a, (ix + 1)
	ld	    (iy + 4), a

	ld	    a, (ix + 2)
	ld	    (iy + 8), a

	ret