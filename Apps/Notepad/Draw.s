; Input
;   IX = base addr of this process slot on RAM

    ; --- draw vertical scrollbar
    call    GET_WINDOW_NAMTBL_LAST_USEFUL_COLUMN

.cont_1:
    call    BIOS_SETWRT
    ld      c, PORT_0
    ld      a, TILE_ARROW_UP
    out     (c), a

    call    GET_WINDOW_USEFUL_HEIGHT
    sub     2 ; sub 1 because of the up arrow, sub 1 because of the down arrow 
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


    call    GET_USEFUL_WINDOW_BASE_NAMTBL

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
