	; OLDKEY:	equ $fbda ; Previous state of the keyboard matrix (11 bytes)
	; NEWKEY:	equ $fbe5 ; Current state of the keyboard matrix (11 bytes)
	;   	     OLDKEY  NEWKEY
	;   		    |      |
	; line 0	; $fbda, $fbe5 ; 7 6 5 4 3 2 1 0
	; line 1	; $fbdb, $fbe6 ; ; ] [ \ = - 9 8
	; line 2	; $fbdc, $fbe7 ; B A pound / . , ` '
	; line 3	; $fbdd, $fbe8 ; J I H G F E D C
	; line 4	; $fbde, $fbe9 ; R Q P O N M L K
	; line 5	; $fbdf, $fbea ; Z Y X W V U T S
	; line 6	; $fbe0, $fbeb ; F3 F2 F1 CODE CAP GRAPH CTRL SHIFT
	; line 7	; $fbe1, $fbec ; CR SEL BS STOP TAB ESC F5 F4
	; line 8	; $fbe2, $fbed ; RIGHT DOWN UP LEFT DEL INS HOME SPACE
	; line 9	; $fbe3, $fbee ; 4 3 2 1 0 none none none
	; line 10	; $fbe4, $fbef ; . , - 9 8 7 6 5


_READ_KEYBOARD:

    ; check if GRAPH (ALT) key is pressed
    ld      a, (BIOS_NEWKEY + 6)
    bit     2, a
    ret     nz

    ; L = BIOS_NEWKEY + 3, H = BIOS_NEWKEY + 4
    ld      hl, (BIOS_NEWKEY + 3)

    push    hl
        bit     3, h ; 'N' key
        jp      z, .keyPressed_N

        bit     0, l ; 'C' key
        jp      z, .keyPressed_C

        .continue:
    pop     hl


    ; update old keyboard state
    ld      (OS.oldKeyboardMatrix + 3), hl

    ret

.keyPressed_N:
    ; check if key was previously released
    ld      a, (OS.oldKeyboardMatrix + 4)
    bit     3, a ; 'N' key
    jp      z, .continue

    ; execute key pressed code here
    ld      hl, Notepad.Header
    call    _LOAD_PROCESS

    jp      .continue

.keyPressed_C:
    ; check if key was previously released
    ld      a, (OS.oldKeyboardMatrix + 3)
    bit     0, a ; 'C' key
    jp      z, .continue

    ; execute key pressed code here
    ld      hl, Calc.Header
    call    _LOAD_PROCESS

    jp      .continue


; _READ_KEYBOARD_____: 
;     call    .CHK
;     or      a
;     ret     z
              
;     ; execute key pressed code here
;     call    BIOS_BEEP

;     ret

; .CHK: 
;     ld	a,(OS.keyboardMatrix)		   ; saved value before current check, so = old status
;     ld	b,a
        
;     ld	a,(BIOS_NEWKEY + 8)	; Value stored by BIOS
;     cpl
;     and	10000000 b	   ; Keep only bit 7
;     ld	(OS.keyboardMatrix), a		   ; Saves press status

;     ld	c, a			           ; readed value again
;     and	b			   ; old value
;     xor	c			                        
;     ret


; Returns ASCII code of keypressed (only positive trnsition)
; Output:
;   A: ASCII code of key
call    READ_KEYBOARD
    ret