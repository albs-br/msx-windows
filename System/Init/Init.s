    INCLUDE "System/Init/InitVdp.s"
    INCLUDE "System/Init/InitRam.s"




_INIT:

    call    _INIT_VDP

    call    _INIT_RAM

    call    _INIT_SYSTEM_TIME

    call    _INIT_INTERRUPT

    ; TODO:
    ; call    _DRAW_DESKTOP
    ; call    _DRAW_TASKBAR

    ret


