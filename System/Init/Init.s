    INCLUDE "System/Init/InitVdp.s"
    INCLUDE "System/Init/InitRam.s"




_INIT:

    ; disable keyboard click sound
    xor     a
    ld      (BIOS_CLIKSW), a

    call    _INIT_VDP

    call    _INIT_RAM

    call    _INIT_SYSTEM_TIME

    call    _INIT_INTERRUPT

    call    _INIT_DESKTOP



    ; ----------------------------------


    call    _DRAW_DESKTOP
    call    _DRAW_TASKBAR

    ret


