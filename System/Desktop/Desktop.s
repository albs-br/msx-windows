    INCLUDE "System/Desktop/Taskbar.s"



_INIT_DESKTOP:
    ; TODO

    ; get icon patterns from app headers
    ; and put it on VRAM PATTBL
    
    ret

_DRAW_DESKTOP:

    ld      hl, NAMTBL
    call    BIOS_SETWRT
    ld      bc, 32 * 22
.loop:
    ld      a, TILE_EMPTY
    out     (PORT_0), a
    dec     bc
    ld      a, c
    or      b
    jp      nz, .loop


    ret


