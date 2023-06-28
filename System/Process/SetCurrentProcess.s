; Input:
;   HL = addr of process header
_SET_CURRENT_PROCESS:

    ; TODO:
    ; if is there a current process, run "LoseFocus" event of it

    ; set curr proc to process
    ld      (OS.currentProcessAddr), hl

    push    hl  ; IX = HL
    pop     ix

    push    hl
        ; get RAM variables area of this process
        ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
        ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

        push    hl ; IY = HL
        pop     iy



        ; run process "GetFocus" event
        ld      e, (ix + PROCESS_STRUCT_IX.getFocusAddr)         ; process.GetFocus addr (low)
        ld      d, (ix + PROCESS_STRUCT_IX.getFocusAddr + 1)     ; process.GetFocus addr (high)
        call    JP_DE
    pop     hl    

    push    hl
        ; get layer number
        ld      c, (ix + PROCESS_STRUCT_IX.layer)
        
        ; dec layer of all processes with layer > old layer
        call    _ADJUST_LAYER_OF_PROCESSES

        ; set the new current layer to NUMBER_OF_PROCESSES - 1
        call    _GET_NUMBER_OF_PROCESSES_OPENED
        dec     a
        ld      (ix + PROCESS_STRUCT_IX.layer), a
    pop     hl

    call    _UPDATE_SCREEN

    call    _DRAW_TASKBAR

    ; ; TODO
    ; push    hl ; ix = hl
    ; pop     ix
    ; call    _DRAW_WINDOW

    ; TODO
    ; place tile on window title to show it is the active window

    ret



