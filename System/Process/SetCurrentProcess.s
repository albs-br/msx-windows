; Input:
;   HL = addr of process header
_SET_CURRENT_PROCESS:



    ; set curr proc to process
    ld      (OS.currentProcessAddr), hl

    push    hl  ; IX = HL
    pop     ix

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



