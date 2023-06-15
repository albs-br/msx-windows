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


ASCII_CODE_LOWERCASE_A: equ 97


; Check key combinations used by the OS
_READ_KEYBOARD:

    ; check if GRAPH (ALT) key is pressed
    ld      a, (BIOS_NEWKEY + 6)
    bit     2, a
    ret     nz

    ; L = BIOS_NEWKEY + 3, H = BIOS_NEWKEY + 4
    ld      hl, (BIOS_NEWKEY + 3)

    push    hl
        ; --- line 4
        bit     3, h ; 'N' key
        jp      z, .keyPressed_N

        bit     5, h ; 'P' key
        jp      z, .keyPressed_P

        ; --- line 3
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

.keyPressed_P:
    ; check if key was previously released
    ld      a, (OS.oldKeyboardMatrix + 4)
    bit     5, a ; 'P' key
    jp      z, .continue

    ; execute key pressed code here
    ld      hl, Paint.Header
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


; ; TODO: remove if not used
; ; Returns ASCII code of keypressed (only positive trnsition)
; ; Output:
; ;   A: ASCII code of key
; READ_KEYBOARD:

;     ; L = BIOS_NEWKEY + 3, H = BIOS_NEWKEY + 4
;     ld      hl, (BIOS_NEWKEY + 3)
    
;     ld      de, ASCII_CODES_KEYBOARD + (8 * 3)

;     xor     a ; ld      a, 0

;     bit     0, l
;     jp      z, .bit_0

;     bit     1, l
;     jp      z, .bit_1

;     bit     2, l
;     jp      z, .bit_2

;     bit     3, l
;     jp      z, .bit_3

;     bit     4, l
;     jp      z, .bit_4

;     bit     5, l
;     jp      z, .bit_5

;     bit     6, l
;     jp      z, .bit_6

;     bit     7, l
;     jp      z, .bit_7

;     ; ------

;     ld      a, 8

;     bit     0, h
;     jp      z, .bit_0

;     bit     1, h
;     jp      z, .bit_1

;     bit     2, h
;     jp      z, .bit_2

;     bit     3, h
;     jp      z, .bit_3

;     bit     4, h
;     jp      z, .bit_4

;     bit     5, h
;     jp      z, .bit_5

;     bit     6, h
;     jp      z, .bit_6

;     bit     7, h
;     jp      z, .bit_7


;     ; no key pressed
;     xor     a
;     ret

; .bit_0:
;     add     7
;     jp      .return

; .bit_1:
;     add     6
;     jp      .return

; .bit_2:
;     add     5
;     jp      .return

; .bit_3:
;     add     4
;     jp      .return

; .bit_4:
;     add     3
;     jp      .return

; .bit_5:
;     add     2
;     jp      .return

; .bit_6:
;     ; add 1
;     inc     a
;     jp      .return

; .bit_7:
;     ; add 0
;     jp      .return

; .return:

;     ld      h, 0
;     ld      l, a
;     add     hl, de
;     ld      a, (hl)

;     ret

; ASCII_CODE_A: equ 65
; ASCII_CODE_LOWERCASE_A: equ 97

; ASCII_CODES_KEYBOARD:
;     db   0,   0,   0,   0,   0,   0,   0,   0
;     db   0,   0,   0,   0,   0,   0,   0,   0
;     db   0,   0,   0,   0,   0,   0,   0,   0
;     db   ASCII_CODE_A + 9, ASCII_CODE_A + 8, ASCII_CODE_A + 7, ASCII_CODE_A + 6, ASCII_CODE_A + 5, ASCII_CODE_A + 4, ASCII_CODE_A + 3, ASCII_CODE_A + 2
;     db   ASCII_CODE_A + 17, ASCII_CODE_A + 16, ASCII_CODE_A + 15, ASCII_CODE_A + 14, ASCII_CODE_A + 13, ASCII_CODE_A + 12, ASCII_CODE_A + 11, ASCII_CODE_A + 10
;     db   0,   0,   0,   0,   0,   0,   0,   0
;     db   0,   0,   0,   0,   0,   0,   0,   0
;     db   0,   0,   0,   0,   0,   0,   0,   0
;     db   0,   0,   0,   0,   0,   0,   0,   0