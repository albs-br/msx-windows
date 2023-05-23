; Input:
;   HL = addr of process header
_SET_CURRENT_PROCESS:

    ; not works...
    ; ; TODO: layer can be switched between CurrentProcess and HL
    ; push    hl
    ;     ; IX = new process
    ;     push    hl
    ;     pop     ix

    ;     ; IY = old process
    ;     ld      iy, (OS.currentProcessAddr)

    ;     ; B = new process layer
    ;     ld      b , (ix + PROCESS_STRUCT_IX.layer)

    ;     ; C = old process layer
    ;     ld      c , (iy + PROCESS_STRUCT_IX.layer)

    ;     ; new process receives old layer
    ;     ld      (ix + PROCESS_STRUCT_IX.layer), c

    ;     ; old process receives new layer
    ;     ld      (iy + PROCESS_STRUCT_IX.layer), b

    ; pop     hl

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

    push    hl
        call    _UPDATE_SCREEN_MAPPING
    pop     hl

    ; TODO
    push    hl ; ix = hl
    pop     ix
    call    _DRAW_WINDOW

    ; TODO
    ; place tile on window title to show it is the active window

    ret



