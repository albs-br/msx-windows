; Input:
;   HL = addr of process header
_RESTORE_PROCESS:

    ; IX = HL
    push    hl
    pop     ix

    ; set status = RESTORED
    ld      a, WINDOW_STATE.RESTORED
    ld      (ix + PROCESS_STRUCT_IX.windowState), a

    call    _SET_CURRENT_PROCESS

    call    _DISABLE_MOUSE_OVER

    ret