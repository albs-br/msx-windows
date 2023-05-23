    INCLUDE "System/Window/DrawWindow.s"
    INCLUDE "System/Window/CloseWindow.s"
    INCLUDE "System/Window/ScreenMapping.s"



; Convert (col, line) in LH to linear addr (0-767), ie: (line * 32) + col
; Inputs:
;   L = column (0-31)
;   H = line (0-23)
; Output:
;   HL = linear addr (0-767)
_CONVERT_COL_LINE_TO_LINEAR:
	
	; from:
	;
	; |           Register H            |           Register L            |
	; |   0   0   0  Y4  Y3  Y2  Y1  Y0 |   0   0   0  X4  X3  X2  X1  X0 |
	;
	; to:
	;
	; |           Register H            |           Register L            |
	; |   0   0   0   0   0   0  Y4  Y3 |  Y2  Y1  Y0  X4  X3  X2  X1  X0 |
	; |   0   0   0   0   0   0  A9  A8 |  A7  A6  A5  A4  A3  A2  A1  A0 |

    xor     a           ; A = 0

    srl     h           ; shift right n, bit 0 goes to carry flag and bit 7 zeroed.
    rra                 ; rotates A to the right with the carry put into bit 7 and bit 0 put into the carry flag. 
    srl     h
    rra
    srl     h
    rra

    or      l           ; joins A7-A5 in A register to A4-A0 in L register
    ld      l, a

    ret


; Input:
;   IX = addr of process header
; Output:
;   HL = VRAM NAMTBL addr postition of top left of useful area 
;        of window (area that the process can use)
_GET_WINDOW_BASE_NAMTBL:

    ; get variables from process
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    add     hl, bc

    ret