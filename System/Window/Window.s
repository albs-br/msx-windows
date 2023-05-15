; Input
;   HL = addr of process header 
_DRAW_WINDOW:
    ; info: 9918 needs 29 cycles apart from each OUT
    
    ; get variables from process
    push    hl
    pop     ix
    ld      l, (ix + 2) ; process.x
    ld      h, (ix + 3) ; process.y
    
    ; ; debug
    ; ld      l, 10       ; col number (0-31)
    ; ld      h, 0       ; line number (0-23)

    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL
    add     hl, bc

    ; TODO:
    ; update process.screenTilesBehind

    ; TODO:
    ; update OS.screenMapping


    ; --------------- draw window title bar -----------------------
    



    ; first line of title bar
    ;ld  hl, NAMTBL + 10 + (0 * 32) ; DEBUG x=10, y=1
    push    hl
        call    BIOS_SETWRT
        
        ld      a, TILE_WINDOW_TITLE_TOP_LEFT
        out     (PORT_0), a

        ld      b, (ix + 4) ; process.width
        ;ld      b, 16       ; debug (window width)
    .loop_1:    
        ld      a, TILE_WINDOW_TITLE_MIDDLE_TOP
        out     (PORT_0), a
        djnz    .loop_1

        nop
        nop
        ld      a, TILE_WINDOW_TOP_RIGHT_CORNER_TOP
        out     (PORT_0), a
    pop     hl
    
    ; second line of title bar
    ld      de, 32
    add     hl, de
   
    push    hl
        call    BIOS_SETWRT
        ld      a, TILE_WINDOW_TITLE_BOTTOM_LEFT
        out     (PORT_0), a
        
        ld      a, (ix + 4) ; process.width
        sub     3
        ld      b, a
        ;ld      b, 16 - 3       ; debug (window width)
    .loop_2:
        ld      a, TILE_WINDOW_TITLE_MIDDLE_BOTTOM
        out     (PORT_0), a
        djnz    .loop_2

        nop
        nop
        ld      a, TILE_WINDOW_MINIMIZE_BUTTON
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_MAXIMIZE_BUTTON
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_CLOSE_BUTTON
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_TOP_RIGHT_CORNER_BOTTOM
        out     (PORT_0), a
    pop     hl

    ; draw name of process on window title
    push    hl, ix
        ; ld      bc, 32 - 1
        ; xor     a ; clear carry flag
        ; sbc     hl, bc
        inc     hl
        call    BIOS_SETWRT
        
        ld      b, 16 ; max size of string
    .loop_10:
        ld      a, (ix + 8) ; process.windowTitle
        or      a
        jp      z, .endLoop_10
        out     (PORT_0), a
        inc     ix
        djnz    .loop_10
    .endLoop_10:
    pop     ix, hl

    ; --------------- draw window middle borders and empty background -----------------------

    ld      a, (ix + 5) ; process.height
    sub     4           ; subtract 4 (2 from title and 2 from bottom)
    ld      b, a
    ;ld      b, 10 - 2 ; debug (window height)
.loop_height:
    push    bc

        ld      de, 32
        add     hl, de
    
        push    hl
            call    BIOS_SETWRT
            ld      a, TILE_WINDOW_BORDER_LEFT
            out     (PORT_0), a

            ld      b, (ix + 4) ; process.width
            ;ld      b, 16       ; debug (window width)
        .loop_3:
            ld      a, TILE_EMPTY
            out     (PORT_0), a
            djnz    .loop_3

            nop
            nop
            ld      a, TILE_WINDOW_BORDER_RIGHT
            out     (PORT_0), a
        pop     hl

    pop     bc
    djnz    .loop_height

    ; --------------- draw window bottom border and empty background -----------------------

    ; first line of window bottom
    ld      de, 32
    add     hl, de
   
    push    hl
        call    BIOS_SETWRT
        ld      a, TILE_WINDOW_BORDER_LEFT
        out     (PORT_0), a
        
        ld      b, (ix + 4) ; process.width
        ;ld      b, 16       ; debug (window width)
    .loop_4:
        ld      a, TILE_EMPTY
        out     (PORT_0), a
        djnz    .loop_4

        nop
        nop
        ld      a, TILE_WINDOW_RESIZE_CORNER_TOP
        out     (PORT_0), a
    pop     hl

    ; second line of window bottom
    ld      de, 32
    add     hl, de
   
    push    hl
        call    BIOS_SETWRT
        ld      a, TILE_WINDOW_BORDER_BOTTOM_LEFT
        out     (PORT_0), a
        
        ld      b, (ix + 4) ; process.width
        dec     b
        ;ld      b, 16 - 1       ; debug (window width)
    .loop_5:
        ld      a, TILE_WINDOW_BORDER_MIDDLE_BOTTOM
        out     (PORT_0), a
        djnz    .loop_5

        nop
        nop
        ld      a, TILE_WINDOW_RESIZE_CORNER_LEFT
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_RESIZE_CORNER_RIGHT
        out     (PORT_0), a
    pop     hl

    ; ---------------------------------------------



    ret



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
