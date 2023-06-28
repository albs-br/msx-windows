; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; --- draw vertical scrollbar
    call    GET_WINDOW_NAMTBL_LAST_USEFUL_COLUMN

    call    BIOS_SETWRT
    ld      c, PORT_0
    ld      a, TILE_ARROW_UP
    out     (c), a

    call    GET_WINDOW_USEFUL_HEIGHT
    sub     3 ; sub 1 because of the up arrow, sub 1 because of the down arrow 
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

    ; --- draw horizontal scrollbar
    ; call    GET_WINDOW_NAMTBL_LAST_USEFUL_COLUMN
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    push    hl
        call    GET_WINDOW_USEFUL_HEIGHT
        sub     1
        ld      h, 0
        ld      l, a
        add     hl, hl ; mult by 32 to convert from columns to lines
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        ex      de, hl
    pop     hl
    add     hl, de


    call    BIOS_SETWRT
    ld      c, PORT_0
    ld      a, TILE_ARROW_LEFT
    out     (c), a

    call    GET_WINDOW_USEFUL_WIDTH
    sub     3 ; decrease 2 for left and right arrows, plus 1
    ld      b, a
.loop_2:
    ld      a, TILE_DOTS_HORIZONTAL
    out     (c), a
    djnz    .loop_2

    ld      a, TILE_ARROW_RIGHT
    out     (c), a

    ; -------------------------------- Draw text


    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    call    BIOS_SETWRT

    ; ld      de, TEST_NOTEPAD_DRAW_EVENT_STRING
    ; call    _DRAW_STRING


    ; ; get RAM variables area of this process
    ; ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ; ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; push    hl ; IY = HL
    ; pop     iy

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
