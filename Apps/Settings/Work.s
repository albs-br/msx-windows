; Input
;   IX = base addr of this process slot on RAM


    ; if(currentTab == TIME) call "Draw" event
    ld      a, (SETTINGS_VARS.TAB_SELECTED)
    cp      SETTINGS_TABS_VALUES.TAB_TIME
    ret     nz

    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ret
