; Input
;   IX = base addr of this process slot on RAM

    ; ; get base NAMTBL of the window
    ; ; push    hl ; ix = hl
    ; ; pop     ix
    ; ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ; ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    ; call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ld      bc, NAMTBL + (32 * 4) + 1; 4 lines below and one column right
    ; add     hl, bc

    call    _GET_WINDOW_BASE_NAMTBL

    ld      bc, (32 * 2) ; two lines below
    add     hl, bc

    ; debug
    ; write test chars (system time ticks counter)
    call    BIOS_SETWRT
    ld      a, (OS.timeCounter)
    ld      d, a ; save A reg
    
    and     1111 0000 b
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      b, TILE_FONT_NUMBERS_0 + 0
    add     b
    out     (PORT_0), a

    ld      a, d ; restore a
    and     0000 1111 b
    ld      b, TILE_FONT_NUMBERS_0 + 0
    add     b
    out     (PORT_0), a


    ret