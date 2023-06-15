; Input
;   IX = base addr of this process slot on RAM

    ; get variables from process
    ; ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ; ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    ; call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    ; add     hl, bc

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
        ld      b, (ix + PROCESS_STRUCT_IX.width)
        dec     b
        dec     b
        
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
