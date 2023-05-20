    INCLUDE "System/Mouse/DrawMouseCursor.s"
    INCLUDE "System/Mouse/MouseClick.s"



WAIT1:  equ   10              ; Short delay value
WAIT2:  equ   30              ; Long delay value


; Routine to read the mouse by direct accesses (works on MSX1/2/2+/turbo R)
;
; Input: DE = 01310h for mouse in port 1 (D = 00010011b, E = 00010000b)
;        DE = 06C20h for mouse in port 2 (D = 01101100b, E = 00100000b)
; Output: 
;   H = X-offset, L = Y-offset (H = L = 255 if no mouse)
;   IXH = button 1, IXL = button 2
GTMOUS:
	ld	    b, WAIT2	; Long delay for first read
	call	GTOFS2	; Read bits 7-4 of the x-offset

    ; get mouse buttons (IXH = button 1, IXL = button 2)
    ld      ix, 0
    bit     5, a
    jp      nz, .mouseButton_1_NotClicked
    ld      ixh, 1
.mouseButton_1_NotClicked:
    bit     4, a
    jp      nz, .mouseButton_2_NotClicked
    ld      ixl, 1
.mouseButton_2_NotClicked:

	and	    0x0F
	rlca
	rlca
	rlca
	rlca
	ld	    c, a
	call	GTOFST	; Read bits 3-0 of the x-offset
	and	    0x0F
	or	    c
	ld	    h, a	; Store combined x-offset
	call	GTOFST	; Read bits 7-4 of the y-offset
	and	    0x0F
	rlca
	rlca
	rlca
	rlca
	ld	    c, a
	call	GTOFST	; Read bits 3-0 of the y-offset
	and     0x0F
	or      c
	ld      l, a		; Store combined y-offset
	ret
 
GTOFST:	
	ld      b, WAIT1
GTOFS2:	
	ld      a, 15		; Read PSG register 15 for mouse
	;di		; DI useless if the routine is used during an interrupt
	out     (0xA0), a
	in      a, (0xA1) 
	and     0x80   ; preserve LED code/Kana state
	or      d            ; mouse1 x0010011b / mouse2 x1101100b
	out     (0xA1), a
	xor     e
	ld      d, a
 
	call    WAITMS	; Extra delay because the mouse is slow
 
	ld      a, 14
	out     (0xA0), a
	;ei		; EI useless if the routine is used during an interrupt
	in      a, (0xA2)
	ret
WAITMS:
	ld	    a, b
WTTR:
	djnz	WTTR
	db	0xED,0x55	; Back if Z80 (RETN on Z80, NOP on R800)
	rlca
	rlca
	ld	    b, a
WTTR2:
	djnz	WTTR2
	ld	    b, a	
WTTR3:
	djnz	WTTR3

	ret            

; Input:
;  E = delta X
;  D = delta Y
;  L = current X
;  H = current Y
; Output:
;  L = updated X
;  H = updated Y
CLIPADD:
    ; Make sure that mouse pointer stays inside visible screen area
    ld      a, l
    ld      b, e
    call    LIMITADD
    ld      l, a
    
    ld      a, h
    ld      b, d
    call    LIMITADD
    ld      h, a
    cp      191
    ret     c
    ld      h, 191
    ret
 
LIMITADD:
 
; Clip mouse pointer to 0..255
; In:  A = mouse position 0..255
;      B = mouse move -128..+127
; Out: A = new mouse position 0..255
 
 
	sub	    128		    ; move from range 0..255 to -128..+127
	add	    a, b		; add mouse offset, both numbers are signed
	jp	    pe, .CLIP	; pe -> previous instruction caused a signed overflow
	add	    a, 128		; move back to range 0..255
	ret			        ;
.CLIP:	
    ld	    a, b	; get mouse offset
	cpl	    		; flip all bits (only bit 7 matters)
	add	    a, a	; move bit 7 to carry flag
	sbc	    a, a	; carry set -> a=255   carry not set -> a=0
	ret	    		;
