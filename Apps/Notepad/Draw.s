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

    ld      c, PORT_0
    ; outi
    ld      a, (hl)
    out     (c), a

    ret


TEST_NOTEPAD_DRAW_EVENT_STRING: db 'N DRAW', 0