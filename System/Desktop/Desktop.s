    INCLUDE "System/Desktop/Taskbar.s"



_INIT_DESKTOP:

    ; ---- get icon patterns from app headers
    ; and put it on VRAM PATTBL
    
    ld      ix, Notepad.Header
    ld      l, (ix + PROCESS_STRUCT_IX.iconAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.iconAddr + 1)

    ;ld		hl, ????                                                ; RAM address (source)
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)		        ; VRAM address (destiny)
    ld		bc, NUMBER_OF_TILES_PER_ICON * 8	                    ; Block length
    call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory


    ld      ix, Calc.Header
    ld      l, (ix + PROCESS_STRUCT_IX.iconAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.iconAddr + 1)

    ;ld		hl, ????                                                ; RAM address (source)
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_1 * 8)		        ; VRAM address (destiny)
    ld		bc, NUMBER_OF_TILES_PER_ICON * 8	                    ; Block length
    call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory


    ; ---------------------------

    ; fill desktop with empty tiles
    ld      a, TILE_EMPTY
    ld      (OS.desktop_Tiles), a
    ld      hl, OS.desktop_Tiles
    ld      de, OS.desktop_Tiles + 1
    ld      bc, 0 + (32 * 22) - 1
    ldir


    ; draw icon on desktop buffer
    ;
    ;   XXX 
    ;   XXX
    ;   XXX
    ; notepad
    ; 
    ld      ix, Notepad.Header
    ld      a, TILE_BASE_DESKTOP_ICON_0
    ld      hl, OS.desktop_Tiles
    call    _DRAW_DESKTOP_ICON

    ld      ix, Calc.Header
    ld      a, TILE_BASE_DESKTOP_ICON_1
    ld      hl, OS.desktop_Tiles + 8
    call    _DRAW_DESKTOP_ICON

    ; ld      ix, Calc.Header
    ; ld      a, TILE_BASE_DESKTOP_ICON_0
    ; ld      hl, OS.desktop_Tiles + 16
    ; call    _DRAW_DESKTOP_ICON

    ret



_DRAW_DESKTOP_ICON:
    push    hl
        ld      de,  0 + (32 * 1) + 3
        add     hl, de
        
        ; ---
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
    pop     hl

    ; draw app name below icon
    ld      de, 0 + (32 * 4) + 1
    add     hl, de
    ld      b, 7 ; size of string
.loop_10:
    ld      a, (ix + PROCESS_STRUCT_IX.iconTitle)
    ; add     TILE_FONT_LOWERCASE_A - TILE_FONT_REVERSED_LOWERCASE_A ; print black chars on white bg
    ld      (hl), a
    inc     ix
    inc     hl
    djnz    .loop_10
.endLoop_10:


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


