FNAME "msx-windows.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB

; Compilation address
    org 0x4000

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

; System
    INCLUDE "System/Constants.s"
    INCLUDE "System/Init/Init.s"

; Assets
    INCLUDE "Fonts/Font_Normal.s"
    INCLUDE "Graphics/Tiles.s"


; Apps
    INCLUDE "Apps/Notepad/Header.s"
    ;INCLUDE "Apps/Calc/Header.s"



Execute:

    ; routines named in uppercase means they are OS rotines
    ; _ on start means private routines while absence of underline means public routines

    call    _INIT

    ; DEBUG
    ; ld      hl, Notepad.Header
    ; call    _LOAD_PROCESS

    ; DEBUG
    ; ld      hl, (OS.currentProcessAddr)
    call    _DRAW_WINDOW
    ; call    _DRAW_WINDOW_TITLE

    ; DEBUG
    jp $

; TODO: put on a separate file
_DRAW_WINDOW:
    ; ld		hl, NAMTBL_TEST       ; RAM address (source)
    ; ld		de, NAMTBL		        ; VRAM address (destiny)
    ; ld		bc, NAMTBL_TEST.size	; Block length
    ; call 	BIOS_LDIRVM        	    ; Block transfer to VRAM from memory

    ; 9918 need 29 cycles apart from each OUT

    ; --------------- draw window title bar -----------------------
    
    ; first line of title bar
    ld  hl, NAMTBL + 10 + (20 * 32) ; DEBUG x=10, y=20
    push    hl
        call    BIOS_SETWRT
        
        ld      a, TILE_WINDOW_TITLE_TOP_LEFT
        out     (PORT_0), a

        ld      b, 16       ; debug (window width)
    .loop_1:    
        ld      a, TILE_WINDOW_TITLE_MIDDLE_TOP
        out     (PORT_0), a
        djnz    .loop_1

        nop
        nop
        ld      a, TILE_WINDOW_TOP_RIGHT_CORNER_TOP
        out     (PORT_0), a

    pop     hl
    ld      de, 32
    add     hl, de
   
    ; second line of title bar
    call    BIOS_SETWRT
    ld      a, TILE_WINDOW_TITLE_BOTTOM_LEFT
    out     (PORT_0), a
    ld      b, 16 - 3       ; debug (window width)
.loop_2:
    ld      a, TILE_WINDOW_TITLE_MIDDLE_BOTTOM
    out     (PORT_0), a
    djnz    .loop_2

    nop
    nop
    ld      a, TILE_WINDOW_MINIMIZE_BUTTON
    out     (PORT_0), a

    nop
    nop
    ld      a, TILE_WINDOW_MAXIMIZE_BUTTON
    out     (PORT_0), a

    nop
    nop
    ld      a, TILE_WINDOW_CLOSE_BUTTON
    out     (PORT_0), a

    nop
    nop
    ld      a, TILE_WINDOW_TOP_RIGHT_CORNER_BOTTOM
    out     (PORT_0), a

    ; -------------------------------------------------------------

    ret


    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xff



; RAM
	org     0xc000, 0xe5ff

    INCLUDE "System/Ram.s"
