; Input
;   HL = base addr of this process slot on RAM

    ; get base NAMTBL of the window
    push    hl ; ix = hl
    pop     ix
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      bc, NAMTBL + (32 * 4) + 1; 4 lines below and one column right
    add     hl, bc

    ; debug
    ; write a test char (units of seconds from system time)
    call    BIOS_SETWRT
    ld      a, (OS.currentTime_Seconds)
    and     0000 1111 b     ; get only low nibble (0-10 in BCD)

    ld      b, TILE_FONT_NUMBERS_0 + 0
    add     b
    out     (PORT_0), a

    ret