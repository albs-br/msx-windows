; Input
;   IX = base addr of this process slot on RAM

    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy



    ; if(currentTab == TIME) call "Draw" event
    ld      a, (iy + SETTINGS_VARS.TAB_SELECTED)
    cp      SETTINGS_TABS_VALUES.TAB_TIME
    ret     nz

    ; ; call "Draw" event of this process
    ; ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ; ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    ; call    JP_DE

    call    Settings_Draw.DrawClock

    ret
