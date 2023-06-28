; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; ; get RAM variables area of this process
    ; ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ; ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; push    hl ; IY = HL
    ; pop     iy

    ld      a, TILE_COLOR_1 ; black color
    ld      (iy + PAINT_VARS.CURRENT_COLOR), a

    ret
