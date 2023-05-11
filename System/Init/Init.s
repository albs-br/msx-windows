    INCLUDE "System/Init/InitVdp.s"
    INCLUDE "System/Init/InitRam.s"




_INIT:

    call    _INIT_VDP

    call    _INIT_RAM

    ret


