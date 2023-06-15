; Input
;   IX = base addr of this process slot on RAM

    ; get variables from process
    ; ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ; ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    ; call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    ; add     hl, bc

    ; --- draw vertical scrollbar
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.RESTORED
    jp      z, .isRestored_1

    ; window maximized
    ld      hl, NAMTBL + 32 + 31 ; last column of second line
    jp      .cont_1

.isRestored_1:
    call    _GET_WINDOW_BASE_NAMTBL
    ld      b, 0
    ld      c, (ix + PROCESS_STRUCT_IX.width)
    add     hl, bc
    ld      bc, -3 ; back 3 cols (one for left border, two for right border)
    add     hl, bc

.cont_1:
    call    BIOS_SETWRT
    ld      c, PORT_0
    ld      a, TILE_ARROW_UP
    out     (c), a

    ld      a, (ix + PROCESS_STRUCT_IX.height)
    sub     5
    ld      b, a
    ld      de, 32
    add     hl, de ; next line
.loop_1:
    call    BIOS_SETWRT
    ld      a, TILE_DOTS_VERTICAL
    out     (c), a
    add     hl, de ; next line
    djnz    .loop_1

    call    BIOS_SETWRT
    ld      c, PORT_0
    ld      a, TILE_ARROW_DOWN
    out     (c), a

    ; ------


    call    _GET_WINDOW_BASE_NAMTBL

    call    BIOS_SETWRT

    ; ld      de, TEST_NOTEPAD_DRAW_EVENT_STRING
    ; call    _DRAW_STRING


    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy

    ; ld      c, PORT_0

    ld      d, 0 ; counter for line width
    push    iy
.loop:
        ld      a, (iy + NOTEPAD_VARS.TEXT_START)
        cp      TEXT_END_OF_FILE
        jp      z, .endLoop
        
        ld      e, a

        ld      a, (ix + PROCESS_STRUCT_IX.windowState)
        cp      WINDOW_STATE.RESTORED
        jp      z, .isRestored

        ; check window width for maximized window
        ld      b, 32
        jp      .checkWidth

    .isRestored:
        ; check window width for restored window
        ld      a, (ix + PROCESS_STRUCT_IX.width)
        sub     3
        ld      b, a
        
    .checkWidth:
        ld      a, d
        ; A = line width, B = window width
        cp      b
        jp      nc, .ignore

        ld      a, e
        out     (PORT_0), a
    
    .ignore:

        inc     d
        inc     iy
        jp      .loop

.endLoop:
    pop     iy

    ret
