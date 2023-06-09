    INCLUDE "System/Desktop/Taskbar.s"


_INIT_DESKTOP:
    
    ld      ix, Notepad.Header
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)		        ; VRAM address (destiny)
    call    _LOAD_ICON_FROM_APP_HEADER
    ; call    _LOAD_ICON_INVERTED_FROM_APP_HEADER

    ld      ix, Calc.Header
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_1 * 8)		        ; VRAM address (destiny)
    call    _LOAD_ICON_FROM_APP_HEADER
    ; call    _LOAD_ICON_INVERTED_FROM_APP_HEADER

    ; ---

    ld      ix, Paint.Header
    ld		de, PATTBL + (256 * 8) + (TILE_BASE_DESKTOP_ICON_0 * 8)	; VRAM address (destiny)
    call    _LOAD_ICON_FROM_APP_HEADER

    ld      ix, TicTacToe.Header
    ld		de, PATTBL + (256 * 8) + (TILE_BASE_DESKTOP_ICON_1 * 8)	; VRAM address (destiny)
    call    _LOAD_ICON_FROM_APP_HEADER

    ; ---

    ld      ix, Settings.Header
    ld		de, PATTBL + (512 * 8) + (TILE_BASE_DESKTOP_ICON_0 * 8)	; VRAM address (destiny)
    call    _LOAD_ICON_FROM_APP_HEADER

    ld      ix, Tetra.Header
    ld		de, PATTBL + (512 * 8) + (TILE_BASE_DESKTOP_ICON_1 * 8)	; VRAM address (destiny)
    call    _LOAD_ICON_FROM_APP_HEADER

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

    ; tiles positioning:
    ;   1 4 7
    ;   2 5 8
    ;   3 6 9


    ; --- tile sequence on file (based on tinysprite export)
    ; slot    tile

    ; 0	        0
    ; 0	        1
    ; 2	        0

    ; 0	        2
    ; 0	        3
    ; 2	        2

    ; 1	        0
    ; 1	        1
    ; 3	        0

    ; top left icon
    ld      ix, Notepad.Header
    ld      a, TILE_BASE_DESKTOP_ICON_0
    ld      hl, OS.desktop_Tiles
    call    _DRAW_DESKTOP_ICON

    ; top right icon
    ld      ix, Calc.Header
    ld      a, TILE_BASE_DESKTOP_ICON_1
    ld      hl, OS.desktop_Tiles + 8
    call    _DRAW_DESKTOP_ICON



    ; mid left icon
    ld      ix, Paint.Header
    ld      a, TILE_BASE_DESKTOP_ICON_0
    ld      hl, OS.desktop_Tiles + (256)
    call    _DRAW_DESKTOP_ICON

    ; mid right icon
    ld      ix, TicTacToe.Header
    ld      a, TILE_BASE_DESKTOP_ICON_1
    ld      hl, OS.desktop_Tiles + (256) + 8
    call    _DRAW_DESKTOP_ICON



    ; bottom left icon
    ld      ix, Settings.Header
    ld      a, TILE_BASE_DESKTOP_ICON_0
    ld      hl, OS.desktop_Tiles + (512)
    call    _DRAW_DESKTOP_ICON

    ; bottom right icon
    ld      ix, Tetra.Header
    ld      a, TILE_BASE_DESKTOP_ICON_1
    ld      hl, OS.desktop_Tiles + (512) + 8
    call    _DRAW_DESKTOP_ICON

    ret



; Get icon patterns from app headers
; and put on VRAM PATTBL
; Input:
;   IX: app header on ROM
;   DE: VRAM PATTBL destiny address
_LOAD_ICON_FROM_APP_HEADER:

    ; ld      ix, ????.Header
    ld      l, (ix + PROCESS_STRUCT_IX.iconAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.iconAddr + 1)

    ;ld		hl, ????                                                ; RAM address (source)
    ;ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)		        ; VRAM address (destiny)
    ld		bc, NUMBER_OF_TILES_PER_ICON * 8	                    ; Block length
    call 	BIOS_LDIRVM

    ret



; Get icon patterns from app headers
; invert all bits of them and put on VRAM PATTBL
; Input:
;   IX: app header on ROM
;   DE: VRAM PATTBL destiny address
_LOAD_ICON_INVERTED_FROM_APP_HEADER:

    push    de
        ; ld      ix, ????.Header
        ld      l, (ix + PROCESS_STRUCT_IX.iconAddr)
        ld      h, (ix + PROCESS_STRUCT_IX.iconAddr + 1)

        ; ----- get icon pattern from app header and copy to RAM with all bits inverted
        ld      de, OS.tempIcon
        ld		bc, NUMBER_OF_TILES_PER_ICON * 8	                    ; Block length
        ldir

        ld      hl, OS.tempIcon
        ld		b, NUMBER_OF_TILES_PER_ICON * 8
    .loop_100:
        ld      a, (hl)
        cpl                 ; invert all bits of A
        ld      (hl), a
        inc     hl
        djnz    .loop_100

        ; or-mask to get borders filled
        ld      hl, OS.tempIcon
        ld      de, ICON_BORDERS_FILLED_OR_MASK
        ld		b, NUMBER_OF_TILES_PER_ICON * 8
    .loop_200:
        ld      a, (hl)
        ld      c, a
        ld      a, (de)
        or      c
        ld      (hl), a
        inc     hl
        inc     de
        djnz    .loop_200
        
        ; ------

    pop     de

    ld		hl, OS.tempIcon                                            ; RAM address (source)
    ;ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_1 * 8)		        ; VRAM address (destiny)
    ld		bc, NUMBER_OF_TILES_PER_ICON * 8	                    ; Block length
    call 	BIOS_LDIRVM

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
    ; sub     TILE_FONT_LOWERCASE_A - TILE_FONT_REVERSED_LOWERCASE_A ; print black chars on white bg
    ld      (hl), a
    inc     ix
    inc     hl
    djnz    .loop_10


    ret



_DRAW_DESKTOP_ICON_NAME_REVERSED:
    ; draw app name reversed below icon
    ld      de, 0 + (32 * 4) + 1
    add     hl, de
    ld      b, 7 ; size of string
.loop_10:
    ld      a, (ix + PROCESS_STRUCT_IX.iconTitle)
    cp      TILE_EMPTY
    jp      z, .cont_1

;     ld      a, TILE_EMPTY_BLACK
;     jp      .cont_1

; .cont:
    sub     TILE_FONT_LOWERCASE_A - TILE_FONT_REVERSED_LOWERCASE_A ; print black chars on white bg
.cont_1:
    ld      (hl), a
    inc     ix
    inc     hl
    djnz    .loop_10

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


ICON_BORDERS_FILLED_OR_MASK:
    db  11111111 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b

    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b

    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  10000000 b
    db  11111111 b

    db  11111111 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b

    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b

    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  00000000 b
    db  11111111 b


    db  11111111 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b

    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b

    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  00000001 b
    db  11111111 b
