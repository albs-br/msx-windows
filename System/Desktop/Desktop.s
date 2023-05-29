    INCLUDE "System/Desktop/Taskbar.s"



_INIT_DESKTOP:

    ; get icon patterns from app headers
    ; and put it on VRAM PATTBL
    ld      ix, Notepad.Header
    ld      l, (ix + PROCESS_STRUCT_IX.iconAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.iconAddr + 1)

    ;ld		hl, ????                                                ; RAM address (source)
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICONS * 8)		        ; VRAM address (destiny)
    ld		bc, NUMBER_OF_TILES_PER_ICON * 8	                    ; Block length
    call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory



    ; fill desktop with empty tiles
    ld      a, TILE_EMPTY
    ld      (OS.desktop_Tiles), a
    ld      hl, OS.desktop_Tiles
    ld      de, OS.desktop_Tiles + 1
    ld      bc, 0 + (32 * 22) - 1
    ldir

    ;
    ;   XXX 
    ;   XXX
    ;   XXX
    ; notepad
    ; 
    ld      a, TILE_BASE_DESKTOP_ICON_0
    ld      hl, OS.desktop_Tiles + (32 * 1) + 3
    ld      de, 32

    ld      b, 3
.loop_1:
    push    hl
        ld      (hl), a
        
        inc     a
        add     hl, de
        ld      (hl), a

        inc     a
        add     hl, de
        ld      (hl), a

        inc     a
    pop     hl
    inc     hl

    djnz    .loop_1



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


