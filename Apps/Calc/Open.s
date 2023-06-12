; Input
;   IX = base addr of this process slot on RAM

    ; ; get base NAMTBL of the window
    ; ; push    hl ; ix = hl
    ; ; pop     ix
    ; ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ; ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    ; call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    ; add     hl, bc

    call    _GET_WINDOW_BASE_NAMTBL

    ; debug
    ; write a test char 
    call    BIOS_SETWRT
    ld      a, TILE_FONT_UPPERCASE_A + 1 ; 'B'
    out     (PORT_0), a

    ret