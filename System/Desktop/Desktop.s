    INCLUDE "System/Desktop/Taskbar.s"



_INIT_DESKTOP:
    ; TODO

    ; get icon patterns from app headers
    ; and put it on VRAM PATTBL



    ld      a, TILE_EMPTY
    ld      (OS.desktop_Tiles), a
    ld      hl, OS.desktop_Tiles
    ld      de, OS.desktop_Tiles + 1
    ld      bc, 0 + (32 * 22) - 1
    ldir


    ret



_DRAW_DESKTOP:

;     ld      hl, NAMTBL
;     call    BIOS_SETWRT
;     ld      bc, 32 * 22
; .loop:
;     ld      a, TILE_EMPTY
;     out     (PORT_0), a
;     dec     bc
;     ld      a, c
;     or      b
;     jp      nz, .loop

    ld      hl, NAMTBL
    call    BIOS_SETWRT
    ld      hl, OS.desktop_Tiles
    ld      c, PORT_0

    ld      d, 22 ; 22 lines
.outerLoop:
        ld      b, 32 ; 32 columns
    .innerLoop:
        outi
        jp      nz, .innerLoop ; this uses exactly 29 cycles (t-states)

    dec     d
    jp      nz, .outerLoop

    ret


