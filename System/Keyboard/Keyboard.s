	; OLDKEY:	equ $fbda ; Previous state of the keyboard matrix (11 bytes)
	; NEWKEY:	equ $fbe5 ; Current state of the keyboard matrix (11 bytes)
	;	 OLDKEY  NEWKEY
	;		|      |
	; 	; $fbda, $fbe5 ; 7 6 5 4 3 2 1 0
	; 	; $fbdb, $fbe6 ; ; ] [ \ = - 9 8
	; 	; $fbdc, $fbe7 ; B A pound / . , ` '
	; 	; $fbdd, $fbe8 ; J I H G F E D C
	; 	; $fbde, $fbe9 ; R Q P O N M L K
	; 	; $fbdf, $fbea ; Z Y X W V U T S
	; 	; $fbe0, $fbeb ; F3 F2 F1 CODE CAP GRAPH CTRL SHIFT
	; 	; $fbe1, $fbec ; CR SEL BS STOP TAB ESC F5 F4
	; 	; $fbe2, $fbed ; RIGHT DOWN UP LEFT DEL INS HOME SPACE
	; 	; $fbe3, $fbee ; 4 3 2 1 0 none none none
	; 	; $fbe4, $fbef ; . , - 9 8 7 6 5


_READ_KEYBOARD:

    ld      a, (BIOS_NEWKEY + 8)
    ld      b, a

    push    bc
        bit     7, b ; right arrow
        call    z, .keyPressed_R
    pop     bc

    push    bc
        bit     4, b ; left arrow
        call    z, .keyPressed_L
    pop     bc


    ; update old keyboard state
    ld      a, b
    ld      (OS.keyboardMatrix + 8), a

    ; ld      hl, (BIOS_NEWKEY + 0)
    ; ld      (OS.keyboardMatrix + 0), hl

    ret

.keyPressed_R:
    ; check if key was previously released
    ld      a, (OS.keyboardMatrix + 8)
    bit     7, a
    ret     z

    ; execute key pressed code here
    ; call    BIOS_BEEP
    ld      hl, Notepad.Header
    call    _LOAD_PROCESS

    ret

.keyPressed_L:
    ; check if key was previously released
    ld      a, (OS.keyboardMatrix + 8)
    bit     4, a
    ret     z

    ; execute key pressed code here
    ; ld      b, 20
    ; .test:
    ;     push    bc
    ;         call    BIOS_BEEP
    ;     pop bc
    ; djnz  .test
    ld      hl, Calc.Header
    call    _LOAD_PROCESS

    ret


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