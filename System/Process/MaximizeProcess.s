; Input:
;   HL = addr of process header
_MAXIMIZE_PROCESS:

    ; IX = HL
    push    hl
    pop     ix

    ; TODO:
    ; if (windowState == MAXIMIZED) ret

    ; set status = MAXIMIZED
    ld      a, WINDOW_STATE.MAXIMIZED
    ld      (ix + PROCESS_STRUCT_IX.windowState), a

    call    _SET_CURRENT_PROCESS

    ; call    _UPDATE_SCREEN

    call    _DISABLE_MOUSE_OVER

    ; call    _DRAW_TASKBAR    

    ret