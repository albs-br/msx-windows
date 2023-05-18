; Input
;   HL = addr of process header
_DRAW_WINDOW:
    ; info: 9918 needs 29 cycles apart from each OUT
    
    ; get variables from process
    push    hl
    pop     ix
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    ; ; debug
    ; ld      l, 10       ; col number (0-31)
    ; ld      h, 0       ; line number (0-23)

    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; TODO:
    ; update OS.screenMapping
    push    hl
        ex      de, hl
        ld      hl, OS.screenMapping
        add     hl, de
        
        ld      de, 32 ; next line

        ld      c, (ix + PROCESS_STRUCT_IX.height) ; process.height
    .outerLoop_1:
            push    hl
                ld      b, (ix + PROCESS_STRUCT_IX.width) ; process.width
            .loop_20:
                ld      a, 0x0a ; debug
                ld      (hl), a
                inc     hl
                djnz    .loop_20
            pop     hl

        add     hl, de
        dec     c
        jp      nz, .outerLoop_1

    pop     hl

    ; set HL to NAMTBL position of window top left
    ld      bc, NAMTBL
    add     hl, bc


    ; TODO:
    ; update process.screenTilesBehind


    ; --------------- draw window title bar -----------------------
    



    ; first line of title bar
    ;ld  hl, NAMTBL + 10 + (0 * 32) ; DEBUG x=10, y=1
    push    hl
        call    BIOS_SETWRT
        
        ld      a, TILE_WINDOW_TITLE_TOP_LEFT
        out     (PORT_0), a

        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     2 ; process.width - 2
        ld      b, a
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
        
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     5 ; process.width - 5
        ld      b, a
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
        inc     hl
        call    BIOS_SETWRT
        
        ld      b, 16 ; max size of string
    .loop_10:
        ld      a, (ix + PROCESS_STRUCT_IX.windowTitle) ; process.windowTitle
        or      a ; check for 0 meaning end of string
        jp      z, .endLoop_10
        out     (PORT_0), a
        inc     ix
        djnz    .loop_10
    .endLoop_10:
    pop     ix, hl

    ; --------------- draw window middle borders and empty background -----------------------

    ld      a, (ix + PROCESS_STRUCT_IX.height) ; process.height
    sub     4           ; subtract 4 (2 from title and 2 from bottom)
    ld      b, a
.loop_height:
    push    bc

        ld      de, 32
        add     hl, de
    
        push    hl
            call    BIOS_SETWRT
            ld      a, TILE_WINDOW_BORDER_LEFT
            out     (PORT_0), a

            ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
            sub     2 ; ; process.width - 2
            ld      b, a
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
        
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     2 ; ; process.width
        ld      b, a
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
        
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     3 ; ; process.width - 3
        ld      b, a
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
