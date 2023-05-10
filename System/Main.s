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
    INCLUDE "System/Init.s"

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
    ; call    _DRAW_WINDOW
    ; call    _DRAW_WINDOW_TITLE

    ; DEBUG
    jp $





    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xff



; RAM
	org     0xc000, 0xe5ff

    INCLUDE "System/Ram.s"
