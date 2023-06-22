    INCLUDE "System/Window/DrawWindow.s"
    INCLUDE "System/Window/CloseWindow.s"
    INCLUDE "System/Window/ScreenMapping.s"
    INCLUDE "System/Window/DrawOnWindowUsefulArea.s"



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
;   HL = VRAM NAMTBL addr position of top left of useful area 
;        of window (area that the process can use)
GET_USEFUL_WINDOW_BASE_NAMTBL:

    ; if (windowState == MAXIMIZED) ...
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MAXIMIZED
    jp      z, .isMaximized

    ; get variables from process
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    add     hl, bc

    ret

.isMaximized:
    ; if maximized, the position is NAMTBL + 32,
    ; as maximized windows has no borders
    ; and title is just one tile tall
    ld      hl, NAMTBL + 32

    ret



; Input:
;   IX = addr of process header
; Output:
;   HL = VRAM NAMTBL addr position of top left of window (title)
_GET_WINDOW_TITLE_BASE_NAMTBL:

    ; if (windowState == MAXIMIZED) the position is simply NAMTBL
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MAXIMIZED
    jp      z, .isMaximized

    ; get variables from process
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL
    add     hl, bc

    ret

.isMaximized:
    ld      hl, NAMTBL

    ret



; Input:
;   IX = addr of process header
; Output:
;   A = width in tiles (1-32)
GET_WINDOW_USEFUL_WIDTH:
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.RESTORED
    jp      z, .isRestored

    ; window maximized
    ld      a, 32
    
    ret

.isRestored:
    ld      a, (ix + PROCESS_STRUCT_IX.width)
    sub     2 ; 1 for left border, 1 for right border

    ret



; Input:
;   IX = addr of process header
; Output:
;   A = width in tiles (1-22)
GET_WINDOW_USEFUL_HEIGHT:

    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.RESTORED
    jp      z, .isRestored

    ; window maximized
    ld      a, 24 - 2 - 1 ; 2 for taskbar, 1 for title
    
    ret

.isRestored:
    ld      a, (ix + PROCESS_STRUCT_IX.height)
    sub     3 ; 2 for window title, 1 for window bottom

    ret



; TODO: test it
; Input:
;   IX = addr of process header
; Output:
;   A = last useful column (0-31)
GET_WINDOW_LAST_USEFUL_COLUMN:
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.RESTORED
    jp      z, .isRestored

    ; window maximized
    ld      a, 31
    
    ret

.isRestored:
    ld      a, (ix + PROCESS_STRUCT_IX.x)
    ld      b, (ix + PROCESS_STRUCT_IX.width)
    sub     4
    add     b

    ret



; Input:
;   IX = addr of process header
; Output:
;   HL = VRAM NAMTBL addr position of top RIGHT of useful area 
;        of window (area that the process can use)
GET_WINDOW_NAMTBL_LAST_USEFUL_COLUMN:

    ; if (windowState == MAXIMIZED) ...
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MAXIMIZED
    jp      z, .isMaximized

    ; get variables from process
    ld      a, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      b, (ix + PROCESS_STRUCT_IX.width)
    add     b
    sub     2 ; discount 2 columns of border right
    ld      l, a

    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL + (32 * 2); two lines below
    add     hl, bc

    ret


.isMaximized:
    ld      hl, NAMTBL + 32 + 31 ; last column of screen, one line below top

    ret
