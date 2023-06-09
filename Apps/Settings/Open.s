; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; ; get RAM variables area of this process
    ; ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ; ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; push    hl ; IY = HL
    ; pop     iy

    ; init current tab var
    ld      a, SETTINGS_TABS_VALUES.TAB_VIDEO
    ld      (iy + SETTINGS_VARS.TAB_SELECTED), a


    xor     a
    ld      (iy + SETTINGS_VARS.CHECKBOX_SHOW_TICKS_VALUE), a

    ret
