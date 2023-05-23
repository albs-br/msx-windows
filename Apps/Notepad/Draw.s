; Input
;   IX = base addr of this process slot on RAM

    ; get variables from process
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    add     hl, bc

    ex      de, hl
    
    ld      hl, TEST_NOTEPAD_DRAW_EVENT_STRING
    ; ld      de, NAMTBL ; TODO: get correct addr
    call    _DRAW_STRING

    ret


TEST_NOTEPAD_DRAW_EVENT_STRING: db 'N DRAW', 0